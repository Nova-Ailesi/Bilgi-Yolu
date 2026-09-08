import React, { useState } from 'react';
import {
  Flame,
  CheckCircle2,
  Calendar,
  Trophy,
  Sparkles,
  ArrowRight,
  Gift,
  Target,
  Clock,
  Zap,
} from 'lucide-react';
import { UserProfile } from '../types';

interface WeeklyGoalCardProps {
  user: UserProfile;
  weeklySolvedDays: number[];
  weeklyStreakWeeks: number;
  dailyGoalTarget: number;
  onStartPractice: () => void;
  onClaimWeeklyBonus?: () => void;
}

export const WeeklyGoalCard: React.FC<WeeklyGoalCardProps> = ({
  user,
  weeklySolvedDays,
  weeklyStreakWeeks,
  dailyGoalTarget = 10,
  onStartPractice,
  onClaimWeeklyBonus,
}) => {
  // Haftanın günleri (Pazartesi = 0 ... Pazar = 6)
  const daysInfo = [
    { name: 'Pazartesi', short: 'Pzt' },
    { name: 'Salı', short: 'Sal' },
    { name: 'Çarşamba', short: 'Çar' },
    { name: 'Perşembe', short: 'Per' },
    { name: 'Cuma', short: 'Cum' },
    { name: 'Cumartesi', short: 'Cmt' },
    { name: 'Pazar', short: 'Paz' },
  ];

  // JavaScript getDay(): 0 is Sunday, 1 is Monday ... 6 is Saturday
  // Normalize to 0 = Monday ... 6 = Sunday
  const todayJs = new Date().getDay();
  const currentDayIndex = todayJs === 0 ? 6 : todayJs - 1;

  // İstatistikler
  const totalQuestionsThisWeek = weeklySolvedDays.reduce((acc, curr) => acc + curr, 0);
  const weeklyTargetTotal = dailyGoalTarget * 7;
  const completedDaysCount = weeklySolvedDays.filter((count) => count >= dailyGoalTarget).length;
  const todaySolved = weeklySolvedDays[currentDayIndex] || 0;
  const isTodayGoalAchieved = todaySolved >= dailyGoalTarget;
  const todayRemaining = Math.max(0, dailyGoalTarget - todaySolved);
  const isAllWeekCompleted = completedDaysCount === 7;

  const [hasClaimedBonus, setHasClaimedBonus] = useState(false);

  return (
    <div className="rounded-2xl sm:rounded-3xl bg-gradient-to-br from-slate-900 via-blue-950/50 to-slate-900 border border-blue-800/50 p-4 sm:p-6 shadow-xl relative overflow-hidden">
      {/* Arka plan süslemesi */}
      <div className="absolute -top-12 -right-12 w-48 h-48 bg-orange-500/10 rounded-full blur-3xl pointer-events-none" />
      <div className="absolute -bottom-12 -left-12 w-48 h-48 bg-blue-500/10 rounded-full blur-3xl pointer-events-none" />

      {/* 🎯 Başlık & Haftalık Seri Rozeti */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-4 border-b border-slate-800/80">
        <div>
          <div className="flex items-center gap-2">
            <div className="w-9 h-9 rounded-xl bg-orange-500/20 text-orange-400 flex items-center justify-center border border-orange-500/30">
              <Flame className="w-5 h-5 fill-orange-400 animate-pulse" />
            </div>
            <div>
              <h3 className="font-black text-base sm:text-lg text-white flex items-center gap-2">
                Bu Haftanın Hedefi
                <span className="text-[11px] font-bold bg-blue-900/80 text-blue-200 px-2 py-0.5 rounded-full border border-blue-700/60">
                  Günde {dailyGoalTarget} Soru
                </span>
              </h3>
              <p className="text-xs text-slate-300">
                Her gün en az {dailyGoalTarget} soru çözerek haftalık serini koru ve ödülleri topla
              </p>
            </div>
          </div>
        </div>

        {/* Haftalık Seri Sayacı Rozeti */}
        <div className="flex items-center gap-2 self-start sm:self-auto bg-slate-950/80 border border-amber-500/40 px-3 py-2 rounded-xl shadow-inner">
          <div className="w-8 h-8 rounded-lg bg-gradient-to-tr from-amber-500 to-orange-500 flex items-center justify-center text-slate-950 font-black text-xs shadow-md">
            🔥
          </div>
          <div>
            <div className="text-[10px] text-amber-300 uppercase tracking-wider font-extrabold">
              Haftalık Seri (Streak)
            </div>
            <div className="text-sm font-black text-white flex items-center gap-1">
              <span>{weeklyStreakWeeks} Hafta Kesintisiz</span>
              <Sparkles className="w-3 h-3 text-amber-400" />
            </div>
          </div>
        </div>
      </div>

      {/* 📅 7 Günlük Görsel Matris (Pazartesi - Pazar) */}
      <div className="py-4">
        <div className="flex items-center justify-between mb-2 text-xs text-slate-400">
          <span className="font-semibold flex items-center gap-1.5 text-slate-200">
            <Calendar className="w-4 h-4 text-blue-400" />
            7 Günlük İlerleme Çizelgesi
          </span>
          <span className="text-[11px] text-amber-300 font-medium">
            {completedDaysCount} / 7 Gün Tamamlandı
          </span>
        </div>

        <div className="grid grid-cols-7 gap-1.5 sm:gap-2.5">
          {daysInfo.map((day, idx) => {
            const count = weeklySolvedDays[idx] || 0;
            const isCompleted = count >= dailyGoalTarget;
            const isToday = idx === currentDayIndex;
            const isPast = idx < currentDayIndex;
            const isFuture = idx > currentDayIndex;

            return (
              <div
                key={day.short}
                className={`relative rounded-xl p-2 sm:p-3 text-center transition-all flex flex-col items-center justify-between min-h-[90px] sm:min-h-[105px] border ${
                  isToday
                    ? isCompleted
                      ? 'bg-emerald-950/50 border-emerald-500 ring-2 ring-emerald-500/40 shadow-lg shadow-emerald-950/50'
                      : 'bg-blue-950/70 border-amber-500 ring-2 ring-amber-400/40 shadow-lg shadow-blue-950/50'
                    : isCompleted
                    ? 'bg-slate-800/80 border-emerald-500/50 shadow-sm'
                    : isPast
                    ? 'bg-slate-900/60 border-slate-800 text-slate-500'
                    : 'bg-slate-900/40 border-slate-800/60 text-slate-500 border-dashed'
                }`}
              >
                {/* Gün Etiketi & Bugün Rozeti */}
                <div>
                  <span
                    className={`text-[11px] sm:text-xs font-bold block ${
                      isToday ? 'text-amber-300' : isCompleted ? 'text-slate-200' : 'text-slate-400'
                    }`}
                  >
                    {day.short}
                  </span>
                  {isToday && (
                    <span className="bg-amber-400 text-slate-950 text-[9px] font-black px-1.5 py-0.2 rounded-full uppercase block mt-0.5">
                      Bugün
                    </span>
                  )}
                </div>

                {/* Görsel Durum İkonu */}
                <div className="my-1.5">
                  {isCompleted ? (
                    <div className="w-7 h-7 sm:w-8 sm:h-8 rounded-full bg-emerald-500/20 text-emerald-400 flex items-center justify-center border border-emerald-500/40 mx-auto shadow-sm">
                      <CheckCircle2 className="w-4 h-4 sm:w-5 sm:h-5 text-emerald-400" />
                    </div>
                  ) : isToday ? (
                    <div className="w-7 h-7 sm:w-8 sm:h-8 rounded-full bg-amber-500/20 text-amber-400 flex items-center justify-center border border-amber-500/40 mx-auto animate-pulse">
                      <Flame className="w-4 h-4 sm:w-5 sm:h-5 text-amber-400" />
                    </div>
                  ) : isPast ? (
                    <div className="w-7 h-7 sm:w-8 sm:h-8 rounded-full bg-slate-800 text-slate-500 flex items-center justify-center border border-slate-700 mx-auto text-xs font-bold">
                      {count}
                    </div>
                  ) : (
                    <div className="w-7 h-7 sm:w-8 sm:h-8 rounded-full bg-slate-900/60 text-slate-600 flex items-center justify-center border border-slate-800 mx-auto text-[10px]">
                      <Clock className="w-3.5 h-3.5" />
                    </div>
                  )}
                </div>

                {/* Soru Sayısı / Hedef Oranı */}
                <div className="text-[10px] sm:text-[11px] font-bold">
                  {isCompleted ? (
                    <span className="text-emerald-400">{count} Soru</span>
                  ) : isToday ? (
                    <span className="text-amber-300">
                      {count}/{dailyGoalTarget}
                    </span>
                  ) : isPast ? (
                    <span className="text-slate-500">{count}/{dailyGoalTarget}</span>
                  ) : (
                    <span className="text-slate-600">--</span>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* 📊 Haftalık Toplam İlerleme Çubuğu & Bugün Durumu */}
      <div className="bg-slate-950/60 rounded-xl p-3.5 sm:p-4 border border-slate-800/80 space-y-3">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 text-xs">
          <div className="flex items-center gap-2">
            <Target className="w-4 h-4 text-blue-400" />
            <span className="text-slate-300 font-medium">Bu Haftaki Toplam Soru:</span>
            <span className="font-extrabold text-white">
              {totalQuestionsThisWeek} / {weeklyTargetTotal} Soru
            </span>
          </div>

          <div className="flex items-center gap-2 text-[11px]">
            <span className="text-slate-400">Hedef Başarı Oranı:</span>
            <span className="font-bold text-amber-400">
              %{Math.min(100, Math.round((totalQuestionsThisWeek / weeklyTargetTotal) * 100))}
            </span>
          </div>
        </div>

        {/* İlerleme Çubuğu */}
        <div className="w-full bg-slate-800/80 rounded-full h-2.5 overflow-hidden">
          <div
            className={`h-2.5 rounded-full transition-all duration-700 ${
              isAllWeekCompleted
                ? 'bg-gradient-to-r from-emerald-500 to-teal-400'
                : 'bg-gradient-to-r from-amber-500 to-orange-500'
            }`}
            style={{
              width: `${Math.min(100, (totalQuestionsThisWeek / weeklyTargetTotal) * 100)}%`,
            }}
          />
        </div>

        {/* Bugünün Durumu ve Aksiyon Çağrısı */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pt-2 border-t border-slate-800/60">
          <div className="text-xs">
            {isTodayGoalAchieved ? (
              <div className="flex items-center gap-2 text-emerald-400 font-semibold">
                <CheckCircle2 className="w-4 h-4 shrink-0" />
                <span>Harika! Bugünün {dailyGoalTarget} soru hedefini tamamladın. Haftalık serin güvende!</span>
              </div>
            ) : (
              <div className="flex items-center gap-2 text-amber-300 font-medium">
                <Zap className="w-4 h-4 shrink-0 text-amber-400" />
                <span>
                  Bugünün hedefini tamamlamak için <strong>{todayRemaining} soru</strong> daha çözmelisin.
                </span>
              </div>
            )}
          </div>

          <div className="flex items-center gap-2 shrink-0">
            {/* 7/7 Hafta Tamamlandıysa Haftalık Şampiyon Sandığı */}
            {isAllWeekCompleted && !hasClaimedBonus && onClaimWeeklyBonus && (
              <button
                onClick={() => {
                  setHasClaimedBonus(true);
                  onClaimWeeklyBonus();
                }}
                className="bg-emerald-600 hover:bg-emerald-500 text-white text-xs font-bold px-3 py-2 rounded-xl flex items-center gap-1.5 transition-all shadow-md shadow-emerald-900/40 cursor-pointer animate-bounce"
              >
                <Gift className="w-4 h-4" />
                <span>+250 XP Ödülünü Al</span>
              </button>
            )}

            {/* Soru Çöz Aksiyon Butonu */}
            <button
              onClick={onStartPractice}
              className="bg-[#002366] hover:bg-[#0A3D91] text-white text-xs font-bold px-4 py-2 rounded-xl flex items-center gap-1.5 transition-colors cursor-pointer shadow-sm ml-auto sm:ml-0"
            >
              <span>{isTodayGoalAchieved ? 'Daha Fazla Soru Çöz' : 'Hedefi Tamamla (10 Soru)'}</span>
              <ArrowRight className="w-3.5 h-3.5" />
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};
