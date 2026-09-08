import React from 'react';
import { ArrowLeft, Share2, Download, Award, CheckCircle, ShieldCheck } from 'lucide-react';
import confetti from 'canvas-confetti';
import { UserProfile } from '../types';

interface CertificateViewProps {
  user: UserProfile;
  onBack: () => void;
}

export const CertificateView: React.FC<CertificateViewProps> = ({ user, onBack }) => {
  const todayStr = new Date().toLocaleDateString('tr-TR', {
    day: '2-digit',
    month: 'long',
    year: 'numeric',
  });

  const handleShare = () => {
    confetti({ particleCount: 90, spread: 80, origin: { y: 0.7 } });
    const text = `🎓 Bilgi Yolu Türkiye Genel Başarı Sertifikamı aldım!
Öğrenci: ${user.name}
Hedef: ${user.targetExam} (${user.cityName})
Seri: ${user.currentStreakDays} Gün | Çözülen Soru: ${user.totalSolvedCount}
Level: ${user.level} (${user.totalXp} XP)

%100 Ücretsiz Sınav Hazırlık Platformu: https://bilgiyolu.app/indir
#BilgiYolu #EğitimdeFırsatEşitliği`;

    if (navigator.share) {
      navigator.share({ title: 'Bilgi Yolu Başarı Sertifikası', text }).catch(() => {});
    } else {
      navigator.clipboard.writeText(text);
      alert('Sertifika başarı metni panoya kopyalandı! WhatsApp veya Instagram hikayenizde paylaşabilirsiniz.');
    }
  };

  return (
    <div className="p-4 sm:p-5 max-w-xl mx-auto space-y-4">
      <div className="flex items-center justify-between">
        <button
          onClick={onBack}
          className="flex items-center gap-1.5 text-xs text-slate-400 hover:text-white p-1 rounded-lg transition-colors cursor-pointer"
        >
          <ArrowLeft className="w-4 h-4" />
          <span>Geri</span>
        </button>
        <h3 className="font-bold text-sm text-white">Resmi Başarı Sertifikası</h3>
        <div className="w-12" />
      </div>

      {/* 📜 Prestijli Sertifika Çerçevesi (Beyaz zemin, Kırmızı & Lacivert Kenarlık) */}
      <div className="bg-white text-slate-900 rounded-2xl p-6 sm:p-8 border-4 border-[#E30A17] shadow-2xl space-y-6 relative overflow-hidden">
        {/* Köşe Motifleri */}
        <div className="absolute top-2 left-2 text-[#002366] text-xs font-serif font-bold">★ ★ ★</div>
        <div className="absolute top-2 right-2 text-[#002366] text-xs font-serif font-bold">★ ★ ★</div>
        <div className="absolute bottom-2 left-2 text-[#002366] text-xs font-serif font-bold">★ ★ ★</div>
        <div className="absolute bottom-2 right-2 text-[#002366] text-xs font-serif font-bold">★ ★ ★</div>

        {/* Başlık ve Amblem */}
        <div className="text-center space-y-1">
          <div className="w-16 h-16 mx-auto bg-white rounded-full overflow-hidden shadow-md border-2 border-red-600">
            <img
              src="/images/bilgi_yolu.png"
              alt="Bilgi Yolu Amblemi"
              className="w-full h-full object-cover"
            />
          </div>
          <h2 className="text-xl sm:text-2xl font-black tracking-widest text-[#002366] uppercase">
            BİLGİ YOLU
          </h2>
          <p className="text-[11px] font-bold tracking-wider text-[#E30A17] uppercase">
            TÜRKİYE DİJİTAL EĞİTİM VE SINAV PLATFORMU
          </p>
          <div className="w-24 h-0.5 bg-[#002366] mx-auto my-2" />
          <h3 className="text-xs sm:text-sm font-bold text-slate-700 tracking-wide uppercase">
            ÜSTÜN ÇALIŞMA VE AZİM SERTİFİKASI
          </h3>
        </div>

        {/* Öğrenci İsmi */}
        <div className="text-center py-2 border-b border-t border-slate-200">
          <p className="text-xs text-slate-500 uppercase tracking-wider font-semibold">Bu belge ile tescil olunur ki;</p>
          <h1 className="text-xl sm:text-2xl font-black text-slate-900 mt-1 uppercase tracking-tight">
            {user.name}
          </h1>
          <p className="text-xs text-slate-600 mt-2 leading-relaxed max-w-sm mx-auto">
            {user.cityName} ilimizde <span className="font-bold text-[#002366]">{user.targetExam}</span> hazırlık sürecinde <span className="font-bold text-[#E30A17]">{user.totalSolvedCount} soru</span> çözerek ve <span className="font-bold text-[#002366]">{user.currentStreakDays} günlük</span> kesintisiz çalışma serisi sergileyerek üstün bir disiplin göstermiştir.
          </p>
        </div>

        {/* İstatistikler Kutusu */}
        <div className="grid grid-cols-4 gap-2 bg-slate-50 p-3 rounded-xl border border-slate-200 text-center">
          <div>
            <div className="text-xs text-slate-500 font-medium">Seviye</div>
            <div className="font-extrabold text-[#002366] text-sm sm:text-base">Lvl {user.level}</div>
          </div>
          <div>
            <div className="text-xs text-slate-500 font-medium">Toplam XP</div>
            <div className="font-extrabold text-[#002366] text-sm sm:text-base">{user.totalXp}</div>
          </div>
          <div>
            <div className="text-xs text-slate-500 font-medium">Seri</div>
            <div className="font-extrabold text-[#E30A17] text-sm sm:text-base">{user.currentStreakDays} Gün</div>
          </div>
          <div>
            <div className="text-xs text-slate-500 font-medium">Doğruluk</div>
            <div className="font-extrabold text-emerald-700 text-sm sm:text-base">
              %{user.totalSolvedCount > 0 ? Math.round((user.correctSolvedCount / user.totalSolvedCount) * 100) : 100}
            </div>
          </div>
        </div>

        {/* Mühür & Tarih */}
        <div className="flex items-center justify-between pt-2 text-xs">
          <div className="text-left text-slate-500 space-y-0.5">
            <div>Tarih: <span className="font-medium text-slate-800">{todayStr}</span></div>
            <div>Belge No: <span className="font-mono text-slate-700">BY-2025-{user.cityCode}TR</span></div>
          </div>

          <div className="flex items-center gap-1.5 px-3 py-1.5 rounded-full border-2 border-red-600 bg-red-50 text-red-700 font-bold text-[10px] tracking-wider uppercase">
            <ShieldCheck className="w-3.5 h-3.5" />
            RESMİ MÜHÜRLÜ
          </div>
        </div>
      </div>

      {/* Paylaş Butonları */}
      <div className="flex items-center gap-3">
        <button
          onClick={handleShare}
          className="flex-1 bg-[#002366] hover:bg-blue-900 text-white font-bold py-3.5 px-4 rounded-xl flex items-center justify-center gap-2 shadow-lg transition-all cursor-pointer text-sm"
        >
          <Share2 className="w-4 h-4" />
          Instagram / WhatsApp'ta Paylaş
        </button>
      </div>
    </div>
  );
};
