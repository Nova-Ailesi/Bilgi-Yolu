/**
 * Bilgi Yolu - Google AdMob & AdSense Yapılandırması
 *
 * GitHub Repository: https://github.com/Nova-Ailesi/Bilgi-Yolu.git
 * AdSense Müşteri Kimliği: pub-6440512201259891
 * Proje Adı: Bilgi-Yolu
 * Proje Kimliği: bilgi-yolu-155b4
 * Proje Numarası: 833483152760
 * Müşteri Numarası: 887-482-1136
 */

export interface AdMobConfig {
  githubRepoUrl: string;
  projectName: string;
  projectId: string;
  projectNumber: string;
  customerId: string;
  publisherId: string;
  adSenseClientId: string;
  appId: string;
  bannerUnitId: string;
  rewardedInterstitialUnitId: string;
  interstitialUnitId: string;
}

export const ADMOB_CONFIG: AdMobConfig = {
  githubRepoUrl: 'https://github.com/Nova-Ailesi/Bilgi-Yolu.git',
  projectName: 'Bilgi-Yolu',
  projectId: 'bilgi-yolu-155b4',
  projectNumber: '833483152760',
  customerId: '887-482-1136',
  // AdSense Müşteri / Yayıncı Kimliği
  publisherId: 'pub-6440512201259891',
  adSenseClientId: 'ca-pub-6440512201259891',
  // Google Mobil Reklamlar (AdMob) Uygulama Kimliği
  appId: 'ca-app-pub-6440512201259891~9895201651',
  // Reklam Birimleri
  bannerUnitId: 'ca-app-pub-6440512201259891/4740640994',
  rewardedInterstitialUnitId: 'ca-app-pub-6440512201259891/7969439565',
  interstitialUnitId: 'ca-app-pub-6440512201259891/8780948039',
};

// AdSense Script Yükleme Yardımcısı
export const initAdSenseScript = (): void => {
  if (typeof window === 'undefined') return;

  const existingScript = document.querySelector('script[src*="adsbygoogle"]');
  if (!existingScript) {
    const script = document.createElement('script');
    script.async = true;
    script.src = `https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=${ADMOB_CONFIG.adSenseClientId}`;
    script.crossOrigin = 'anonymous';
    document.head.appendChild(script);
  }
};
