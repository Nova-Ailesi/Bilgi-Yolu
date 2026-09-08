import React from 'react';
import { Flame, Award, HeartHandshake, MapPin, Sparkles, Target } from 'lucide-react';
import { UserProfile } from '../types';

interface HeaderNavProps {
  user: UserProfile;
  weeklyStreakWeeks?: number;
  onOpenAmbassador: () => void;
  onOpenLeaderboard: () => void;
  onOpenStressManagement?: () => void;
  onOpenCertificate?: () => void;
}

export const HeaderNav: React.FC<HeaderNavProps> = ({
  user,
  weeklyStreakWeeks = 3,
  onOpenAmbassador,
  onOpenLeaderboard,
  onOpenStressManagement,
  onOpenCertificate,
}) => {
  return (
    <header className="bg-[#002366] text-white border-b border-blue-900/60 sticky top-0 z-40 shadow-md">
      <div className="max-w-6xl mx-auto px-4 sm:px-6 py-3">
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
          
          {/* Logo & Platform Name */}
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl overflow-hidden bg-white shadow-md border-2 border-[#E30A17] shrink-0 flex items-center justify-center p-0.5">
              <img
                src="/images/bilgi_yolu.png"
                alt="Bilgi Yolu Logo"
                className="w-full h-full object-contain"
                onError={(e) => {
                  (e.target as HTMLElement).style.display = 'none';
                }}
              />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <span className="font-black text-xl tracking-tight text-white">BİLGİ YOLU</span>
                <span className="bg-[#E30A17] text-white text-[10px] font-bold px-2 py-0.5 rounded-full uppercase tracking-wider shadow-sm">
                  %100 Ücretsiz
                </span>
                <span className="bg-blue-800/80 text-blue-100 text-[10px] font-medium px-2 py-0.5 rounded-full flex items-center gap-1">
                  <Target className="w-3 h-3 text-red-400" />
                  {user.targetExam || 'YKS & LGS'}
                </span>
              </div>
              <p className="text-xs text-blue-200">Eğitimde Fırsat Eşitliği • Yeni Nesil Soru & Bilgi Platformu</p>
            </div>
          </div>

          {/* Student Status & Quick Actions */}
          <div className="flex items-center flex-wrap gap-2 text-xs">
            {/* Daily & Weekly Streak */}
            <div
              title={`${user.currentStreakDays} günlük soru serisi ve ${weeklyStreakWeeks} haftalık kesintisiz seri!`}
              className="flex items-center gap-1.5 bg-blue-950/70 hover:bg-blue-950 px-2.5 py-1.5 rounded-lg border border-blue-800/70 transition-colors"
            >
              <Flame className="w-4 h-4 text-orange-400 fill-orange-400 animate-pulse" />
              <span className="font-bold text-orange-300">{user.currentStreakDays} Gün</span>
              <span className="text-amber-300 font-bold border-l border-blue-800/80 pl-1.5 flex items-center gap-0.5">
                <span>{weeklyStreakWeeks} Hft Seri</span>
              </span>
            </div>

            {/* Level & XP */}
            <div
              title="Toplam çözülen sorulardan kazanılan başarı puanı"
              className="flex items-center gap-1.5 bg-blue-950/70 px-2.5 py-1.5 rounded-lg border border-blue-800/70"
            >
              <Award className="w-4 h-4 text-amber-400" />
              <span className="font-bold text-amber-300">Lvl {user.level}</span>
              <span className="text-blue-300">({user.totalXp} XP)</span>
            </div>

            {/* City Leaderboard */}
            <button
              onClick={onOpenLeaderboard}
              title="81 İl Canlı Başarı Sıralaması"
              className="flex items-center gap-1.5 bg-[#E30A17]/90 hover:bg-[#E30A17] text-white font-medium px-2.5 py-1.5 rounded-lg transition-colors cursor-pointer shadow-sm"
            >
              <MapPin className="w-3.5 h-3.5" />
              <span>{user.cityName} ({user.cityCode}) Ligi</span>
            </button>

            {/* School Ambassador */}
            <button
              onClick={onOpenAmbassador}
              title="Okulunu Bilgi Yolu'nda temsil et ve arkadaşlarınla yarış"
              className="flex items-center gap-1.5 bg-emerald-600/90 hover:bg-emerald-600 text-white font-medium px-2.5 py-1.5 rounded-lg transition-colors cursor-pointer shadow-sm"
            >
              <HeartHandshake className="w-3.5 h-3.5" />
              <span className="hidden sm:inline">Okul Elçisi</span>
            </button>

            {/* Stress & Focus quick shortcut */}
            {onOpenStressManagement && (
              <button
                onClick={onOpenStressManagement}
                title="Sınav Stresi ve Odaklanma Atölyesi"
                className="flex items-center gap-1 bg-blue-900/60 hover:bg-blue-900 border border-blue-700/60 text-blue-200 hover:text-white px-2.5 py-1.5 rounded-lg transition-colors cursor-pointer"
              >
                <Sparkles className="w-3.5 h-3.5 text-amber-300" />
                <span className="hidden sm:inline">Nefes & Odak</span>
              </button>
            )}
          </div>

        </div>
      </div>
    </header>
  );
};
