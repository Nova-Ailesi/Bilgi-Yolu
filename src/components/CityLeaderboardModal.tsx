import React from 'react';
import { X, Trophy, MapPin, Users, Flame } from 'lucide-react';
import { cityRankings } from '../data/mockData';
import { UserProfile } from '../types';

interface CityLeaderboardModalProps {
  isOpen: boolean;
  onClose: () => void;
  user: UserProfile;
}

export const CityLeaderboardModal: React.FC<CityLeaderboardModalProps> = ({
  isOpen,
  onClose,
  user,
}) => {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm flex items-center justify-center p-4">
      <div className="bg-slate-900 border border-slate-700 w-full max-w-lg rounded-2xl overflow-hidden shadow-2xl flex flex-col max-h-[85vh]">
        {/* Üst Bar */}
        <div className="bg-[#002366] px-5 py-3.5 flex items-center justify-between text-white border-b border-blue-900">
          <div className="flex items-center gap-2 font-bold text-sm">
            <Trophy className="w-5 h-5 text-amber-400" />
            81 İl Başarı Sıralaması (Canlı)
          </div>
          <button onClick={onClose} className="text-blue-200 hover:text-white cursor-pointer">
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Kullanıcının Şehri Vurgusu */}
        <div className="bg-slate-800/80 p-3.5 border-b border-slate-700 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-xl bg-red-600 text-white font-extrabold flex items-center justify-center text-sm">
              {user.cityCode}
            </div>
            <div>
              <div className="text-xs font-bold text-white flex items-center gap-1.5">
                <MapPin className="w-3.5 h-3.5 text-red-400" />
                Şehrin: {user.cityName}
              </div>
              <p className="text-[11px] text-slate-400">
                Katkın: {user.totalSolvedCount} Soru • {user.totalXp} XP
              </p>
            </div>
          </div>
          <span className="bg-emerald-950 text-emerald-400 border border-emerald-800 text-[10px] font-bold px-2 py-1 rounded-full">
            Aktif Katılımcı
          </span>
        </div>

        {/* İl Listesi */}
        <div className="overflow-y-auto p-4 space-y-2 flex-1">
          {cityRankings.map((city, idx) => {
            const isTop3 = idx < 3;
            const isUserCity = city.name === user.cityName;
            const badgeColor =
              idx === 0
                ? 'bg-amber-400 text-slate-950'
                : idx === 1
                ? 'bg-slate-300 text-slate-950'
                : idx === 2
                ? 'bg-amber-700 text-white'
                : 'bg-slate-800 text-slate-400';

            return (
              <div
                key={city.code}
                className={`p-3 rounded-xl border flex items-center justify-between transition-all ${
                  isUserCity
                    ? 'bg-blue-950/50 border-blue-600'
                    : 'bg-slate-900/60 border-slate-800 hover:border-slate-700'
                }`}
              >
                <div className="flex items-center gap-3">
                  <div
                    className={`w-7 h-7 rounded-lg flex items-center justify-center font-bold text-xs ${badgeColor}`}
                  >
                    {city.rank}
                  </div>
                  <div>
                    <div className="text-sm font-bold text-white flex items-center gap-1.5">
                      {city.name}
                      <span className="text-[10px] text-slate-500 font-mono">({city.code})</span>
                      {isUserCity && (
                        <span className="text-[9px] bg-red-600 text-white font-bold px-1.5 py-0.2 rounded">
                          SEN
                        </span>
                      )}
                    </div>
                    <div className="text-[11px] text-slate-400 flex items-center gap-1">
                      <Users className="w-3 h-3 text-slate-500" />
                      {city.schools} Okul Katılıyor
                    </div>
                  </div>
                </div>

                <div className="text-right">
                  <div className="text-xs font-bold text-slate-200">
                    {city.solved.toLocaleString('tr-TR')} Soru
                  </div>
                  <div className="text-[10px] text-amber-400">
                    {city.xp.toLocaleString('tr-TR')} XP
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
};
