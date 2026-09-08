export interface Question {
  id: string;
  category: 'ortaokul' | 'lise' | 'universite' | 'ehliyet' | 'acikogretim';
  subCategory: string; // LGS, TYT, AYT, KPSS, ALES, MEB Ehliyet, AÖF, AÖL
  subject: string;
  questionText: string;
  options: string[];
  correctIndex: number;
  explanation: string;
  year: number;
  source: string;
  repetitions?: number;
  easeFactor?: number;
  intervalDays?: number;
  nextReviewDate?: string | null;
  isWrongBookmarked?: boolean;
}

export interface UserProfile {
  id: string;
  name: string;
  targetExam: string;
  cityCode: number;
  cityName: string;
  schoolName: string;
  totalXp: number;
  level: number;
  currentStreakDays: number;
  weeklyStreakWeeks?: number;
  dailyGoalTarget?: number;
  weeklySolvedDays?: number[];
  totalSolvedCount: number;
  correctSolvedCount: number;
  isSchoolAmbassador: boolean;
  isCityCoordinator: boolean;
  unlockedBadgeIds: string[];
}

export interface Story {
  id: string;
  title: string;
  category: string;
  content: string;
  color: string;
  iconName: string;
}

export interface CityStat {
  rank: number;
  code: number;
  name: string;
  solved: number;
  xp: number;
  schools: number;
}
