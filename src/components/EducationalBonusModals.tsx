import React, { useState, useEffect } from 'react';
import { X, Sparkles, Gift, Flame, Lightbulb, ChevronRight, CheckCircle2 } from 'lucide-react';

// 💡 Alt Eğitim ve Sınav İpucu Bandı (Teknik Reklam Yerine Eğitici İçerik)
export const EducationalTipBanner: React.FC = () => {
  const tips = [
    '💡 Altı çizili ve olumsuz köklü (değildir, yoktur) soruları iki kez okumak başarıyı %40 artırır.',
    '⚡ Yanlış yaptığın soruları "Yanlış Defteri"nden tekrar çözerek kalıcı hafızaya aktarabilirsin.',
    '🎯 Her gün düzenli 20 soru çözmek, haftada 140, ayda 600 soru ile sınav hedefine ulaştırır.',
    '🧠 Bilgi kartlarıyla aralıklı tekrar (SM-2) formülleri unutmayı engeller.',
    '🚗 Ehliyet sınavında geçiş üstünlüğü kuralı: Cankurtaran > Asayiş > İtfaiye > Sivil Savunma.',
    '📚 LGS ve YKS Türkçe\'de "Şey" sözcüğü her zaman ayrı yazılır (bir şey, her şey).',
  ];

  const [currentTipIndex, setCurrentTipIndex] = useState(0);

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentTipIndex((prev) => (prev + 1) % tips.length);
    }, 8000);
    return () => clearInterval(timer);
  }, [tips.length]);

  return (
    <div className="w-full bg-slate-900 border-t border-slate-800 p-2.5 select-none">
      <div className="max-w-4xl mx-auto flex items-center justify-between bg-blue-950/40 border border-blue-900/40 rounded-xl px-4 py-2 text-xs text-blue-200 transition-colors">
        <div className="flex items-center gap-2.5 overflow-hidden">
          <span className="bg-amber-400/20 text-amber-300 border border-amber-400/30 text-[10px] font-bold px-2 py-0.5 rounded-full shrink-0 flex items-center gap-1">
            <Lightbulb className="w-3 h-3" /> Püf Noktası
          </span>
          <span className="truncate font-medium text-slate-200">
            {tips[currentTipIndex]}
          </span>
        </div>
        <button
          onClick={() => setCurrentTipIndex((prev) => (prev + 1) % tips.length)}
          className="text-[11px] text-blue-400 hover:text-white flex items-center gap-0.5 whitespace-nowrap ml-2 shrink-0 cursor-pointer"
        >
          <span>Sıradaki</span>
          <ChevronRight className="w-3.5 h-3.5" />
        </button>
      </div>
    </div>
  );
};

// 🏆 Çalışma Arası Tebrik & Seri Modalı (Öğrenci Teşvik Kartı)
interface MilestoneModalProps {
  isOpen: boolean;
  onClose: () => void;
  title?: string;
  description?: string;
  isWeeklyStreakMilestone?: boolean;
  weeklyStreakWeeks?: number;
}

export const MilestoneCelebrationModal: React.FC<MilestoneModalProps> = ({
  isOpen,
  onClose,
  title,
  description,
  isWeeklyStreakMilestone = false,
  weeklyStreakWeeks = 3,
}) => {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 bg-black/75 backdrop-blur-sm flex items-center justify-center p-4">
      <div className="bg-slate-900 border border-blue-800/80 w-full max-w-sm rounded-2xl overflow-hidden shadow-2xl animate-in fade-in zoom-in duration-200">
        <div className="bg-[#002366] px-4 py-3 flex items-center justify-between border-b border-blue-800">
          <div className="flex items-center gap-2">
            <span className="bg-amber-400 text-slate-950 font-extrabold text-[10px] px-2 py-0.5 rounded-full">
              {isWeeklyStreakMilestone ? 'HAFTALIK HEDEF BAŞARISI' : 'HARİKA ODAKLANMA'}
            </span>
            <span className="text-xs text-blue-200 font-medium">
              {isWeeklyStreakMilestone ? 'Haftalık Seri Korundu' : 'Soru Serisi'}
            </span>
          </div>

          <button
            onClick={onClose}
            className="p-1 text-slate-300 hover:text-white rounded-lg hover:bg-white/10 transition-colors"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        <div className="p-6 text-center space-y-4">
          <div className="w-16 h-16 mx-auto bg-gradient-to-tr from-amber-500 to-orange-500 rounded-2xl flex items-center justify-center text-3xl shadow-lg animate-pulse">
            🔥
          </div>
          <div>
            <h4 className="font-bold text-lg text-white">
              {title || (isWeeklyStreakMilestone ? 'Günün 10 Soru Hedefi Tamamlandı!' : 'Azmin Sana Sınav Kazandıracak!')}
            </h4>
            <p className="text-xs text-slate-300 mt-1">
              {description || (isWeeklyStreakMilestone
                ? `Bugün en az 10 soru çözerek Haftalık Serini (${weeklyStreakWeeks}. Hafta) başarıyla devam ettirdin.`
                : 'Soruları dikkatle çözmeye devam ediyorsun. Beynin yeni bilgileri pekiştiriyor.')}
            </p>
          </div>

          <div className="bg-slate-800/60 rounded-xl p-3 text-left border border-slate-700/50 text-xs text-slate-300 space-y-2">
            <div className="flex items-center gap-2 text-emerald-400 font-semibold">
              <CheckCircle2 className="w-4 h-4" /> Bugünün 10 Soru Hedefi Tamamlandı ✓
            </div>
            <div className="flex items-center gap-2 text-amber-300 font-semibold">
              <Flame className="w-4 h-4 text-orange-400" /> {weeklyStreakWeeks} Haftalık Seri Aktif!
            </div>
            <div className="flex items-center gap-2 text-blue-300 text-[11px]">
              <Sparkles className="w-3.5 h-3.5 text-blue-400" /> Şehir ve okul puan tablosuna katkı sağlandı.
            </div>
          </div>

          <button
            onClick={onClose}
            className="w-full bg-[#002366] hover:bg-[#0A3D91] text-white py-3 rounded-xl text-sm font-bold transition-colors cursor-pointer shadow-md"
          >
            Öğrenmeye Devam Et 🚀
          </button>
        </div>
      </div>
    </div>
  );
};

// 🎁 Günlük Çalışma Sandığı & Başarı Ödülü Modalı
interface DailyBonusModalProps {
  isOpen: boolean;
  onClose: () => void;
  onRewardClaimed: () => void;
}

export const DailyBonusRewardModal: React.FC<DailyBonusModalProps> = ({
  isOpen,
  onClose,
  onRewardClaimed,
}) => {
  const [opened, setOpened] = useState(false);

  useEffect(() => {
    if (!isOpen) {
      setOpened(false);
    }
  }, [isOpen]);

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm flex items-center justify-center p-4">
      <div className="bg-slate-900 border border-slate-700 w-full max-w-sm rounded-2xl overflow-hidden shadow-2xl text-center animate-in fade-in zoom-in duration-200">
        <div className="bg-slate-800 px-4 py-3 flex items-center justify-between border-b border-slate-700">
          <div className="flex items-center gap-1.5 text-xs text-amber-400 font-bold">
            <Gift className="w-4 h-4" /> Günlük Çalışma Ödülü
          </div>
          <button onClick={onClose} className="text-slate-400 hover:text-white p-1 rounded-lg">
            <X className="w-4 h-4" />
          </button>
        </div>

        <div className="p-6 space-y-4">
          <div
            onClick={() => setOpened(true)}
            className="w-20 h-20 mx-auto bg-amber-500/20 text-amber-400 rounded-3xl flex items-center justify-center text-4xl border-2 border-amber-500/40 shadow-inner cursor-pointer hover:scale-105 transition-transform"
          >
            {opened ? '💎' : '🎁'}
          </div>

          <div>
            <h4 className="font-bold text-white text-base">
              {opened ? 'Tebrikler! Ödülün Açıldı' : 'Günün Başarı Sandığı'}
            </h4>
            <p className="text-xs text-slate-300 mt-1">
              {opened
                ? '+50 Bonus XP hesabına aktarıldı ve şehir ligine yansıtıldı!'
                : 'Sandığa tıklayarak bugünkü çalışma bonusunu topla.'}
            </p>
          </div>

          {opened ? (
            <button
              onClick={() => {
                onRewardClaimed();
                onClose();
              }}
              className="w-full bg-emerald-600 hover:bg-emerald-500 text-white py-3 rounded-xl font-bold text-sm transition-all cursor-pointer shadow-lg shadow-emerald-900/40"
            >
              +50 XP Al & Devam Et
            </button>
          ) : (
            <button
              onClick={() => setOpened(true)}
              className="w-full bg-amber-500 hover:bg-amber-400 text-slate-950 py-3 rounded-xl font-bold text-sm transition-all cursor-pointer shadow-lg shadow-amber-900/30"
            >
              Sandığı Aç ✨
            </button>
          )}
        </div>
      </div>
    </div>
  );
};
