import React, { useState } from 'react';
import { X, Send, Award, Sparkles, CheckCircle2 } from 'lucide-react';
import confetti from 'canvas-confetti';

interface QuestionContestModalProps {
  isOpen: boolean;
  onClose: () => void;
  onAddQuestionXP: () => void;
}

export const QuestionContestModal: React.FC<QuestionContestModalProps> = ({
  isOpen,
  onClose,
  onAddQuestionXP,
}) => {
  const [category, setCategory] = useState('lise');
  const [exam, setExam] = useState('TYT');
  const [questionText, setQuestionText] = useState('');
  const [optA, setOptA] = useState('');
  const [optB, setOptB] = useState('');
  const [optC, setOptC] = useState('');
  const [optD, setOptD] = useState('');
  const [correctIndex, setCorrectIndex] = useState(0);
  const [explanation, setExplanation] = useState('');
  const [isSuccess, setIsSuccess] = useState(false);

  if (!isOpen) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!questionText.trim() || !optA.trim() || !optB.trim() || !optC.trim() || !optD.trim()) {
      alert('Lütfen soru metnini ve tüm şıkları doldurunuz.');
      return;
    }

    onAddQuestionXP();
    setIsSuccess(true);
    confetti({ particleCount: 70, spread: 60 });
  };

  const handleReset = () => {
    setQuestionText('');
    setOptA('');
    setOptB('');
    setOptC('');
    setOptD('');
    setExplanation('');
    setIsSuccess(false);
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm flex items-center justify-center p-4">
      <div className="bg-slate-900 border border-slate-700 w-full max-w-lg rounded-2xl overflow-hidden shadow-2xl flex flex-col max-h-[90vh]">
        <div className="bg-slate-800 px-5 py-3.5 flex items-center justify-between border-b border-slate-700 text-white">
          <div className="flex items-center gap-2 font-bold text-sm">
            <Award className="w-5 h-5 text-amber-400" />
            Topluluk Soru Katkı Yarışması
          </div>
          <button onClick={onClose} className="text-slate-400 hover:text-white cursor-pointer">
            <X className="w-5 h-5" />
          </button>
        </div>

        <div className="p-5 overflow-y-auto space-y-4">
          <div className="bg-gradient-to-r from-[#002366] to-[#0A3D91] rounded-xl p-3.5 text-xs text-white space-y-1">
            <div className="font-bold flex items-center gap-1.5 text-sm">
              <Sparkles className="w-4 h-4 text-amber-300" />
              Soru Gönder, Fırsat Eşitliğine Güç Kat!
            </div>
            <p className="text-blue-100 text-[11px] leading-relaxed">
              Öğretmenler ve öğrencilerin kamuya açık, telifsiz hazırladığı sorular editör onayından sonra tüm Türkiye ile paylaşılır. Her soru için <strong>+100 XP</strong> kazanırsınız!
            </p>
          </div>

          {!isSuccess ? (
            <form onSubmit={handleSubmit} className="space-y-3">
              <div className="grid grid-cols-2 gap-2">
                <div>
                  <label className="block text-xs font-semibold text-slate-300 mb-1">Kategori:</label>
                  <select
                    value={category}
                    onChange={(e) => setCategory(e.target.value)}
                    className="w-full bg-slate-950 border border-slate-700 rounded-lg p-2 text-xs text-white"
                  >
                    <option value="ortaokul">Ortaokul</option>
                    <option value="lise">Lise</option>
                    <option value="universite">Üniversite</option>
                    <option value="ehliyet">Ehliyet</option>
                    <option value="acikogretim">Açık Öğretim</option>
                  </select>
                </div>

                <div>
                  <label className="block text-xs font-semibold text-slate-300 mb-1">Sınav Türü:</label>
                  <select
                    value={exam}
                    onChange={(e) => setExam(e.target.value)}
                    className="w-full bg-slate-950 border border-slate-700 rounded-lg p-2 text-xs text-white"
                  >
                    <option value="LGS">LGS</option>
                    <option value="TYT">TYT</option>
                    <option value="AYT">AYT</option>
                    <option value="KPSS">KPSS</option>
                    <option value="Ehliyet">Ehliyet</option>
                  </select>
                </div>
              </div>

              <div>
                <label className="block text-xs font-semibold text-slate-300 mb-1">Soru Metni:</label>
                <textarea
                  required
                  rows={3}
                  value={questionText}
                  onChange={(e) => setQuestionText(e.target.value)}
                  placeholder="Soru metnini net ve anlaşılır şekilde yazınız..."
                  className="w-full bg-slate-950 border border-slate-700 rounded-xl p-2.5 text-xs text-white focus:outline-none focus:border-blue-500"
                />
              </div>

              <div className="space-y-2">
                <label className="block text-xs font-semibold text-slate-300">
                  Şıklar (Doğru olanı işaretleyin):
                </label>
                {[
                  { label: 'A', val: optA, set: setOptA, idx: 0 },
                  { label: 'B', val: optB, set: setOptB, idx: 1 },
                  { label: 'C', val: optC, set: setOptC, idx: 2 },
                  { label: 'D', val: optD, set: setOptD, idx: 3 },
                ].map((item) => (
                  <div key={item.label} className="flex items-center gap-2">
                    <input
                      type="radio"
                      name="correctOption"
                      checked={correctIndex === item.idx}
                      onChange={() => setCorrectIndex(item.idx)}
                      className="accent-red-500 cursor-pointer"
                    />
                    <input
                      type="text"
                      required
                      placeholder={`Şık ${item.label}`}
                      value={item.val}
                      onChange={(e) => item.set(e.target.value)}
                      className="flex-1 bg-slate-950 border border-slate-700 rounded-lg px-2.5 py-1.5 text-xs text-white"
                    />
                  </div>
                ))}
              </div>

              <div>
                <label className="block text-xs font-semibold text-slate-300 mb-1">
                  Çözüm Açıklaması & İpucu:
                </label>
                <input
                  type="text"
                  value={explanation}
                  onChange={(e) => setExplanation(e.target.value)}
                  placeholder="Öğrencilere çözüm mantığını aktaran kısa açıklama..."
                  className="w-full bg-slate-950 border border-slate-700 rounded-lg p-2 text-xs text-white"
                />
              </div>

              <button
                type="submit"
                className="w-full bg-[#E30A17] hover:bg-red-700 text-white font-bold py-3 rounded-xl text-sm flex items-center justify-center gap-2 transition-colors cursor-pointer shadow-lg shadow-red-950/40"
              >
                <Send className="w-4 h-4" />
                Soruyu Gönder & +100 XP Kazan
              </button>
            </form>
          ) : (
            <div className="space-y-4 text-center py-4">
              <div className="w-14 h-14 mx-auto bg-emerald-950/50 border border-emerald-700 text-emerald-400 rounded-full flex items-center justify-center">
                <CheckCircle2 className="w-8 h-8" />
              </div>
              <div>
                <h4 className="font-bold text-white text-base">Sorunuz Başarıyla İletildi!</h4>
                <p className="text-xs text-slate-400 mt-1">
                  Müfredat denetiminden sonra delta.json'a eklenecek ve tüm Türkiye'ye sunulacak. Profilinize +100 XP eklendi.
                </p>
              </div>
              <button
                onClick={handleReset}
                className="bg-[#002366] text-white px-6 py-2.5 rounded-xl font-semibold text-xs"
              >
                Tamam
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
