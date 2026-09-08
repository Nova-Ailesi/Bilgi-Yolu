import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import '../services.dart';
import 'scraper_service.dart';

/// Bilgi Yolu - Arka Plan Periyodik Güncelleme Servisi (Workmanager)
/// 24 saatte bir arka planda sessizce çalışır:
/// GitHub Pages delta.json kontrol edilir, yeni sorular otomatik indirilip Hive'a eklenir.
const String syncQuestionsTaskName = 'com.nova.bilgi_yolu.sync_questions_task';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('Workmanager: Arka plan görevi başlatıldı: $task');

    try {
      if (task == syncQuestionsTaskName || task == Workmanager.iOSBackgroundTask) {
        // Arka plan izole alanında Hive'ı hazırla
        await StorageService.init();

        // Uzak delta.json dosyasından yeni soruları çek
        final addedCount = await ScraperService.syncQuestionsFromRemote();
        debugPrint('Workmanager: Arka plan senkronizasyonu tamamlandı. $addedCount yeni soru.');
      }
      return Future.value(true);
    } catch (err) {
      debugPrint('Workmanager Görev Hatası: $err');
      return Future.value(false);
    }
  });
}

class UpdateService {
  /// Workmanager'ı başlat ve 24 saatlik periyodik görevi kaydet
  static Future<void> initialize() async {
    try {
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: kDebugMode,
      );

      // 24 saatte bir çalışan periyodik senkronizasyon
      await Workmanager().registerPeriodicTask(
        'bilgi_yolu_24h_sync',
        syncQuestionsTaskName,
        frequency: const Duration(hours: 24),
        constraints: Constraints(
          networkType: NetworkType.connected, // Yalnızca internet varken çalış
          requiresBatteryNotLow: true, // Pil düşükken bataryayı tüketme
        ),
        existingWorkPolicy: ExistingWorkPolicy.keep,
      );

      debugPrint('UpdateService: 24 saatlik periyodik güncelleme görevi kuruldu.');
    } catch (e) {
      debugPrint('UpdateService: Workmanager başlatılamadı (Web veya Test ortamı): $e');
    }
  }

  /// Kullanıcı manuel olarak "Şimdi Güncelle" butonuna bastığında anında tetikleme
  static Future<int> triggerManualSync() async {
    return await ScraperService.syncQuestionsFromRemote();
  }
}
