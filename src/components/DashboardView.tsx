import React from 'react';
import {
  BookOpen,
  GraduationCap,
  Landmark,
  Car,
  FileSpreadsheet,
  Zap,
  BookmarkCheck,
  Sparkles,
  HeartHandshake,
  ChevronRight,
  Flame,
  Award,
  PlaySquare,
  Gift,
  Target,
  Trophy,
  Clock,
  CheckCircle2,
} from 'lucide-react';
import { UserProfile } from '../types';
import { WeeklyGoalCard } from './WeeklyGoalCard';

interface DashboardViewProps {
  user: UserProfile;
  wrongCount: number;
  weeklySolvedDays?: number[];
  weeklyStreakWeeks?: number;
  dailyGoalTarget?: number;
  onStartDailyPractice?: () => void;
  onClaimWeeklyBonus?: () => void;
  onSelectCategory: (category: 'ortaokul' | 'lise' | 'universite' | 'ehliyet' | 'acikogretim', title: string) => void;
  onOpenFlashcards: () => void;
  onOpenWrongNotebook: () => void;
  onOpenStories: () => void;
  onOpenStressManagement: () => void;
  onOpenCertificate: () => void;
  onOpenAmbassador: () => void;
  onOpenLeaderboard: () => void;
  onOpenContest: () => void;
  onWatchRewardedAd: () => void;
}

export const DashboardView: React.FC<DashboardViewProps> = ({
  user,
  wrongCount,
  weeklySolvedDays = [14, 12, 16, 11, 15, 8, 0],
  weeklyStreakWeeks = 3,
  dailyGoalTarget = 10,
  onStartDailyPractice,
  onClaimWeeklyBonus,
  onSelectCategory,
  onOpenFlashcards,
  onOpenWrongNotebook,
  onOpenStories,
  onOpenStressManagement,
  onOpenCertificate,
  onOpenAmbassador,
  onOpenLeaderboard,
  onOpenContest,
  onWatchRewardedAd,
}) => {
  const categories = [
    {
      id: 'lise' as const,
      title: 'Lise & YKS (TYT - AYT)',
      sub: 'Matematik, Türkçe, Fizik, Kimya, Biyoloji, Tarih, Coğrafya',
      icon: GraduationCap,
      color: 'from-red-600 to-rose-900',
      badge: 'ÖSYM YKS 2025/2026',
      questionCount: '24.500+ Soru',
    },
    {
      id: 'ortaokul' as const,
      title: 'Ortaokul & LGS',
      sub: '5, 6, 7 ve 8. Sınıf MEB Kazanım & LGS Çıkmış Sorular',
      icon: BookOpen,
      color: 'from-blue-700 to-indigo-900',
      badge: 'MEB & LGS',
      questionCount: '18.200+ Soru',
    },
    {
      id: 'universite' as const,
      title: 'KPSS / ALES / DGS',
      sub: 'Genel Yetenek, Genel Kültür, Vatandaşlık, Güncel Bilgiler',
      icon: Landmark,
      color: 'from-blue-900 to-slate-900',
      badge: 'ÖSYM KPSS',
      questionCount: '32.000+ Soru',
    },
    {
      id: 'ehliyet' as const,
      title: 'MEB Ehliyet Sınavı',
      sub: 'Trafik & Çevre, İlk Yardım Bilgisi, Araç Tekniği, Trafik Adabı',
      icon: Car,
      color: 'from-emerald-700 to-teal-900',
      badge: 'E-Sınav Uyumlu',
      questionCount: '4.800+ Soru',
    },
    {
      id: 'acikogretim' as const,
      title: 'Açık Öğretim (AÖF & AÖL)',
      sub: 'Açık Öğretim Lisesi ve Anadolu/Atatürk AÖF Ortak Dersleri',
      icon: FileSpreadsheet,
      color: 'from-amber-600 to-orange-900',
      badge: 'AÖF & AÖL',
      questionCount: '9.400+ Soru',
    },
  ];

  return (
    <div className="p-4 sm:p-6 space-y-6 max-w-4xl mx-auto">
      {/* 🎓 Öğrenci Başarı & Motivasyon Kartı */}
      <div className="relative overflow-hidden rounded-2xl bg-gradient-to-br from-[#002366] via-[#0A3D91] to-[#001744] p-5 sm:p-6 text-white shadow-xl border border-blue-800/40">
        <div className="absolute top-0 right-0 -mr-6 -mt-6 w-36 h-36 bg-white/5 rounded-full blur-2xl pointer-events-none" />

        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <div className="flex items-center gap-4">
            <div className="relative shrink-0">
              <div className="w-16 h-16 sm:w-20 sm:h-20 rounded-2xl bg-white overflow-hidden shadow-lg border-2 border-[#E30A17] shrink-0 p-1 flex items-center justify-center">
                <img
                  src="/images/bilgi_yolu.png"
                  alt="Bilgi Yolu"
                  className="w-full h-full object-contain"
                />
              </div>
              <div className="absolute -bottom-1 -right-1 bg-emerald-500 text-white p-1 rounded-full border-2 border-slate-950">
                <Sparkles className="w-3.5 h-3.5" />
              </div>
            </div>

            <div className="min-w-0">
              <div className="flex items-center gap-2 flex-wrap">
                <h2 className="font-extrabold text-xl sm:text-2xl tracking-tight truncate">
                  Merhaba, {user.name}! 🎯
                </h2>
                <span className="bg-[#E30A17] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full uppercase tracking-wider shadow-sm">
                  {user.targetExam || 'YKS 2025'}
                </span>
              </div>
              <p className="text-xs sm:text-sm text-blue-200 mt-1">
                📍 {user.cityName} ({user.cityCode}) • {user.schoolName || 'Okul Belirtilmedi'}
              </p>

              {/* Seriler ve Puanlar */}
              <div className="flex items-center gap-2 mt-3 flex-wrap text-xs">
                <div className="flex items-center gap-1.5 bg-white/10 backdrop-blur-sm px-3 py-1 rounded-lg font-bold text-orange-300 border border-white/10">
                  <Flame className="w-4 h-4 text-orange-400 fill-orange-400" />
                  <span>{user.currentStreakDays} Günlük Seri</span>
                </div>
                <div className="flex items-center gap-1.5 bg-white/10 backdrop-blur-sm px-3 py-1 rounded-lg font-bold text-amber-300 border border-white/10">
                  <Award className="w-4 h-4 text-amber-400" />
                  <span>Seviye {user.level}</span>
                </div>
                <div className="bg-white/10 backdrop-blur-sm px-3 py-1 rounded-lg font-bold text-blue-100 border border-white/10">
                  {user.totalXp} Başarı Puanı (XP)
                </div>
              </div>
            </div>
          </div>

          {/* Günlük Hedef & Geri Sayım Widget */}
          <div className="bg-blue-950/70 border border-blue-800/60 rounded-xl p-3.5 sm:min-w-[210px] space-y-2 text-xs">
            <div className="flex items-center justify-between text-blue-200">
              <span className="font-medium flex items-center gap-1">
                <Target className="w-3.5 h-3.5 text-red-400" /> Günün Hedefi
              </span>
              <span className="font-bold text-amber-300">14 / 20 Soru</span>
            </div>
            <div className="w-full bg-blue-900/60 rounded-full h-2 overflow-hidden">
              <div className="bg-amber-400 h-2 rounded-full transition-all duration-500" style={{ width: '70%' }} />
            </div>
            <div className="flex items-center justify-between text-[11px] text-blue-300 pt-1 border-t border-blue-900/40">
              <span className="flex items-center gap-1">
                <Clock className="w-3 h-3 text-emerald-400" /> Sınava Kalan:
              </span>
              <span className="font-bold text-white">104 Gün</span>
            </div>
          </div>
        </div>

        {/* Atatürk'ün İlham Verici Sözü */}
        <div className="mt-4 pt-3 border-t border-white/10 text-xs text-blue-200/90 italic flex items-center gap-2">
          <span>“Hayatta en hakiki mürşit ilimdir, fendir.”</span>
          <span className="text-white/60 font-semibold not-italic text-[11px]">— M. Kemal Atatürk</span>
        </div>
      </div>

      {/* 🚀 Akıllı Öğrenme Modülleri (Dünya Standardı Eğitim Paneli) */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
        <button
          onClick={onOpenStories}
          className="flex flex-col items-center justify-center p-3.5 rounded-2xl bg-slate-900 border border-slate-800 hover:border-red-500/50 hover:bg-slate-800/80 transition-all text-center cursor-pointer group shadow-sm"
        >
          <div className="w-10 h-10 rounded-xl bg-red-500/20 text-red-400 flex items-center justify-center mb-2 group-hover:scale-110 transition-transform">
            <PlaySquare className="w-5 h-5" />
          </div>
          <span className="text-xs sm:text-sm font-bold text-slate-200">Günün Bilgisi</span>
          <span className="text-[10px] text-slate-400 mt-0.5">15 Sn Hap Notlar</span>
        </button>

        <button
          onClick={onOpenFlashcards}
          className="flex flex-col items-center justify-center p-3.5 rounded-2xl bg-slate-900 border border-slate-800 hover:border-amber-500/50 hover:bg-slate-800/80 transition-all text-center cursor-pointer group shadow-sm"
        >
          <div className="w-10 h-10 rounded-xl bg-amber-500/20 text-amber-400 flex items-center justify-center mb-2 group-hover:scale-110 transition-transform">
            <Zap className="w-5 h-5" />
          </div>
          <span className="text-xs sm:text-sm font-bold text-slate-200">Bilgi Kartları</span>
          <span className="text-[10px] text-slate-400 mt-0.5">Leitner Tekrarı</span>
        </button>

        <button
          onClick={onOpenWrongNotebook}
          className="flex flex-col items-center justify-center p-3.5 rounded-2xl bg-slate-900 border border-slate-800 hover:border-blue-500/50 hover:bg-slate-800/80 transition-all text-center cursor-pointer group shadow-sm relative"
        >
          <div className="w-10 h-10 rounded-xl bg-blue-500/20 text-blue-400 flex items-center justify-center mb-2 group-hover:scale-110 transition-transform">
            <BookmarkCheck className="w-5 h-5" />
            {wrongCount > 0 && (
              <span className="absolute -top-1.5 -right-1.5 bg-red-600 text-white text-[10px] font-bold px-1.5 py-0.2 rounded-full border border-slate-900">
                {wrongCount}
              </span>
            )}
          </div>
          <span className="text-xs sm:text-sm font-bold text-slate-200">Yanlış Defteri</span>
          <span className="text-[10px] text-slate-400 mt-0.5">Hatalardan Öğren</span>
        </button>

        <button
          onClick={onOpenStressManagement}
          className="flex flex-col items-center justify-center p-3.5 rounded-2xl bg-slate-900 border border-slate-800 hover:border-emerald-500/50 hover:bg-slate-800/80 transition-all text-center cursor-pointer group shadow-sm"
        >
          <div className="w-10 h-10 rounded-xl bg-emerald-500/20 text-emerald-400 flex items-center justify-center mb-2 group-hover:scale-110 transition-transform">
            <Sparkles className="w-5 h-5" />
          </div>
          <span className="text-xs sm:text-sm font-bold text-slate-200">Stres & Odak</span>
          <span className="text-[10px] text-slate-400 mt-0.5">Nefes & Pomodoro</span>
        </button>
      </div>

      {/* 🎯 Bu Haftanın Hedefi & Haftalık Seri (Streak) Kartı */}
      <WeeklyGoalCard
        user={user}
        weeklySolvedDays={weeklySolvedDays}
        weeklyStreakWeeks={weeklyStreakWeeks}
        dailyGoalTarget={dailyGoalTarget}
        onStartPractice={onStartDailyPractice || (() => onSelectCategory('lise', 'Lise & YKS'))}
        onClaimWeeklyBonus={onClaimWeeklyBonus}
      />

      {/* 📚 Sınavını Seç ve Soru Çöz */}
      <div>
        <div className="flex items-center justify-between mb-3">
          <h3 className="font-extrabold text-base sm:text-lg text-slate-100 flex items-center gap-2">
            <BookOpen className="w-5 h-5 text-blue-400" />
            Sınavını Seç & Soru Çözmeye Başla
          </h3>
          <span className="text-xs text-blue-300 font-medium bg-blue-950/60 border border-blue-800/60 px-2.5 py-1 rounded-lg">
            %100 MEB & ÖSYM Kazanım Uyumlu
          </span>
        </div>

        <div className="space-y-3">
          {categories.map((cat) => {
            const Icon = cat.icon;
            return (
              <div
                key={cat.id}
                onClick={() => onSelectCategory(cat.id, cat.title)}
                className="flex items-center justify-between p-4 rounded-2xl bg-slate-900 hover:bg-slate-850 border border-slate-800 hover:border-blue-700/60 transition-all cursor-pointer group shadow-sm"
              >
                <div className="flex items-center gap-4">
                  <div
                    className={`w-12 h-12 rounded-2xl bg-gradient-to-br ${cat.color} flex items-center justify-center text-white shadow-md group-hover:scale-105 transition-transform shrink-0`}
                  >
                    <Icon className="w-6 h-6" />
                  </div>
                  <div>
                    <div className="flex items-center gap-2 flex-wrap">
                      <h4 className="font-bold text-sm sm:text-base text-slate-100 group-hover:text-blue-300 transition-colors">
                        {cat.title}
                      </h4>
                      <span className="text-[10px] font-semibold bg-slate-800 text-slate-300 px-2 py-0.5 rounded-full border border-slate-700">
                        {cat.badge}
                      </span>
                    </div>
                    <p className="text-xs text-slate-400 mt-0.5">{cat.sub}</p>
                    <span className="text-[10px] text-emerald-400 font-medium mt-1 inline-block">
                      ✓ {cat.questionCount} • SHA-256 Tekrarsız Havuz
                    </span>
                  </div>
                </div>

                <div className="w-9 h-9 rounded-xl bg-slate-800 text-slate-400 flex items-center justify-center group-hover:bg-[#002366] group-hover:text-white transition-all shrink-0 ml-2">
                  <ChevronRight className="w-5 h-5" />
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* 🌟 81 İl ve Öğrenci Dayanışma Kulübü */}
      <div className="rounded-2xl bg-slate-900 border border-slate-800 p-4 sm:p-5 space-y-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2 text-sm font-bold text-slate-100">
            <HeartHandshake className="w-5 h-5 text-red-500" />
            Eğitimde Fırsat Eşitliği & Dayanışma Ağı
          </div>
          <span className="text-xs text-amber-400 font-semibold flex items-center gap-1">
            <Trophy className="w-3.5 h-3.5" /> 81 İl Liginde Yarış
          </span>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
          <button
            onClick={onOpenAmbassador}
            className="p-3 rounded-xl bg-slate-800/80 hover:bg-slate-800 text-left border border-slate-700/60 transition-all cursor-pointer"
          >
            <div className="text-xs font-bold text-white flex items-center justify-between">
              <span>Okul Elçisi Ol</span>
              <span className="text-[10px] text-red-400 font-extrabold">+150 XP</span>
            </div>
            <p className="text-[11px] text-slate-400 mt-1">Okulunu temsil et, arkadaşlarınla birlik ol</p>
          </button>

          <button
            onClick={onOpenLeaderboard}
            className="p-3 rounded-xl bg-slate-800/80 hover:bg-slate-800 text-left border border-slate-700/60 transition-all cursor-pointer"
          >
            <div className="text-xs font-bold text-white flex items-center justify-between">
              <span>81 İl Şampiyonası</span>
              <span className="text-[10px] text-blue-400 font-extrabold">Canlı Tablo</span>
            </div>
            <p className="text-[11px] text-slate-400 mt-1">{user.cityName} ilini zirveye taşı</p>
          </button>

          <button
            onClick={onOpenContest}
            className="p-3 rounded-xl bg-slate-800/80 hover:bg-slate-800 text-left border border-slate-700/60 transition-all cursor-pointer"
          >
            <div className="text-xs font-bold text-white flex items-center justify-between">
              <span>Soru Havuzuna Katkı</span>
              <span className="text-[10px] text-emerald-400 font-extrabold">+100 XP</span>
            </div>
            <p className="text-[11px] text-slate-400 mt-1">Kendi sorunu ekle, tüm Türkiye çözsün</p>
          </button>
        </div>

        {/* Günlük Bonus Sandığı & Resmi Sertifika */}
        <div className="flex flex-col sm:flex-row items-center gap-3 pt-2">
          <button
            onClick={onWatchRewardedAd}
            className="w-full sm:flex-1 bg-amber-500/15 hover:bg-amber-500/25 text-amber-300 border border-amber-500/40 rounded-xl py-2.5 px-4 text-xs font-bold flex items-center justify-center gap-2 transition-colors cursor-pointer"
          >
            <Gift className="w-4 h-4 text-amber-400" />
            Günün Başarı Sandığını Aç (+50 XP)
          </button>

          <button
            onClick={onOpenCertificate}
            className="w-full sm:flex-1 bg-blue-600/20 hover:bg-blue-600/30 text-blue-300 border border-blue-500/40 rounded-xl py-2.5 px-4 text-xs font-bold flex items-center justify-center gap-2 transition-colors cursor-pointer"
          >
            <Award className="w-4 h-4 text-blue-400" />
            Resmi Başarı & Katılım Sertifikam
          </button>
        </div>
      </div>
    </div>
  );
};
