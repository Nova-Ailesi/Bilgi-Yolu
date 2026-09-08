import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';

part 'models.g.dart';

/// Bilgi Yolu - Veri Modelleri
/// Tüm modeller Hive NoSQL veritabanı ile %100 offline-first çalışacak şekilde tasarlanmıştır.

@HiveType(typeId: 0)
class QuestionModel extends HiveObject {
  @HiveField(0)
  final String id; // SHA-256 hash ile üretilen benzersiz ID (tekrar engelleme garantisi)

  @HiveField(1)
  final String category; // ortaokul, lise, universite, ehliyet, acikogretim

  @HiveField(2)
  final String subCategory; // LGS, TYT, AYT, KPSS, Ehliyet vb.

  @HiveField(3)
  final String subject; // Ders adı (Matematik, Türkçe, Tarih vb.)

  @HiveField(4)
  final String topic; // Konu (Örn: Fonksiyonlar, Paragrafta Anlam)

  @HiveField(5)
  final String questionText;

  @HiveField(6)
  final List<String> options; // Şıklar: ["A) ...", "B) ...", "C) ...", "D) ..."]

  @HiveField(7)
  final int correctOptionIndex; // 0 = A, 1 = B, 2 = C, 3 = D, 4 = E

  @HiveField(8)
  final String explanation; // Soru çözüm analizi ve püf noktası

  @HiveField(9)
  final String difficulty; // kolay, orta, zor

  @HiveField(10)
  final int year; // Çıkmış soru yılı veya deneme yılı

  @HiveField(11)
  final String source; // MEB, ÖSYM, AÖF, AÖL, Ehliyet

  // SM-2 Spaced Repetition (Aralıklı Tekrar) Parametreleri
  @HiveField(12)
  int repetitions; // Tekrar sayısı

  @HiveField(13)
  double easeFactor; // SM-2 Kolaylık katsayısı (Varsayılan: 2.5)

  @HiveField(14)
  int intervalDays; // Bir sonraki tekrar aralığı (gün)

  @HiveField(15)
  DateTime? nextReviewDate; // Bir sonraki tekrar tarihi

  @HiveField(16)
  bool isWrongBookmarked; // Yanlış Defteri'ne eklendi mi?

  @HiveField(17)
  bool isFavorite; // Favorilere eklendi mi?

  QuestionModel({
    required this.id,
    required this.category,
    required this.subCategory,
    required this.subject,
    this.topic = 'Genel',
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    this.difficulty = 'orta',
    required this.year,
    required this.source,
    this.repetitions = 0,
    this.easeFactor = 2.5,
    this.intervalDays = 1,
    this.nextReviewDate,
    this.isWrongBookmarked = false,
    this.isFavorite = false,
  });

  // Getter alias for backwards compatibility
  int get correctIndex => correctOptionIndex;

  /// SHA-256 ile benzersiz soru hash ID üretici
  static String generateSha256Id({
    required String source,
    required String subCategory,
    required String subject,
    required String questionText,
  }) {
    final rawString = '${source.trim().toLowerCase()}_${subCategory.trim().toLowerCase()}_${subject.trim().toLowerCase()}_${questionText.trim()}';
    final bytes = utf8.encode(rawString);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final qText = json['questionText'] as String? ?? '';
    final src = json['source'] as String? ?? 'MEB/ÖSYM';
    final subCat = json['subCategory'] as String? ?? 'Genel';
    final subj = json['subject'] as String? ?? 'Genel';

    // Eğer id yoksa veya 64 karakterli SHA-256 hash değilse anında SHA-256 ile üret
    final rawId = json['id'] as String?;
    final generatedId = (rawId != null && rawId.length == 64)
        ? rawId
        : generateSha256Id(
            source: src,
            subCategory: subCat,
            subject: subj,
            questionText: qText,
          );

    return QuestionModel(
      id: generatedId,
      category: json['category'] as String? ?? 'genel',
      subCategory: subCat,
      subject: subj,
      topic: json['topic'] as String? ?? 'Genel',
      questionText: qText,
      options: (json['options'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      correctOptionIndex: json['correctOptionIndex'] as int? ?? json['correctIndex'] as int? ?? 0,
      explanation: json['explanation'] as String? ?? 'Detaylı çözüm hazırlanıyor.',
      difficulty: json['difficulty'] as String? ?? 'orta',
      year: json['year'] as int? ?? DateTime.now().year,
      source: src,
      repetitions: json['repetitions'] as int? ?? 0,
      easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? 2.5,
      intervalDays: json['intervalDays'] as int? ?? 1,
      nextReviewDate: json['nextReviewDate'] != null ? DateTime.parse(json['nextReviewDate']) : null,
      isWrongBookmarked: json['isWrongBookmarked'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'subCategory': subCategory,
      'subject': subject,
      'topic': topic,
      'questionText': questionText,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'correctIndex': correctOptionIndex,
      'explanation': explanation,
      'difficulty': difficulty,
      'year': year,
      'source': source,
      'repetitions': repetitions,
      'easeFactor': easeFactor,
      'intervalDays': intervalDays,
      'nextReviewDate': nextReviewDate?.toIso8601String(),
      'isWrongBookmarked': isWrongBookmarked,
      'isFavorite': isFavorite,
    };
  }
}

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String targetExam; // LGS, TYT, AYT, KPSS, Ehliyet, AÖF

  @HiveField(3)
  int cityCode; // 1-81 İl plaka kodu

  @HiveField(4)
  String cityName;

  @HiveField(5)
  String? schoolName;

  @HiveField(6)
  int xp; // Prompt ile tam uyumlu

  @HiveField(7)
  int level;

  @HiveField(8)
  int streak; // Prompt ile tam uyumlu

  @HiveField(9)
  DateTime? lastActiveDate;

  @HiveField(10)
  int totalSolvedCount;

  @HiveField(11)
  int correctSolvedCount;

  @HiveField(12)
  List<String> badges; // Prompt ile tam uyumlu

  @HiveField(13)
  bool isSchoolAmbassador;

  @HiveField(14)
  bool isCityCoordinator;

  @HiveField(15)
  List<String> solvedQuestionIds;

  UserModel({
    required this.id,
    required this.name,
    this.targetExam = 'TYT',
    this.cityCode = 6,
    this.cityName = 'Ankara',
    this.schoolName,
    this.xp = 0,
    this.level = 1,
    this.streak = 1,
    this.lastActiveDate,
    this.totalSolvedCount = 0,
    this.correctSolvedCount = 0,
    this.badges = const [],
    this.isSchoolAmbassador = false,
    this.isCityCoordinator = false,
    List<String>? solvedQuestionIds,
  }) : solvedQuestionIds = solvedQuestionIds ?? [];

  // Backward compatibility getters & setters
  int get totalXp => xp;
  set totalXp(int val) => xp = val;

  int get currentStreakDays => streak;
  set currentStreakDays(int val) => streak = val;

  List<String> get unlockedBadgeIds => badges;
  set unlockedBadgeIds(List<String> val) => badges = val;

  factory UserModel.initial() {
    return UserModel(
      id: 'local_user_1',
      name: 'Genç Bilgin',
      targetExam: 'TYT',
      cityCode: 6,
      cityName: 'Ankara',
      lastActiveDate: DateTime.now(),
      xp: 120,
      level: 1,
      streak: 1,
      badges: ['ilk_adim', 'bilgi_yolcusu'],
    );
  }

  double get successRate => totalSolvedCount > 0 ? (correctSolvedCount / totalSolvedCount) * 100 : 0.0;
}

@HiveType(typeId: 2)
class AwardModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String icon;

  @HiveField(4)
  final int requiredXp;

  @HiveField(5)
  final bool isUnlocked;

  AwardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.requiredXp,
    this.isUnlocked = false,
  });
}

@HiveType(typeId: 3)
class StoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String subtitle;

  @HiveField(3)
  final String content;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String author;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  bool isRead;

  StoryModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.category,
    required this.author,
    required this.createdAt,
    this.isRead = false,
  });
}
