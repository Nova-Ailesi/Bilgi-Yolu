import React, { useState } from 'react';
import { X, School, CheckCircle2, Share2, Award } from 'lucide-react';
import confetti from 'canvas-confetti';
import { UserProfile } from '../types';

interface SchoolAmbassadorModalProps {
  isOpen: boolean;
  onClose: () => void;
  user: UserProfile;
  onApply: (schoolName: string) => void;
}

export const SchoolAmbassadorModal: React.FC<SchoolAmbassadorModalProps> = ({
  isOpen,
  onClose,
  user,
  onApply,
}) => {
  const [school, setSchool] = useState(user.schoolName || '');
  const [applied, setApplied] = useState(user.isSchoolAmbassador);

  if (!isOpen) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!school.trim()) return;
    onApply(school.trim());
    setApplied(true);
    confetti({ particleCount: 60, spread: 70 });
  };

  const handleShareInvite = () => {
    const text = `🎓 Merhaba arkadaşlar!
${school || 'Okulumuz'} öğrencileri için %100 ÜCRETSİZ sınav hazırlık uygulaması Bilgi Yolu'na ben de okul elçisi olarak katıldım!

✨ LGS, TYT, KPSS ve Ehliyet sorularını kota olmadan çözüyoruz.
📲 Hemen katıl: https://bilgiyolu.app/indir`;

    if (navigator.share) {
      navigator.share({ title: 'Bilgi Yolu Okul Daveti', text }).catch(() => {});
    } else {
      navigator.clipboard.writeText(text);
      alert('Okul davet metni panoya kopyalandı!');
    }
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm flex items-center justify-center p-4">
      <div className="bg-slate-900 border border-slate-700 w-full max-w-md rounded-2xl overflow-hidden shadow-2xl animate-in fade-in zoom-in duration-200">
        <div className="bg-slate-800 px-5 py-3.5 flex items-center justify-between border-b border-slate-700">
          <div className="flex items-center gap-2 font-bold text-white text-sm">
            <School className="w-5 h-5 text-red-500" />
            Okul Elçisi Programı
          </div>
          <button onClick={onClose} className="text-slate-400 hover:text-white cursor-pointer">
            <X className="w-5 h-5" />
          </button>
        </div>

        <div className="p-6 space-y-4">
          <div className="bg-blue-950/40 border border-blue-900/60 rounded-xl p-3 text-xs text-blue-200 space-y-1">
            <div className="font-bold text-white flex items-center gap-1">
              <Award className="w-4 h-4 text-amber-400" />
              Eğitimde Fırsat Eşitliği Hareketi
            </div>
            <p>
              Okulundaki tüm arkadaşlarına Bilgi Yolu'nu ulaştır, okulunu il sıralamasında zirveye taşı ve +150 Elçilik XP'si kazan!
            </p>
          </div>

          {!applied ? (
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-xs font-semibold text-slate-300 mb-1.5">
                  Okulunuzun Tam Adı:
                </label>
                <input
                  type="text"
                  required
                  placeholder="Örn: Ankara Fen Lisesi"
                  value={school}
                  onChange={(e) => setSchool(e.target.value)}
                  className="w-full bg-slate-950 border border-slate-700 rounded-xl px-3.5 py-2.5 text-sm text-white focus:outline-none focus:border-blue-500"
                />
              </div>

              <button
                type="submit"
                className="w-full bg-[#E30A17] hover:bg-red-700 text-white font-bold py-3 rounded-xl text-sm transition-colors cursor-pointer shadow-lg shadow-red-950/40"
              >
                Okul Elçisi Ol (+150 XP Kazan)
              </button>
            </form>
          ) : (
            <div className="space-y-4 text-center">
              <div className="w-14 h-14 mx-auto bg-emerald-950/50 border border-emerald-700 text-emerald-400 rounded-full flex items-center justify-center">
                <CheckCircle2 className="w-8 h-8" />
              </div>
              <div>
                <h4 className="font-bold text-white text-base">Tebrikler, Resmi Okul Elçisisiniz!</h4>
                <p className="text-xs text-slate-400 mt-1">
                  {school} okulunuz adına elçilik rozetiniz profilinize işlendi.
                </p>
              </div>

              <button
                onClick={handleShareInvite}
                className="w-full bg-[#002366] hover:bg-blue-800 text-white font-bold py-3 rounded-xl text-sm flex items-center justify-center gap-2 transition-colors cursor-pointer"
              >
                <Share2 className="w-4 h-4" />
                Okul Arkadaşlarınla Paylaş
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
