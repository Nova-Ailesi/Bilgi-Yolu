import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Bilgi Yolu - Google AdMob Monetization Servisi
/// Bu proje %100 ücretsizdir: Abonelik, kota veya ücretli özellik yoktur.
/// Tek sürdürülebilirlik kaynağı etik ve kullanıcıyı boğmayan AdMob reklamlarıdır.
class AdService {
  static bool _isInitialized = false;

  // Proje ve Yayıncı Kimlik Bilgileri (Google Cloud / AdMob / AdSense)
  static const String publisherId = 'pub-6440512201259891';
  static const String customerId = '887-482-1136';
  static const String projectId = 'bilgi-yolu-155b4';
  static const String projectNumber = '833483152760';
  static const String appIdAndroid = 'ca-app-pub-6440512201259891~9895201651';

  // Test Ad Unit ID'leri (Google Resmi Test Birimleri)
  static final String _testBannerIdAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static final String _testInterstitialIdAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static final String _testRewardedIdAndroid = 'ca-app-pub-3940256099942544/5224354917';
  static final String _testRewardedInterstitialIdAndroid = 'ca-app-pub-3940256099942544/5354046379';

  // Canlı Üretim Ad Unit ID'leri (Google AdMob Konsolunda Tanımlı)
  // Banner: bilgeca-app-pub-6440512201259891/4740640994
  static const String _liveBannerIdAndroid = 'ca-app-pub-6440512201259891/4740640994';
  // Geçiş Reklamı (Interstitial): ExamMind 1ca-app-pub-6440512201259891/8780948039
  static const String _liveInterstitialIdAndroid = 'ca-app-pub-6440512201259891/8780948039';
  // Ödüllü Geçiş Reklamı (Rewarded Interstitial): ExamMindca-app-pub-6440512201259891/7969439565
  static const String _liveRewardedInterstitialIdAndroid = 'ca-app-pub-6440512201259891/7969439565';
  static const String _liveRewardedIdAndroid = 'ca-app-pub-6440512201259891/7969439565';

  static InterstitialAd? _interstitialAd;
  static RewardedAd? _rewardedAd;
  static RewardedInterstitialAd? _rewardedInterstitialAd;
  static int _quizSolveCount = 0; // Her 5 soruda bir interstitial göstermek için sayaç

  static String get bannerAdUnitId {
    if (kDebugMode) return _testBannerIdAndroid;
    return Platform.isAndroid ? _liveBannerIdAndroid : _testBannerIdAndroid;
  }

  static String get interstitialAdUnitId {
    if (kDebugMode) return _testInterstitialIdAndroid;
    return Platform.isAndroid ? _liveInterstitialIdAndroid : _testInterstitialIdAndroid;
  }

  static String get rewardedAdUnitId {
    if (kDebugMode) return _testRewardedIdAndroid;
    return Platform.isAndroid ? _liveRewardedIdAndroid : _testRewardedIdAndroid;
  }

  static String get rewardedInterstitialAdUnitId {
    if (kDebugMode) return _testRewardedInterstitialIdAndroid;
    return Platform.isAndroid ? _liveRewardedInterstitialIdAndroid : _testRewardedInterstitialIdAndroid;
  }

  /// AdMob SDK Başlatma
  static Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      loadInterstitialAd();
      loadRewardedAd();
      loadRewardedInterstitialAd();
    } catch (e) {
      debugPrint('AdMob başlatma hatası (Web veya Test ortamı): $e');
    }
  }

  /// Banner Reklam Oluşturucu
  static BannerAd createBannerAd({required Function() onAdLoaded}) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('AdMob: Banner reklam yüklendi.');
          onAdLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('AdMob: Banner reklam yüklenemedi: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  /// Interstitial (Geçiş Reklamı) Önceden Yükle
  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd(); // Bir sonrakini hazırla
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial yükleme başarısız: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Belirli periyotlarda (Örn: her 5 test sorusunda bir) Geçiş Reklamı Göster
  static void showInterstitialIfReady({bool force = false}) {
    _quizSolveCount++;
    if (force || _quizSolveCount % 5 == 0) {
      if (_interstitialAd != null) {
        _interstitialAd!.show();
        _interstitialAd = null;
      } else {
        loadInterstitialAd();
      }
    }
  }

  /// Rewarded (Ödüllü Reklam) Önceden Yükle
  static void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewardedAd = null;
              loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded reklam yükleme başarısız: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  /// Ödüllü Reklam Göster (Örn: Çözüm İpucu, Bonus XP veya Can Kazanma)
  static void showRewardedAd({required Function(RewardItem reward) onUserEarnedReward}) {
    if (_rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (adWithoutView, reward) {
          onUserEarnedReward(reward);
        },
      );
      _rewardedAd = null;
    } else {
      debugPrint('Rewarded reklam henüz hazır değil, tekrar yükleniyor.');
      loadRewardedAd();
    }
  }

  /// Rewarded Interstitial (Ödüllü Geçiş Reklamı) Önceden Yükle
  static void loadRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
      adUnitId: rewardedInterstitialAdUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedInterstitialAd = ad;
          _rewardedInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedInterstitialAd = null;
              loadRewardedInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewardedInterstitialAd = null;
              loadRewardedInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded Interstitial reklam yükleme başarısız: $error');
          _rewardedInterstitialAd = null;
        },
      ),
    );
  }

  /// Ödüllü Geçiş Reklamı Göster (Örn: Seviye Tamamlama veya Soru Çözüm Bonusu)
  static void showRewardedInterstitialAd({required Function(RewardItem reward) onUserEarnedReward}) {
    if (_rewardedInterstitialAd != null) {
      _rewardedInterstitialAd!.show(
        onUserEarnedReward: (adWithoutView, reward) {
          onUserEarnedReward(reward);
        },
      );
      _rewardedInterstitialAd = null;
    } else {
      debugPrint('Rewarded Interstitial reklam henüz hazır değil, tekrar yükleniyor.');
      loadRewardedInterstitialAd();
    }
  }
}
