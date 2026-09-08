import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models.dart';

/// Bilgi Yolu - Ana Depolama ve Algoritma Servisi (StorageService)
/// Hive NoSQL veritabanı ile %100 çevrimdışı, kota ve sunucu bağımsız çalışır.
class StorageService {
  static const String questionBoxName = 'questions_box';
  static const String userBoxName = 'user_box';
  static const String awardsBoxName = 'awards_box';
  static const String storiesBoxName = 'stories_box';

  static late Box<QuestionModel> questionBox;
  static late Box<UserModel> userBox;
  static late Box<AwardModel> awardsBox;
  static late Box<StoryModel> storiesBox;

  /// Hive Başlatma ve Kutu Açma - Splash takılmasını engelleyen güvenli kayıt
  static Future<void> init() async {
    try {
      await Hive.initFlutter();
    } catch (e) {
      // Hive zaten init edilmişse devam et
    }

    // Adapter kayıtları - Kritik: Kayıt olmadan Box açılırsa splash'te takılır
    try {
      if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(QuestionModelAdapter());
      if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(UserModelAdapter());
      if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(AwardModelAdapter());
      if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(StoryModelAdapter());
    } catch (e) {
      // Adapter zaten kayıtlıysa ignore
    }

    try {
      questionBox = await Hive.openBox<QuestionModel>(questionBoxName);
      userBox = await Hive.openBox<UserModel>(userBoxName);
      awardsBox = await Hive.openBox<AwardModel>(awardsBoxName);
      storiesBox = await Hive.openBox<StoryModel>(storiesBoxName);
    } catch (e) {
      // Box açma hatasında temizle ve yeniden dene (bozuk box)
      await Hive.deleteBoxFromDisk(questionBoxName);
      await Hive.deleteBoxFromDisk(userBoxName);
      await Hive.deleteBoxFromDisk(awardsBoxName);
      await Hive.deleteBoxFromDisk(storiesBoxName);
      questionBox = await Hive.openBox<QuestionModel>(questionBoxName);
      userBox = await Hive.openBox<UserModel>(userBoxName);
      awardsBox = await Hive.openBox<AwardModel>(awardsBoxName);
      storiesBox = await Hive.openBox<StoryModel>(storiesBoxName);
    }

    // İlk açılışta varsayılan kullanıcıyı oluştur
    if (userBox.isEmpty) {
      final initialUser = UserModel.initial();
      await userBox.put('current_user', initialUser);
    }

    // Başlangıç başarımlarını tanımla
    if (awardsBox.isEmpty) {
      await _seedAwards();
    }
  }

  /// Aktif Kullanıcıyı Getir
  static UserModel getCurrentUser() {
    return userBox.get('current_user') ?? UserModel.initial();
  }

  /// Kullanıcı Verisini Güncelle
  static Future<void> saveUser(UserModel user) async {
    await userBox.put('current_user', user);
  }

  /// =========================================================================
  /// SM-2 (SuperMemo-2) Aralıklı Tekrar Algoritması (Atlama Engelleme)
  /// =========================================================================
  /// Kalite Puanı (quality / q):
  /// 5: Mükemmel yanıt, anında hatırlandı
  /// 4: Doğru yanıt, hafif tereddüt
  /// 3: Doğru yanıt, zorlanarak hatırlandı
  /// 2: Yanlış yanıt, ancak doğru cevap hatırlandı
  /// 1: Yanlış yanıt, soru aşina geldi
  /// 0: Tamamen unutuldu / bilinmiyor
  static Map<String, dynamic> calculateSM2({
    required int quality,
    required int previousRepetitions,
    required double previousEaseFactor,
    required int previousInterval,
  }) {
    int nextRepetitions = previousRepetitions;
    double nextEaseFactor = previousEaseFactor;
    int nextInterval = previousInterval;

    if (quality >= 3) {
      // Başarılı hatırlama
      if (previousRepetitions == 0) {
        nextInterval = 1;
      } else if (previousRepetitions == 1) {
        nextInterval = 6;
      } else {
        nextInterval = (previousInterval * previousEaseFactor).round();
      }
      nextRepetitions = previousRepetitions + 1;
    } else {
      // Başarısız hatırlama: Tekrar başa sarılır (atlama engelleme garantisi)
      nextRepetitions = 0;
      nextInterval = 1;
    }

    // Ease Factor (EF) hesaplama formülü:
    // EF' = EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
    nextEaseFactor = previousEaseFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    
    // Ease Factor asla 1.3'ün altına düşmemelidir
    if (nextEaseFactor < 1.3) {
      nextEaseFactor = 1.3;
    }

    final nextReviewDate = DateTime.now().add(Duration(days: nextInterval));

    return {
      'repetitions': nextRepetitions,
      'easeFactor': double.parse(nextEaseFactor.toStringAsFixed(2)),
      'intervalDays': nextInterval,
      'nextReviewDate': nextReviewDate,
    };
  }

  /// Bir soruyu SM-2 ile güncelle
  static Future<void> recordFlashcardReview(String questionId, int quality) async {
    final question = questionBox.get(questionId);
    if (question == null) return;

    final sm2Result = calculateSM2(
      quality: quality,
      previousRepetitions: question.repetitions,
      previousEaseFactor: question.easeFactor,
      previousInterval: question.intervalDays,
    );

    question.repetitions = sm2Result['repetitions'] as int;
    question.easeFactor = sm2Result['easeFactor'] as double;
    question.intervalDays = sm2Result['intervalDays'] as int;
    question.nextReviewDate = sm2Result['nextReviewDate'] as DateTime;

    await question.save();

    // Kullanıcıya XP ver (Başarılı ise +15 XP, zorlandıysa +5 XP)
    final xpEarned = quality >= 3 ? 15 : 5;
    await addXp(xpEarned);
  }

  /// =========================================================================
  /// Soru Çözme ve İstatistik İşlemleri
  /// =========================================================================
  static Future<void> recordQuestionSolved({
    required String questionId,
    required bool isCorrect,
    required int selectedIndex,
  }) async {
    final user = getCurrentUser();
    user.totalSolvedCount++;

    final question = questionBox.get(questionId);

    if (isCorrect) {
      user.correctSolvedCount++;
      user.xp += 20; // Doğru soru: +20 XP
      
      // Eğer Yanlış Defterindeyse ve doğru çözüldüyse kaldırılır
      if (question != null && question.isWrongBookmarked) {
        question.isWrongBookmarked = false;
        await question.save();
      }
    } else {
      user.xp += 5; // Yanlış soru: Çaba için +5 XP
      
      // Yanlış yapıldıysa Yanlış Defteri'ne ekle
      if (question != null) {
        question.isWrongBookmarked = true;
        await question.save();
      }
    }

    // "Aynı soru asla iki kez gelmesin" kuralı: Çözülen soru ID'sini kaydet
    if (!user.solvedQuestionIds.contains(questionId)) {
      user.solvedQuestionIds.add(questionId);
    }

    // Seviye Kontrolü (Her 200 XP = +1 Level)
    final newLevel = max(1, (user.xp / 200).floor() + 1);
    if (newLevel > user.level) {
      user.level = newLevel;
    }

    // Günlük Seri (Streak) Kontrolü
    _checkDailyStreak(user);

    await saveUser(user);
  }

  /// Günlük Streak Kontrolü
  static void _checkDailyStreak(UserModel user) {
    final now = DateTime.now();
    if (user.lastActiveDate == null) {
      user.streak = 1;
      user.lastActiveDate = now;
      return;
    }

    final diff = now.difference(user.lastActiveDate!).inDays;
    if (diff == 1) {
      user.streak += 1;
      user.lastActiveDate = now;
    } else if (diff > 1) {
      user.streak = 1; // Seri kırıldı, yeniden başla
      user.lastActiveDate = now;
    }
  }

  /// XP Ekleme
  static Future<void> addXp(int xpAmount) async {
    final user = getCurrentUser();
    user.xp += xpAmount;
    user.level = max(1, (user.xp / 200).floor() + 1);
    await saveUser(user);
  }

  /// Yanlış Defteri Sorularını Getir
  static List<QuestionModel> getWrongNotebookQuestions() {
    return questionBox.values.where((q) => q.isWrongBookmarked).toList();
  }

  /// Aralıklı Tekrar (Bugün çalışılması gereken Flashcardlar)
  static List<QuestionModel> getDueFlashcards() {
    final now = DateTime.now();
    return questionBox.values.where((q) {
      if (q.nextReviewDate == null) return true; // Henüz çalışılmamış
      return q.nextReviewDate!.isBefore(now);
    }).toList();
  }

  /// Kategoriye göre soruları listele
  static List<QuestionModel> getQuestionsByCategory(String category, {String? subCategory}) {
    return questionBox.values.where((q) {
      if (subCategory != null && subCategory.isNotEmpty) {
        return q.category == category && q.subCategory == subCategory;
      }
      return q.category == category;
    }).toList();
  }

  /// KRİTİK KURAL: "Aynı soru asla iki kez gelmesin"
  /// Kullanıcının daha önce çözmediği benzersiz soruları getirir.
  static List<QuestionModel> getUnsolvedQuestionsByCategory(String category, {String? subCategory}) {
    final user = getCurrentUser();
    final solvedIds = user.solvedQuestionIds.toSet();

    final allCatQuestions = getQuestionsByCategory(category, subCategory: subCategory);

    // 1. Henüz çözülmemiş soruları filtrele
    final unsolved = allCatQuestions.where((q) => !solvedIds.contains(q.id)).toList();

    // 2. SHA-256 ID tekilliğini garanti et (liste içinde de tekrar olamaz)
    final uniqueMap = <String, QuestionModel>{};
    for (final q in unsolved) {
      uniqueMap[q.id] = q;
    }

    final result = uniqueMap.values.toList();
    // Rastgele karıştırarak sun
    result.shuffle();
    return result;
  }

  /// Bir sorunun daha önce çözülüp çözülmediğini sorgular
  static bool isQuestionSolved(String questionId) {
    final user = getCurrentUser();
    return user.solvedQuestionIds.contains(questionId);
  }

  /// Kullanıcı kategoriyi baştan çözmek isterse sıfırlama seçeneği
  static Future<void> resetSolvedQuestionsForCategory(String category) async {
    final user = getCurrentUser();
    final catQuestionIds = getQuestionsByCategory(category).map((q) => q.id).toSet();
    user.solvedQuestionIds.removeWhere((id) => catQuestionIds.contains(id));
    await saveUser(user);
  }

  /// =========================================================================
  /// Soru Tekrarı Engelleme (ID Hash Dedup) - Görev #3
  /// Aynı question.id zaten varsa atla, yoksa ekle. SHA-256 hash garantisi.
  /// Geriye eklenen benzersiz soru sayısını döndürür.
  /// =========================================================================
  static Future<int> saveAllQuestions(List<QuestionModel> questions) async {
    int inserted = 0;
    for (final q in questions) {
      if (!questionBox.containsKey(q.id)) {
        await questionBox.put(q.id, q);
        inserted++;
      }
    }
    return inserted;
  }

  /// Map listesi için overload: JSON -> QuestionModel -> dedup ile kaydet
  static Future<int> saveAllQuestionsFromJson(List<Map<String, dynamic>> rawList) async {
    int inserted = 0;
    for (final raw in rawList) {
      final q = QuestionModel.fromJson(raw);
      if (!questionBox.containsKey(q.id)) {
        await questionBox.put(q.id, q);
        inserted++;
      }
    }
    return inserted;
  }

  /// Varsayılan Başarımları Yükle
  static Future<void> _seedAwards() async {
    final awards = [
      AwardModel(
        id: 'ilk_adim',
        title: 'İlk Adım',
        description: 'Bilgi Yolu ailesine katıldın ve ilk sorunu çözdün.',
        icon: 'footprints',
        requiredXp: 20,
        isUnlocked: true,
      ),
      AwardModel(
        id: 'bilgi_yolcusu',
        title: 'Bilgi Yolcusu',
        description: '100 XP barajını aştın, temeller sağlam!',
        icon: 'compass',
        requiredXp: 100,
        isUnlocked: true,
      ),
      AwardModel(
        id: 'seri_ustasi',
        title: 'Seri Ustası',
        description: '7 gün üst üste her gün en az 10 soru çözdün.',
        icon: 'flame',
        requiredXp: 500,
      ),
      AwardModel(
        id: 'ehliyet_kaptani',
        title: 'Trafik Kurdu',
        description: 'Ehliyet sınavında tüm trafik sorularını doğru bildin.',
        icon: 'car',
        requiredXp: 800,
      ),
      AwardModel(
        id: 'sinav_sampiyonu',
        title: 'Sınav Şampiyonu',
        description: '1000 soruyu tamamlayarak zirveye yerleştin.',
        icon: 'trophy',
        requiredXp: 2000,
      ),
    ];

    for (final award in awards) {
      await awardsBox.put(award.id, award);
    }
  }
}

/// =========================================================================
/// QuestionGenerator: Benzersiz Soru Üretme & Tekrar Engelleme (SHA-256 Hash)
/// =========================================================================
class QuestionGenerator {
  /// SHA-256 Hash ID üreterek sorunun daha önce eklenip eklenmediğini kontrol eder.
  /// Eğer soru zaten varsa mevcut soruyu döndürür; yoksa yeni QuestionModel oluşturur ve Hive'a kaydeder.
  /// Bu sayede "SORU TEKRARI YOK" kuralı %100 matematiksel olarak garanti altına alınır.
  static Future<QuestionModel?> createUniqueQuestion({
    required String category,
    required String subCategory,
    required String subject,
    required String questionText,
    required List<String> options,
    required int correctOptionIndex,
    required String explanation,
    required int year,
    required String source,
    String topic = 'Genel',
    String difficulty = 'orta',
  }) async {
    // 1. SHA-256 Hash ID üret
    final hashId = QuestionModel.generateSha256Id(
      source: source,
      subCategory: subCategory,
      subject: subject,
      questionText: questionText,
    );

    // 2. Kutu kontrolü - Eğer aynı soru varsa tekrar ekleme!
    if (StorageService.questionBox.containsKey(hashId)) {
      return StorageService.questionBox.get(hashId);
    }

    // 3. Benzersiz yeni soru modeli oluştur
    final newQuestion = QuestionModel(
      id: hashId,
      category: category,
      subCategory: subCategory,
      subject: subject,
      topic: topic,
      questionText: questionText,
      options: options,
      correctOptionIndex: correctOptionIndex,
      explanation: explanation,
      difficulty: difficulty,
      year: year,
      source: source,
    );

    // 4. Hive NoSQL veritabanına kaydet
    await StorageService.questionBox.put(hashId, newQuestion);
    return newQuestion;
  }

  /// Verilen soru listesini SHA-256 hash deduplication yaparak topluca işler
  static Future<int> bulkInsertUniqueQuestions(List<Map<String, dynamic>> rawQuestions) async {
    int insertedCount = 0;
    for (final raw in rawQuestions) {
      final question = QuestionModel.fromJson(raw);
      if (!StorageService.questionBox.containsKey(question.id)) {
        await StorageService.questionBox.put(question.id, question);
        insertedCount++;
      }
    }
    return insertedCount;
  }
}
