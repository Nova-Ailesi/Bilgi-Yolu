import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models.dart';
import '../services.dart';

/// Bilgi Yolu - Otomatik Soru Çekme ve Senkronizasyon Servisi (ScraperService)
/// Özel bir backend sunucusu gerektirmez!
/// GitHub Actions her gün 03:00 UTC'de çalışıp GitHub Pages / RAW CDN üzerinde
/// "public/data/delta.json" dosyasını günceller.
/// Mobil uygulama açılışında veya Workmanager arka plan görevinde bu dosyayı çekerek
/// SHA-256 hash kontrolü ile tekrarı önler ve Hive'a kaydeder.
class ScraperService {
  // GitHub Pages / Raw CDN üzerindeki delta.json endpoint'i (Nova-Ailesi/Bilgi-Yolu)
  static const String remoteDeltaUrl =
      'https://raw.githubusercontent.com/Nova-Ailesi/Bilgi-Yolu/main/public/data/delta.json';

  /// Alias: Görev tanımındaki fetchFromBackend() ismi syncQuestionsFromRemote'a yönlenir
  /// (delta.json URL'si zaten tanımlı - aktif)
  static Future<int> fetchFromBackend() async => syncQuestionsFromRemote();

  /// GitHub Pages üzerinden yeni delta.json sorularını çek ve Hive'a kaydet
  static Future<int> syncQuestionsFromRemote() async {
    try {
      debugPrint('ScraperService: delta.json indiriliyor: $remoteDeltaUrl');
      final response = await http
          .get(Uri.parse(remoteDeltaUrl))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decoded = json.decode(utf8.decode(response.bodyBytes));
        final questionsList = decoded['questions'] as List<dynamic>? ?? [];

        int newAddedCount = 0;
        for (final item in questionsList) {
          final rawMap = item as Map<String, dynamic>;
          final question = QuestionModel.fromJson(rawMap);
          
          // SHA-256 Hash Kontrolü: Aynı soru daha önce eklenmişse ASLA tekrar eklenmez!
          if (!StorageService.questionBox.containsKey(question.id)) {
            await StorageService.questionBox.put(question.id, question);
            newAddedCount++;
          }
        }

        debugPrint('ScraperService: $newAddedCount yeni benzersiz soru başarıyla eklendi.');
        return newAddedCount;
      } else {
        debugPrint('ScraperService: Sunucu yanıt vermedi (${response.statusCode}), yerel fallback kontrol ediliyor.');
        return await loadFallbackQuestionsIfEmpty();
      }
    } catch (e) {
      debugPrint('ScraperService Hata: $e. Çevrimdışı fallback soruları yükleniyor.');
      return await loadFallbackQuestionsIfEmpty();
    }
  }

  /// Uygulama ilk açıldığında veya internetsiz ortamda kullanıcıyı asla boş bırakmamak için
  /// kapsamlı temel soru havuzunu yükler (Ortaokul LGS, Lise TYT/AYT, KPSS, Ehliyet, AÖF).
  /// Tüm sorular deterministik SHA-256 hash ID'leri ile saklanır.
  static Future<int> loadFallbackQuestionsIfEmpty() async {
    if (StorageService.questionBox.isNotEmpty) {
      return 0; // Zaten çevrimdışı depoda sorular var
    }

    final rawFallback = [
      // 1. Ortaokul - LGS Türkçe
      {
        'category': 'ortaokul',
        'subCategory': 'LGS',
        'subject': 'Türkçe',
        'topic': 'Cümlede Anlam',
        'questionText': 'Aşağıdaki cümlelerin hangisinde "koşul-sonuç" ilişkisi vardır?',
        'options': [
          'A) Akşamları kitap okuduğu için kelime dağarcığı çok zengin.',
          'B) Havalar ısınırsa hafta sonu hep birlikte pikniğe gideriz.',
          'C) Sınavda başarılı olmak amacıyla her gün düzenli soru çözüyor.',
          'D) Kar yağışı yüzünden köy yolları ulaşıma kapandı.',
        ],
        'correctOptionIndex': 1,
        'explanation': 'B şıkkında pikniğe gitme eyleminin gerçekleşmesi "havaların ısınması" şartına/koşuluna bağlanmıştır (-sa/-se eki).',
        'year': 2024,
        'source': 'MEB LGS',
        'difficulty': 'orta',
      },

      // 2. Ortaokul - LGS Matematik
      {
        'category': 'ortaokul',
        'subCategory': 'LGS',
        'subject': 'Matematik',
        'topic': 'Kareköklü İfadeler',
        'questionText': 'Alanı 144 cm² olan kare şeklindeki bir kartonun çevresi kaç santimetredir?',
        'options': ['A) 36', 'B) 48', 'C) 52', 'D) 72'],
        'correctOptionIndex': 1,
        'explanation': 'Karenin alanı a² = 144 ise bir kenar a = √144 = 12 cm\'dir. Çevresi: 4 * 12 = 48 cm\'dir.',
        'year': 2023,
        'source': 'MEB LGS',
        'difficulty': 'kolay',
      },

      // 3. Lise - TYT Matematik
      {
        'category': 'lise',
        'subCategory': 'TYT',
        'subject': 'Matematik',
        'topic': 'Üslü Sayılar',
        'questionText': '3^(x+1) = 24 olduğuna göre, 3^x kaçtır?',
        'options': ['A) 6', 'B) 8', 'C) 12', 'D) 18', 'E) 21'],
        'correctOptionIndex': 1,
        'explanation': '3^(x+1) = 3^x * 3^1 = 24 olduğuna göre, her iki tarafı 3\'e böldüğümüzde 3^x = 24 / 3 = 8 bulunur.',
        'year': 2024,
        'source': 'ÖSYM TYT',
        'difficulty': 'kolay',
      },

      // 4. Lise - TYT Türkçe
      {
        'category': 'lise',
        'subCategory': 'TYT',
        'subject': 'Türkçe',
        'topic': 'Yazım Kuralları',
        'questionText': 'Aşağıdaki cümlelerin hangisinde bir yazım yanlışı yapılmıştır?',
        'options': [
          'A) Bu konuda hiçbir şey göründüğü kadar basit değil.',
          'B) Akşamki konserde herkes bir arada şarkı söyledi.',
          'C) 29 Ekim 1923\'de Cumhuriyet ilan edildi.',
          'D) Türk Dil Kurumu\'nun yeni sözlüğü yayımlandı.',
          'E) Pek çok öğrenci kütüphanede ders çalışıyordu.',
        ],
        'correctOptionIndex': 2,
        'explanation': 'C şıkkında 1923 sayısı "üç" ile biter (sert ünsüz "ç"). Sertleşme kuralına göre ek "1923\'te" olmalıdır.',
        'year': 2023,
        'source': 'ÖSYM TYT',
        'difficulty': 'orta',
      },

      // 5. Lise - TYT Fizik
      {
        'category': 'lise',
        'subCategory': 'TYT',
        'subject': 'Fizik',
        'topic': 'Dinamik',
        'questionText': 'Sürtünmesiz yatay bir düzlemde durmakta olan 4 kg kütleli bir cisme 20 N büyüklüğünde yatay bir kuvvet uygulandığında cismin ivmesi kaç m/s² olur?',
        'options': ['A) 2', 'B) 4', 'C) 5', 'D) 10', 'E) 80'],
        'correctOptionIndex': 2,
        'explanation': 'Newton\'un 2. Hareket Yasası\'na göre F = m * a. 20 = 4 * a => a = 5 m/s² bulunur.',
        'year': 2024,
        'source': 'ÖSYM TYT',
        'difficulty': 'kolay',
      },

      // 6. Üniversite - KPSS Tarih
      {
        'category': 'universite',
        'subCategory': 'KPSS',
        'subject': 'Tarih',
        'topic': 'Milli Mücadele',
        'questionText': 'Amasya Genelgesi\'nde yer alan "Milletin bağımsızlığını yine milletin azim ve kararı kurtaracaktır." maddesi Milli Mücadele\'nin hangi yönünü ifade eder?',
        'options': [
          'A) Sadece gerekçesini',
          'B) Amaç ve yöntemini',
          'C) Dış politikasını',
          'D) Ekonomik programını',
          'E) Askeri teşkilatlanmasını',
        ],
        'correctOptionIndex': 1,
        'explanation': '"Milletin bağımsızlığı" kurtuluşun amacını, "milletin azim ve kararı" ise izlenecek yöntemi ve halk iradesini ortaya koymaktadır.',
        'year': 2023,
        'source': 'ÖSYM KPSS',
        'difficulty': 'orta',
      },

      // 7. Üniversite - KPSS Vatandaşlık
      {
        'category': 'universite',
        'subCategory': 'KPSS',
        'subject': 'Vatandaşlık',
        'topic': 'Yasama',
        'questionText': '1982 Anayasası\'na göre Türkiye Büyük Millet Meclisi (TBMM) kaç milletvekilinden oluşur?',
        'options': ['A) 450', 'B) 500', 'C) 550', 'D) 600', 'E) 650'],
        'correctOptionIndex': 3,
        'explanation': '2017 Anayasa değişikliği ile TBMM\'deki milletvekili sayısı 550\'den 600\'e çıkarılmıştır.',
        'year': 2024,
        'source': 'ÖSYM KPSS',
        'difficulty': 'kolay',
      },

      // 8. Ehliyet - Trafik Kuralları
      {
        'category': 'ehliyet',
        'subCategory': 'MEB Ehliyet',
        'subject': 'Trafik Kuralları',
        'topic': 'Trafik İşaretleri',
        'questionText': 'Trafik polisinin kollarını yana açması veya bir kolunu yukarı kaldırıp diğerini yana açması durumunda polisin ön ve arka cephesindeki araçlar için trafik durumu nedir?',
        'options': [
          'A) Yol trafiğe açıktır',
          'B) Yol trafiğe kapalıdır (Dur)',
          'C) Hızlanarak geçilebilir',
          'D) Sadece toplu taşıma araçları geçebilir',
        ],
        'correctOptionIndex': 1,
        'explanation': 'Trafik polisinin ön ve arka cephesinde kalan araçlar için yol trafiğe kapalıdır (DUR).',
        'year': 2024,
        'source': 'MEB E-Sınav',
        'difficulty': 'kolay',
      },

      // 9. Ehliyet - İlk Yardım
      {
        'category': 'ehliyet',
        'subCategory': 'MEB Ehliyet',
        'subject': 'İlk Yardım',
        'topic': 'Koma Pozisyonu',
        'questionText': 'Koma pozisyonu (yarı yüzükoyun yan yatış) hangi durumdaki kazazedelere verilir?',
        'options': [
          'A) Bilinci açık, bacağında kırık olanlara',
          'B) Kalp masajı yapılanlara',
          'C) Bilinci kapalı fakat solunumu ve nabzı olanlara',
          'D) Omurga kırığı şüphesi bulunanlara',
        ],
        'correctOptionIndex': 2,
        'explanation': 'Koma pozisyonu, bilinci kapalı ancak solunum ve kalp atışı devam eden kişilerin hava yolunu açık tutmak için verilir.',
        'year': 2024,
        'source': 'MEB E-Sınav',
        'difficulty': 'kolay',
      },

      // 10. Açık Öğretim - AÖF Temel Hukuk
      {
        'category': 'acikogretim',
        'subCategory': 'AÖF',
        'subject': 'Temel Hukuk',
        'topic': 'Normlar Hiyerarşisi',
        'questionText': 'Yazılı bir hukuk kuralının yürürlükten kalkması için aynı veya üst düzeyde yeni bir kural tarafından yürürlükten kaldırılmasına ne ad verilir?',
        'options': ['A) İltibas', 'B) İlga (Mülga)', 'C) Butlan', 'D) İptal', 'E) Fesih'],
        'correctOptionIndex': 1,
        'explanation': 'Bir kanunun ya da normun yetkili makamca yürürlükten kaldırılmasına "İlga", yürürlükten kalkmış metne ise "Mülga" denir.',
        'year': 2023,
        'source': 'Anadolu Üniversitesi AÖF',
        'difficulty': 'orta',
      },
    ];

    int inserted = 0;
    for (final raw in rawFallback) {
      final q = QuestionModel.fromJson(raw);
      if (!StorageService.questionBox.containsKey(q.id)) {
        await StorageService.questionBox.put(q.id, q);
        inserted++;
      }
    }

    return inserted;
  }
}
