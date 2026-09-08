import React, { useState } from 'react';
import {
  ArrowLeft,
  CheckCircle2,
  XCircle,
  Lightbulb,
  ArrowRight,
  Sparkles,
  Trophy,
  RotateCcw,
  Volume2,
} from 'lucide-react';
import confetti from 'canvas-confetti';
import { Question } from '../types';

interface QuizViewProps {
  categoryTitle: string;
  questions: Question[];
  solvedQuestionIds?: string[];
  onResetCategory?: () => void;
  onBack: () => void;
  onRecordAnswer: (questionId: string, isCorrect: boolean) => void;
  onRequestInterstitial: () => void;
}

export const QuizView: React.FC<QuizViewProps> = ({
  categoryTitle,
  questions,
  solvedQuestionIds = [],
  onResetCategory,
  onBack,
  onRecordAnswer,
  onRequestInterstitial,
}) => {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [selectedOption, setSelectedOption] = useState<number | null>(null);
  const [isAnswered, setIsAnswered] = useState(false);
  const [correctCount, setCorrectCount] = useState(0);
  const [wrongCount, setWrongCount] = useState(0);
  const [isFinished, setIsFinished] = useState(false);

  // KRİTİK KURAL: "Aynı soru asla iki kez gelmesin" & SHA-256 benzersizlik
  const activeQuestions = React.useMemo(() => {
    const solvedSet = new Set(solvedQuestionIds);
    const uniqueMap = new Map<string, Question>();
    for (const q of questions) {
      if (!solvedSet.has(q.id) && !uniqueMap.has(q.id)) {
        uniqueMap.set(q.id, q);
      }
    }
    return Array.from(uniqueMap.values());
  }, [questions, solvedQuestionIds]);

  const allAlreadySolved = questions.length > 0 && activeQuestions.length === 0;

  if (activeQuestions.length === 0) {
    return (
      <div className="p-6 text-center max-w-md mx-auto space-y-4">
        <div className="w-16 h-16 mx-auto bg-slate-800 rounded-full flex items-center justify-center text-3xl">
          {allAlreadySolved ? '🏆' : '🔍'}
        </div>
        <h3 className="text-lg font-bold text-white">
          {allAlreadySolved
            ? 'Harika! Tüm Soruları Tamamladın!'
            : 'Soru Bulunamadı'}
        </h3>
        <p className="text-sm text-slate-400">
          {allAlreadySolved
            ? 'Soru tekrarı engelleme (SHA-256) kuralı gereği aynı soru asla iki kez karşına çıkmaz. Sistem arka planda otomatik yeni soru taramaktadır.'
            : 'Bu kategori için henüz soru eklenmemiş veya internetten senkronize edilmeyi bekliyor.'}
        </p>
        <div className="flex flex-col gap-2 pt-2">
          {allAlreadySolved && onResetCategory && (
            <button
              onClick={() => {
                onResetCategory();
                setCurrentIndex(0);
              }}
              className="bg-emerald-600 text-white px-5 py-2.5 rounded-xl font-semibold text-sm hover:bg-emerald-500 transition-colors"
            >
              Kategoriyi Sıfırla ve Baştan Çöz
            </button>
          )}
          <button
            onClick={onBack}
            className="bg-[#002366] text-white px-5 py-2.5 rounded-xl font-semibold text-sm hover:bg-blue-800 transition-colors"
          >
            Ana Sayfaya Dön
          </button>
        </div>
      </div>
    );
  }

  const currentQ = activeQuestions[currentIndex];

  const handleSelectOption = (index: number) => {
    if (isAnswered) return;

    const isCorrect = index === currentQ.correctIndex;
    setSelectedOption(index);
    setIsAnswered(true);

    if (isCorrect) {
      setCorrectCount((prev) => prev + 1);
    } else {
      setWrongCount((prev) => prev + 1);
    }

    onRecordAnswer(currentQ.id, isCorrect);
  };

  const handleNext = () => {
    if (currentIndex < activeQuestions.length - 1) {
      setCurrentIndex((prev) => prev + 1);
      setSelectedOption(null);
      setIsAnswered(false);

      // Check for interstitial trigger every 4 questions
      if ((currentIndex + 1) % 4 === 0) {
        onRequestInterstitial();
      }
    } else {
      setIsFinished(true);
      confetti({
        particleCount: 80,
        spread: 70,
        origin: { y: 0.6 },
      });
      onRequestInterstitial();
    }
  };

  const handleRestart = () => {
    setCurrentIndex(0);
    setSelectedOption(null);
    setIsAnswered(false);
    setCorrectCount(0);
    setWrongCount(0);
    setIsFinished(false);
  };

  if (isFinished) {
    const total = correctCount + wrongCount;
    const score = total > 0 ? Math.round((correctCount / total) * 100) : 0;
    const xpEarned = correctCount * 20 + wrongCount * 5;

    return (
      <div className="p-6 text-center max-w-md mx-auto space-y-5 animate-in fade-in zoom-in duration-300">
        <div className="w-20 h-20 mx-auto bg-gradient-to-tr from-amber-500 to-yellow-300 rounded-3xl flex items-center justify-center text-4xl shadow-xl shadow-amber-500/20">
          <Trophy className="w-10 h-10 text-slate-950" />
        </div>

        <div>
          <h2 className="text-2xl font-black text-white">Test Tamamlandı!</h2>
          <p className="text-sm text-slate-400 mt-1">{categoryTitle}</p>
        </div>

        {/* Skor Kartı */}
        <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 grid grid-cols-3 gap-3 text-center">
          <div className="p-2 bg-emerald-950/40 rounded-xl border border-emerald-900/50">
            <span className="text-2xl font-black text-emerald-400">{correctCount}</span>
            <p className="text-[11px] text-emerald-300 font-medium">Doğru</p>
          </div>
          <div className="p-2 bg-red-950/40 rounded-xl border border-red-900/50">
            <span className="text-2xl font-black text-red-400">{wrongCount}</span>
            <p className="text-[11px] text-red-300 font-medium">Yanlış</p>
          </div>
          <div className="p-2 bg-amber-950/40 rounded-xl border border-amber-900/50">
            <span className="text-2xl font-black text-amber-400">+{xpEarned}</span>
            <p className="text-[11px] text-amber-300 font-medium">Kazanılan XP</p>
          </div>
        </div>

        <div className="text-sm text-slate-300">
          Başarı Oranı: <span className="font-bold text-white">%{score}</span>
        </div>

        <div className="flex items-center gap-3">
          <button
            onClick={handleRestart}
            className="flex-1 bg-slate-800 hover:bg-slate-700 text-slate-200 py-3 rounded-xl font-semibold text-sm flex items-center justify-center gap-2 transition-colors cursor-pointer"
          >
            <RotateCcw className="w-4 h-4" /> Tekrar Çöz
          </button>
          <button
            onClick={onBack}
            className="flex-1 bg-[#002366] hover:bg-blue-800 text-white py-3 rounded-xl font-semibold text-sm transition-colors cursor-pointer"
          >
            Ana Menü
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="p-4 sm:p-5 max-w-2xl mx-auto space-y-4">
      {/* Üst Başlık & Geri Çubuğu */}
      <div className="flex items-center justify-between">
        <button
          onClick={onBack}
          className="flex items-center gap-1.5 text-xs text-slate-400 hover:text-white p-1.5 rounded-lg hover:bg-slate-800 transition-colors cursor-pointer"
        >
          <ArrowLeft className="w-4 h-4" />
          <span>Geri</span>
        </button>

        <div className="text-xs font-bold text-blue-300">
          Soru {currentIndex + 1} / {activeQuestions.length}
        </div>

        <div className="flex items-center gap-2 text-xs font-semibold">
          <span className="text-emerald-400">{correctCount} D</span>
          <span className="text-red-400">{wrongCount} Y</span>
        </div>
      </div>

      {/* İlerleme Çubuğu */}
      <div className="w-full bg-slate-800 rounded-full h-1.5 overflow-hidden">
        <div
          className="bg-blue-600 h-1.5 rounded-full transition-all duration-300"
          style={{ width: `${((currentIndex + 1) / activeQuestions.length) * 100}%` }}
        />
      </div>

      {/* Soru Etiketleri */}
      <div className="flex items-center justify-between text-xs">
        <span className="bg-slate-800 text-slate-300 px-2.5 py-1 rounded-md border border-slate-700 font-medium">
          {currentQ.subject} • {currentQ.year}
        </span>
        <span className="bg-red-950/60 text-red-300 border border-red-800/50 px-2.5 py-1 rounded-md font-semibold text-[11px]">
          {currentQ.source}
        </span>
      </div>

      {/* Soru Metni */}
      <div className="bg-slate-900 border border-slate-800 rounded-2xl p-4 sm:p-5 text-slate-100 shadow-sm leading-relaxed text-sm sm:text-base font-medium">
        {currentQ.questionText}
      </div>

      {/* Şıklar */}
      <div className="space-y-2.5">
        {currentQ.options.map((option, idx) => {
          let stateStyle = 'bg-slate-900/80 hover:bg-slate-800 border-slate-800 text-slate-200';
          let icon = null;

          if (isAnswered) {
            if (idx === currentQ.correctIndex) {
              stateStyle = 'bg-emerald-950/70 border-emerald-500/80 text-emerald-100 font-semibold shadow-md';
              icon = <CheckCircle2 className="w-5 h-5 text-emerald-400 shrink-0" />;
            } else if (selectedOption === idx) {
              stateStyle = 'bg-red-950/70 border-red-500/80 text-red-100 shadow-md';
              icon = <XCircle className="w-5 h-5 text-red-400 shrink-0" />;
            } else {
              stateStyle = 'bg-slate-900/40 border-slate-800/60 text-slate-500 opacity-60';
            }
          }

          return (
            <button
              key={idx}
              disabled={isAnswered}
              onClick={() => handleSelectOption(idx)}
              className={`w-full text-left p-3.5 rounded-xl border transition-all flex items-center justify-between gap-3 text-sm cursor-pointer ${stateStyle}`}
            >
              <span className="leading-normal">{option}</span>
              {icon}
            </button>
          );
        })}
      </div>

      {/* Çözüm Açıklaması (Cevaplandıktan Sonra Açılır) */}
      {isAnswered && (
        <div className="space-y-3 animate-in fade-in slide-in-from-bottom-3 duration-300">
          <div className="bg-blue-950/40 border border-blue-900/60 rounded-xl p-3.5 text-xs text-blue-200">
            <div className="flex items-center gap-1.5 font-bold text-blue-100 mb-1">
              <Lightbulb className="w-4 h-4 text-amber-400" />
              Çözüm Analizi & Püf Noktası
            </div>
            <p className="leading-relaxed">{currentQ.explanation}</p>
          </div>

          <button
            onClick={handleNext}
            className="w-full bg-[#002366] hover:bg-[#0A3D91] text-white py-3 rounded-xl font-bold text-sm flex items-center justify-center gap-2 shadow-lg transition-all cursor-pointer"
          >
            <span>{currentIndex < activeQuestions.length - 1 ? 'Sonraki Soru' : 'Testi Bitir'}</span>
            <ArrowRight className="w-4 h-4" />
          </button>
        </div>
      )}
    </div>
  );
};
