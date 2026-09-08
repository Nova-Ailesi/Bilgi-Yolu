import React, { useState, useEffect } from 'react';
import { initialUser, sampleQuestions, sampleStories } from './data/mockData';
import { Question, UserProfile } from './types';
import { HeaderNav } from './components/HeaderNav';
import { DashboardView } from './components/DashboardView';
import { QuizView } from './components/QuizView';
import { FlashcardView } from './components/FlashcardView';
import { WrongNotebookView } from './components/WrongNotebookView';
import { StoriesView } from './components/StoriesView';
import { StressManagementView } from './components/StressManagementView';
import { CertificateView } from './components/CertificateView';
import {
  EducationalTipBanner,
  MilestoneCelebrationModal,
  DailyBonusRewardModal,
} from './components/EducationalBonusModals';
import { SchoolAmbassadorModal } from './components/SchoolAmbassadorModal';
import { CityLeaderboardModal } from './components/CityLeaderboardModal';
import { QuestionContestModal } from './components/QuestionContestModal';
import {
  Home,
  BookOpen,
  Zap,
  BookmarkCheck,
  Sparkles,
  Trophy,
} from 'lucide-react';

export default function App() {
  // Uygulama Durumu
  const [user, setUser] = useState<UserProfile>(initialUser);
  const [questions, setQuestions] = useState<Question[]>(sampleQuestions);
  const [currentScreen, setCurrentScreen] = useState<
    'dashboard' | 'quiz' | 'flashcards' | 'wrong' | 'stories' | 'stress' | 'certificate'
  >('dashboard');
  const [selectedCategory, setSelectedCategory] = useState<string>('lise');
  const [selectedCategoryTitle, setSelectedCategoryTitle] = useState<string>('Lise & YKS');

  // Haftalık Hedef & Seri (Streak) Takibi
  const [weeklyStreakWeeks, setWeeklyStreakWeeks] = useState<number>(() => {
    try {
      const saved = localStorage.getItem('bilgiyolu_weekly_streak');
      return saved ? JSON.parse(saved) : (initialUser.weeklyStreakWeeks || 3);
    } catch {
      return initialUser.weeklyStreakWeeks || 3;
    }
  });

  const [weeklySolvedDays, setWeeklySolvedDays] = useState<number[]>(() => {
    try {
      const saved = localStorage.getItem('bilgiyolu_weekly_solved_days');
      return saved ? JSON.parse(saved) : (initialUser.weeklySolvedDays || [14, 12, 16, 11, 15, 8, 0]);
    } catch {
      return initialUser.weeklySolvedDays || [14, 12, 16, 11, 15, 8, 0];
    }
  });

  const [dailyGoalTarget] = useState<number>(10);
  const [isMilestoneWeekly, setIsMilestoneWeekly] = useState(false);

  // KRİTİK KURAL: "Aynı soru asla iki kez gelmesin" - Çözülen SHA-256 soru ID'leri yerel depoda tutulur
  const [solvedQuestionIds, setSolvedQuestionIds] = useState<string[]>(() => {
    try {
      const saved = localStorage.getItem('bilgiyolu_solved_ids');
      return saved ? JSON.parse(saved) : [];
    } catch {
      return [];
    }
  });

  useEffect(() => {
    try {
      localStorage.setItem('bilgiyolu_solved_ids', JSON.stringify(solvedQuestionIds));
    } catch (e) {
      console.error(e);
    }
  }, [solvedQuestionIds]);

  // KRİTİK KURAL: "Soruları tam otomatik çek (kullanıcı hiçbir şey yapmadan)"
  useEffect(() => {
    fetch('/data/delta.json')
      .then((res) => (res.ok ? res.json() : null))
      .then((data) => {
        if (data && Array.isArray(data.questions)) {
          setQuestions((prev) => {
            const existingIds = new Set(prev.map((q) => q.id));
            const newQuestions: Question[] = [];
            for (const item of data.questions) {
              if (item.id && !existingIds.has(item.id)) {
                newQuestions.push({
                  ...item,
                  correctIndex: item.correctIndex ?? item.correctOptionIndex ?? 0,
                });
                existingIds.add(item.id);
              }
            }
            if (newQuestions.length > 0) {
              return [...prev, ...newQuestions];
            }
            return prev;
          });
        }
      })
      .catch((err) => {
        console.warn('Otomatik soru delta senkronizasyonu:', err);
      });
  }, []);

  // Teşvik & Katılım Modalları
  const [isMilestoneOpen, setIsMilestoneOpen] = useState(false);
  const [isBonusRewardOpen, setIsBonusRewardOpen] = useState(false);
  const [isAmbassadorOpen, setIsAmbassadorOpen] = useState(false);
  const [isLeaderboardOpen, setIsLeaderboardOpen] = useState(false);
  const [isContestOpen, setIsContestOpen] = useState(false);

  // Yanlış Defteri Soruları
  const wrongQuestions = questions.filter((q) => q.isWrongBookmarked);

  // Kategori Seçimi & Quiz Başlatma
  const handleSelectCategory = (
    cat: 'ortaokul' | 'lise' | 'universite' | 'ehliyet' | 'acikogretim',
    title: string
  ) => {
    setSelectedCategory(cat);
    setSelectedCategoryTitle(title);
    setCurrentScreen('quiz');
  };

  // Kategori Soru Havuzunu Sıfırlama
  const handleResetCategory = (cat: string) => {
    const catQuestionIds = questions.filter((q) => q.category === cat).map((q) => q.id);
    setSolvedQuestionIds((prev) => prev.filter((id) => !catQuestionIds.includes(id)));
  };

  // Soru Cevaplama
  const handleRecordAnswer = (questionId: string, isCorrect: boolean) => {
    // "Aynı soru asla iki kez gelmesin" kuralı: çözüldü olarak işaretle
    setSolvedQuestionIds((prev) => (prev.includes(questionId) ? prev : [...prev, questionId]));

    // Haftalık İlerleme & Seri Güncellemesi
    const todayJs = new Date().getDay();
    const currentDayIndex = todayJs === 0 ? 6 : todayJs - 1; // 0 = Pzt ... 6 = Paz

    setWeeklySolvedDays((prev) => {
      const next = [...prev];
      const prevDayCount = next[currentDayIndex] || 0;
      const newDayCount = prevDayCount + 1;
      next[currentDayIndex] = newDayCount;

      // Eğer bugün tam olarak 10. soru hedefine ulaştıysa kutlama modalını aç
      if (prevDayCount === dailyGoalTarget - 1 && newDayCount === dailyGoalTarget) {
        setIsMilestoneWeekly(true);
        setIsMilestoneOpen(true);

        // Eğer haftanın 7 günü de 10 veya üzeri olduysa, haftalık seriyi artır
        const all7Completed = next.every((c) => c >= dailyGoalTarget);
        if (all7Completed) {
          setWeeklyStreakWeeks((w) => {
            const updated = w + 1;
            try {
              localStorage.setItem('bilgiyolu_weekly_streak', JSON.stringify(updated));
            } catch (e) {}
            return updated;
          });
        }
      }

      try {
        localStorage.setItem('bilgiyolu_weekly_solved_days', JSON.stringify(next));
      } catch (e) {}
      return next;
    });

    setQuestions((prev) =>
      prev.map((q) => {
        if (q.id === questionId) {
          return {
            ...q,
            isWrongBookmarked: !isCorrect ? true : q.isWrongBookmarked,
          };
        }
        return q;
      })
    );

    setUser((prev) => {
      const addedXp = isCorrect ? 20 : 5;
      const newTotalXp = prev.totalXp + addedXp;
      const newLevel = Math.floor(newTotalXp / 200) + 1;
      return {
        ...prev,
        totalXp: newTotalXp,
        level: newLevel,
        totalSolvedCount: prev.totalSolvedCount + 1,
        correctSolvedCount: isCorrect ? prev.correctSolvedCount + 1 : prev.correctSolvedCount,
      };
    });
  };

  // Haftalık Şampiyon Sandığı Ödülü (+250 XP)
  const handleClaimWeeklyBonus = () => {
    setUser((prev) => ({
      ...prev,
      totalXp: prev.totalXp + 250,
      level: Math.floor((prev.totalXp + 250) / 200) + 1,
    }));
  };

  // SM-2 Aralıklı Tekrar Güncellemesi
  const handleUpdateSM2 = (
    questionId: string,
    quality: number,
    updatedValues: { repetitions: number; easeFactor: number; intervalDays: number }
  ) => {
    setQuestions((prev) =>
      prev.map((q) => {
        if (q.id === questionId) {
          return {
            ...q,
            repetitions: updatedValues.repetitions,
            easeFactor: updatedValues.easeFactor,
            intervalDays: updatedValues.intervalDays,
          };
        }
        return q;
      })
    );

    // XP Ödülü
    setUser((prev) => ({
      ...prev,
      totalXp: prev.totalXp + 15,
      level: Math.floor((prev.totalXp + 15) / 200) + 1,
    }));
  };

  // Yanlış Defterinden Kaldırma
  const handleRemoveFromNotebook = (questionId: string) => {
    setQuestions((prev) =>
      prev.map((q) => (q.id === questionId ? { ...q, isWrongBookmarked: false } : q))
    );
  };

  // Okul Elçisi Başvurusu
  const handleApplyAmbassador = (schoolName: string) => {
    setUser((prev) => ({
      ...prev,
      schoolName,
      isSchoolAmbassador: true,
      totalXp: prev.totalXp + 150,
      level: Math.floor((prev.totalXp + 150) / 200) + 1,
    }));
  };

  // Soru Katkı XP
  const handleAddQuestionXP = () => {
    setUser((prev) => ({
      ...prev,
      totalXp: prev.totalXp + 100,
      level: Math.floor((prev.totalXp + 100) / 200) + 1,
    }));
  };

  // Günlük Çalışma Bonusu Alındı
  const handleClaimReward = () => {
    setUser((prev) => ({
      ...prev,
      totalXp: prev.totalXp + 50,
      level: Math.floor((prev.totalXp + 50) / 200) + 1,
    }));
  };

  // Filtrelenmiş Quiz Soruları
  const activeQuizQuestions = questions.filter((q) => q.category === selectedCategory);

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col font-sans selection:bg-red-600 selection:text-white">
      {/* 🧭 Üst Menü & Öğrenci Durum Çubuğu */}
      <HeaderNav
        user={user}
        weeklyStreakWeeks={weeklyStreakWeeks}
        onOpenAmbassador={() => setIsAmbassadorOpen(true)}
        onOpenLeaderboard={() => setIsLeaderboardOpen(true)}
        onOpenStressManagement={() => setCurrentScreen('stress')}
        onOpenCertificate={() => setCurrentScreen('certificate')}
      />

      {/* 📖 Hızlı Eğitim Gezinme Sekmeleri (Quick Navigation Bar) */}
      <nav className="bg-slate-900 border-b border-slate-800 sticky top-[61px] z-30 shadow-sm">
        <div className="max-w-5xl mx-auto px-4 flex items-center justify-between sm:justify-start gap-1 sm:gap-4 overflow-x-auto py-2 text-xs font-semibold scrollbar-none">
          <button
            onClick={() => setCurrentScreen('dashboard')}
            className={`px-3 py-2 rounded-xl flex items-center gap-1.5 transition-all cursor-pointer whitespace-nowrap ${
              currentScreen === 'dashboard'
                ? 'bg-[#002366] text-white shadow-sm'
                : 'text-slate-400 hover:text-white hover:bg-slate-800'
            }`}
          >
            <Home className="w-3.5 h-3.5" />
            <span>Ana Sayfa</span>
          </button>

          <button
            onClick={() => {
              setSelectedCategory('lise');
              setSelectedCategoryTitle('Lise & YKS');
              setCurrentScreen('quiz');
            }}
            className={`px-3 py-2 rounded-xl flex items-center gap-1.5 transition-all cursor-pointer whitespace-nowrap ${
              currentScreen === 'quiz'
                ? 'bg-[#002366] text-white shadow-sm'
                : 'text-slate-400 hover:text-white hover:bg-slate-800'
            }`}
          >
            <BookOpen className="w-3.5 h-3.5" />
            <span>Soru Çöz</span>
          </button>

          <button
            onClick={() => setCurrentScreen('flashcards')}
            className={`px-3 py-2 rounded-xl flex items-center gap-1.5 transition-all cursor-pointer whitespace-nowrap ${
              currentScreen === 'flashcards'
                ? 'bg-[#002366] text-white shadow-sm'
                : 'text-slate-400 hover:text-white hover:bg-slate-800'
            }`}
          >
            <Zap className="w-3.5 h-3.5 text-amber-400" />
            <span>Bilgi Kartları</span>
          </button>

          <button
            onClick={() => setCurrentScreen('wrong')}
            className={`px-3 py-2 rounded-xl flex items-center gap-1.5 transition-all cursor-pointer whitespace-nowrap relative ${
              currentScreen === 'wrong'
                ? 'bg-[#002366] text-white shadow-sm'
                : 'text-slate-400 hover:text-white hover:bg-slate-800'
            }`}
          >
            <BookmarkCheck className="w-3.5 h-3.5 text-blue-400" />
            <span>Yanlış Defteri</span>
            {wrongQuestions.length > 0 && (
              <span className="bg-red-600 text-white text-[9px] font-bold px-1.5 py-0.2 rounded-full">
                {wrongQuestions.length}
              </span>
            )}
          </button>

          <button
            onClick={() => setCurrentScreen('stress')}
            className={`px-3 py-2 rounded-xl flex items-center gap-1.5 transition-all cursor-pointer whitespace-nowrap ${
              currentScreen === 'stress'
                ? 'bg-[#002366] text-white shadow-sm'
                : 'text-slate-400 hover:text-white hover:bg-slate-800'
            }`}
          >
            <Sparkles className="w-3.5 h-3.5 text-emerald-400" />
            <span>Stres & Odak</span>
          </button>

          <button
            onClick={() => setIsLeaderboardOpen(true)}
            className="px-3 py-2 rounded-xl flex items-center gap-1.5 text-slate-400 hover:text-white hover:bg-slate-800 transition-all cursor-pointer whitespace-nowrap"
          >
            <Trophy className="w-3.5 h-3.5 text-amber-300" />
            <span>81 İl Ligi</span>
          </button>
        </div>
      </nav>

      {/* 📱 Ana Eğitim Sahnesi (Dünya Standardında Tam Ekran Tasarım) */}
      <main className="flex-1 w-full max-w-5xl mx-auto py-4 sm:py-6 px-3 sm:px-6">
        <div className="bg-slate-900/70 border border-slate-800/90 rounded-2xl sm:rounded-3xl shadow-2xl overflow-hidden min-h-[600px] flex flex-col backdrop-blur-sm">
          <div className="flex-1 overflow-y-auto">
            {currentScreen === 'dashboard' && (
              <DashboardView
                user={user}
                wrongCount={wrongQuestions.length}
                weeklySolvedDays={weeklySolvedDays}
                weeklyStreakWeeks={weeklyStreakWeeks}
                dailyGoalTarget={dailyGoalTarget}
                onStartDailyPractice={() => {
                  setSelectedCategory('lise');
                  setSelectedCategoryTitle('Lise & YKS');
                  setCurrentScreen('quiz');
                }}
                onClaimWeeklyBonus={handleClaimWeeklyBonus}
                onSelectCategory={handleSelectCategory}
                onOpenFlashcards={() => setCurrentScreen('flashcards')}
                onOpenWrongNotebook={() => setCurrentScreen('wrong')}
                onOpenStories={() => setCurrentScreen('stories')}
                onOpenStressManagement={() => setCurrentScreen('stress')}
                onOpenCertificate={() => setCurrentScreen('certificate')}
                onOpenAmbassador={() => setIsAmbassadorOpen(true)}
                onOpenLeaderboard={() => setIsLeaderboardOpen(true)}
                onOpenContest={() => setIsContestOpen(true)}
                onWatchRewardedAd={() => setIsBonusRewardOpen(true)}
              />
            )}

            {currentScreen === 'quiz' && (
              <QuizView
                categoryTitle={selectedCategoryTitle}
                questions={activeQuizQuestions}
                solvedQuestionIds={solvedQuestionIds}
                onResetCategory={() => handleResetCategory(selectedCategory)}
                onBack={() => setCurrentScreen('dashboard')}
                onRecordAnswer={handleRecordAnswer}
                onRequestInterstitial={() => setIsMilestoneOpen(true)}
              />
            )}

            {currentScreen === 'flashcards' && (
              <FlashcardView
                questions={questions}
                onBack={() => setCurrentScreen('dashboard')}
                onUpdateSM2={handleUpdateSM2}
              />
            )}

            {currentScreen === 'wrong' && (
              <WrongNotebookView
                questions={wrongQuestions}
                onBack={() => setCurrentScreen('dashboard')}
                onRemoveFromNotebook={handleRemoveFromNotebook}
              />
            )}

            {currentScreen === 'stories' && (
              <StoriesView
                stories={sampleStories}
                onClose={() => setCurrentScreen('dashboard')}
              />
            )}

            {currentScreen === 'stress' && (
              <StressManagementView onBack={() => setCurrentScreen('dashboard')} />
            )}

            {currentScreen === 'certificate' && (
              <CertificateView
                user={user}
                onBack={() => setCurrentScreen('dashboard')}
              />
            )}
          </div>

          {/* 💡 Eğitici Püf Noktası Bandı */}
          <EducationalTipBanner />
        </div>
      </main>

      {/* 🏆 Başarı & Seri Modalı */}
      <MilestoneCelebrationModal
        isOpen={isMilestoneOpen}
        onClose={() => {
          setIsMilestoneOpen(false);
          setIsMilestoneWeekly(false);
        }}
        isWeeklyStreakMilestone={isMilestoneWeekly}
        weeklyStreakWeeks={weeklyStreakWeeks}
      />

      {/* 🎁 Günlük Çalışma Sandığı & Başarı Ödülü Modalı */}
      <DailyBonusRewardModal
        isOpen={isBonusRewardOpen}
        onClose={() => setIsBonusRewardOpen(false)}
        onRewardClaimed={handleClaimReward}
      />

      {/* 🏫 Okul Elçisi Modalı */}
      <SchoolAmbassadorModal
        isOpen={isAmbassadorOpen}
        onClose={() => setIsAmbassadorOpen(false)}
        user={user}
        onApply={handleApplyAmbassador}
      />

      {/* 🏆 81 İl Liderlik Tablosu Modalı */}
      <CityLeaderboardModal
        isOpen={isLeaderboardOpen}
        onClose={() => setIsLeaderboardOpen(false)}
        user={user}
      />

      {/* ✍️ Soru Katkı Yarışması Modalı */}
      <QuestionContestModal
        isOpen={isContestOpen}
        onClose={() => setIsContestOpen(false)}
        onAddQuestionXP={handleAddQuestionXP}
      />
    </div>
  );
}
