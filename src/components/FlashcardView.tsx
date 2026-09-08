import React, { useState } from 'react';
import { ArrowLeft, RotateCw, CheckCircle2, Sparkles, Brain, Info } from 'lucide-react';
import confetti from 'canvas-confetti';
import { Question } from '../types';

interface FlashcardViewProps {
  questions: Question[];
  onBack: () => void;
  onUpdateSM2: (
    questionId: string,
    quality: number,
    updatedValues: { repetitions: number; easeFactor: number; intervalDays: number }
  ) => void;
}

export const FlashcardView: React.FC<FlashcardViewProps> = ({
  questions,
  onBack,
  onUpdateSM2,
}) => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [isFlipped, setIsFlipped] = useState(false);
  const [showFormulaInfo, setShowFormulaInfo] = useState(false);
  const [completedCount, setCompletedCount] = useState(0);

  if (questions.length === 0) {
    return (
      <div className="p-6 text-center max-w-md mx-auto space-y-4">
        <h3 className="text-lg font-bold text-white">Kart Bulunamadı</h3>
        <button onClick={onBack} className="text-blue-400 underline">
          Geri Dön
        </button>
      </div>
    );
  }

  const currentCard = questions[currentIndex];
  const repetitions = currentCard.repetitions || 0;
  const easeFactor = currentCard.easeFactor || 2.5;
  const intervalDays = currentCard.intervalDays || 1;

  // SuperMemo-2 hesaplayıcı
  const calculateNextSM2 = (quality: number) => {
    let nextRepetitions = repetitions;
    let nextEaseFactor = easeFactor;
    let nextInterval = intervalDays;

    if (quality >= 3) {
      if (repetitions === 0) {
        nextInterval = 1;
      } else if (repetitions === 1) {
        nextInterval = 6;
      } else {
        nextInterval = Math.round(intervalDays * easeFactor);
      }
      nextRepetitions = repetitions + 1;
    } else {
      nextRepetitions = 0;
      nextInterval = 1;
    }

    nextEaseFactor = easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    if (nextEaseFactor < 1.3) nextEaseFactor = 1.3;
    nextEaseFactor = Number(nextEaseFactor.toFixed(2));

    return {
      repetitions: nextRepetitions,
      easeFactor: nextEaseFactor,
      intervalDays: nextInterval,
    };
  };

  const handleRate = (quality: number) => {
    const updated = calculateNextSM2(quality);
    onUpdateSM2(currentCard.id, quality, updated);
    setCompletedCount((prev) => prev + 1);

    if (currentIndex < questions.length - 1) {
      setCurrentIndex((prev) => prev + 1);
      setIsFlipped(false);
    } else {
      confetti({ particleCount: 70, spread: 60 });
      setIsFlipped(false);
    }
  };

  return (
    <div className="p-4 sm:p-5 max-w-xl mx-auto space-y-4">
      {/* Üst Bar */}
      <div className="flex items-center justify-between">
        <button
          onClick={onBack}
          className="flex items-center gap-1.5 text-xs text-slate-400 hover:text-white p-1 rounded-lg transition-colors cursor-pointer"
        >
          <ArrowLeft className="w-4 h-4" />
          <span>Geri</span>
        </button>

        <div className="flex items-center gap-2">
          <span className="text-xs font-bold text-blue-300">
            Kart {currentIndex + 1} / {questions.length}
          </span>
          <button
            onClick={() => setShowFormulaInfo(!showFormulaInfo)}
            title="SM-2 Algoritma Detayı"
            className="text-slate-400 hover:text-amber-400 p-1 transition-colors cursor-pointer"
          >
            <Info className="w-4 h-4" />
          </button>
        </div>
      </div>

      {/* SM-2 Algoritma Bilgi Paneli */}
      {showFormulaInfo && (
        <div className="bg-amber-950/30 border border-amber-800/40 rounded-xl p-3 text-xs text-amber-200 animate-in fade-in duration-200">
          <div className="font-bold flex items-center gap-1 mb-1 text-amber-300">
            <Brain className="w-4 h-4" /> SM-2 (SuperMemo-2) Spaced Repetition Algoritması
          </div>
          <p className="text-[11px] text-amber-200/90 leading-relaxed">
            Zihninizin unutma eğrisini modelleyerek kartın zorluk derecesine göre bir sonraki tekrar tarihini belirler. Kolay öğrendiğiniz bilgiler daha seyrek, zorlandığınız bilgiler daha sık tekrar ettirilir.
          </p>
          <div className="mt-1.5 font-mono text-[10px] bg-black/30 p-1.5 rounded text-amber-300">
            EF' = EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
          </div>
        </div>
      )}

      {/* SM-2 Kart Durumu */}
      <div className="flex items-center justify-between text-xs bg-slate-900 border border-slate-800 rounded-xl px-3 py-2 text-slate-400">
        <div>
          Tekrar: <span className="font-bold text-white">{repetitions} kez</span>
        </div>
        <div>
          Kolaylık (EF): <span className="font-bold text-amber-400">{easeFactor}</span>
        </div>
        <div>
          Aralık: <span className="font-bold text-emerald-400">{intervalDays} gün</span>
        </div>
      </div>

      {/* Flashcard Kartı (Flip Mekanizması) */}
      <div
        onClick={() => setIsFlipped(!isFlipped)}
        className="min-h-[260px] sm:min-h-[300px] rounded-2xl bg-gradient-to-br from-slate-900 via-slate-900 to-slate-950 border-2 border-blue-900/50 hover:border-blue-600/70 p-6 flex flex-col justify-between cursor-pointer transition-all shadow-xl select-none"
      >
        <div className="flex items-center justify-between text-xs">
          <span className="bg-blue-950 text-blue-300 border border-blue-800/50 px-2.5 py-1 rounded-md font-semibold">
            {currentCard.subject} • {currentCard.subCategory}
          </span>
          <span className="text-slate-400 flex items-center gap-1 text-[11px]">
            <RotateCw className="w-3.5 h-3.5" />
            {isFlipped ? 'Soruya Dön' : 'Cevabı Gör'}
          </span>
        </div>

        <div className="my-auto py-4 text-center">
          {!isFlipped ? (
            <div className="space-y-2">
              <span className="text-[11px] font-bold text-slate-400 uppercase tracking-wider">
                Soru
              </span>
              <p className="text-base sm:text-lg font-medium text-white leading-relaxed">
                {currentCard.questionText}
              </p>
            </div>
          ) : (
            <div className="space-y-3">
              <span className="text-[11px] font-bold text-emerald-400 uppercase tracking-wider">
                Doğru Yanıt & Çözüm
              </span>
              <p className="text-base font-bold text-emerald-300">
                {currentCard.options[currentCard.correctIndex]}
              </p>
              <div className="bg-slate-800/80 p-3 rounded-xl text-xs text-slate-300 text-left leading-relaxed">
                {currentCard.explanation}
              </div>
            </div>
          )}
        </div>

        <div className="text-center text-[11px] text-slate-500">
          Karta dokunarak {isFlipped ? 'soruyu' : 'çözümü'} görüntüleyin
        </div>
      </div>

      {/* SM-2 Puanlama Butonları */}
      {isFlipped ? (
        <div className="space-y-2 animate-in fade-in duration-200">
          <div className="text-center text-xs font-semibold text-slate-300">
            Bu bilgiyi ne kadar rahat hatırladınız?
          </div>
          <div className="grid grid-cols-3 gap-2">
            <button
              onClick={() => handleRate(1)}
              className="bg-red-950/70 hover:bg-red-900 border border-red-800 text-red-200 py-3 rounded-xl text-xs font-bold transition-colors cursor-pointer text-center"
            >
              <div>Zor (1)</div>
              <span className="text-[10px] text-red-400 font-normal">Tekrar: 1 Gün</span>
            </button>

            <button
              onClick={() => handleRate(3)}
              className="bg-amber-950/70 hover:bg-amber-900 border border-amber-800 text-amber-200 py-3 rounded-xl text-xs font-bold transition-colors cursor-pointer text-center"
            >
              <div>Orta (3)</div>
              <span className="text-[10px] text-amber-400 font-normal">Tekrar: 3 Gün</span>
            </button>

            <button
              onClick={() => handleRate(5)}
              className="bg-emerald-950/70 hover:bg-emerald-900 border border-emerald-800 text-emerald-200 py-3 rounded-xl text-xs font-bold transition-colors cursor-pointer text-center"
            >
              <div>Kolay (5)</div>
              <span className="text-[10px] text-emerald-400 font-normal">Tekrar: 6+ Gün</span>
            </button>
          </div>
        </div>
      ) : (
        <div className="text-center text-xs text-slate-400 py-2">
          Değerlendirmek için önce karta dokunun.
        </div>
      )}
    </div>
  );
};
