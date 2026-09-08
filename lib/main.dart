import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens.dart';
import 'services.dart';
import 'services/ad_service.dart';
import 'services/scraper_service.dart';
import 'services/update_service.dart';

/// Bilgi Yolu - Türkiye %100 Ücretsiz Eğitim Platformu
/// Giriş Noktası (main.dart)
/// Hive NoSQL, Firebase, AdMob, Workmanager ve Scraper senkronizasyonunu başlatır.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Firebase Başlatma (Güvenli Başlatıcı)
  try {
    await Firebase.initializeApp();
    debugPrint('Firebase Core başarıyla başlatıldı.');
  } catch (e) {
    debugPrint('Firebase başlatma bilgisi: Yerel modda devam ediliyor: $e');
  }

  // 2. Hive Offline NoSQL Depolama Başlatma - Splash'te takılmayı engelle
  try {
    await StorageService.init().timeout(const Duration(seconds: 5));
  } catch (e) {
    debugPrint('Storage init hatası (devam ediliyor): $e');
  }

  // 3. İlk açılışta çevrimdışı fallback sorularını SHA-256 hash ile yükle
  try {
    await ScraperService.loadFallbackQuestionsIfEmpty().timeout(const Duration(seconds: 3));
  } catch (e) {
    debugPrint('Fallback yükleme hatası: $e');
  }

  // 4. AdMob SDK Başlatma (Rewarded + Interstitial + Banner) - Hata yutulur
  try {
    await AdService.initialize().timeout(const Duration(seconds: 3));
  } catch (e) {
    debugPrint('AdMob init hatası (devam ediliyor): $e');
  }

  // 5. Workmanager 24 Saatlik Otomatik Güncelleme Servisini Başlatma - Hata yutulur
  try {
    await UpdateService.initialize().timeout(const Duration(seconds: 3));
  } catch (e) {
    debugPrint('Workmanager init hatası (devam ediliyor): $e');
  }

  // 6. Uygulama açılışında otomatik senkronizasyon (2 saniye içinde arka planda başlar) - Hata yutulur
  Future.delayed(const Duration(seconds: 2), () async {
    try {
      debugPrint('Bilgi Yolu: 2s otomatik delta senkronizasyonu başlatılıyor...');
      final count = await ScraperService.syncQuestionsFromRemote().timeout(const Duration(seconds: 10));
      debugPrint('Bilgi Yolu: Otomatik senkronizasyon tamamlandı ($count yeni soru).');
    } catch (e) {
      debugPrint('Otomatik sync hatası (sessiz): $e');
    }
  });

  runApp(
    const ProviderScope(
      child: BilgiYoluApp(),
    ),
  );
}

class BilgiYoluApp extends StatelessWidget {
  const BilgiYoluApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Kurumsal Renk Paleti: Lacivert (#002366), Kırmızı (#E30A17), Beyaz (#FFFFFF)
    const primaryNavy = Color(0xFF002366);
    const primaryRed = Color(0xFFE30A17);

    return MaterialApp(
      title: 'Bilgi Yolu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryNavy,
          primary: primaryNavy,
          secondary: primaryRed,
          surface: Colors.grey.shade50,
        ),
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: primaryNavy,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryNavy,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
