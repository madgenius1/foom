import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import AsyncStorage from '@react-native-async-storage/async-storage';

export interface AppUsage {
  packageName: string;
  appName: string;
  timeSpent: number; // in milliseconds
  lastUsed: number;
}

export interface DailyScreenTime {
  date: string; // YYYY-MM-DD
  totalTime: number; // in milliseconds
  apps: AppUsage[];
  tokensEarned: number;
}

export interface BlockedApp {
  packageName: string;
  appName: string;
  isBlocked: boolean;
  dailyLimit?: number; // in minutes
}

interface ScreenTimeState {
  dailyScreenTime: Record<string, DailyScreenTime>;
  blockedApps: BlockedApp[];
  currentDayUsage: AppUsage[];
  totalTokensEarned: number;
  lastSyncTime: number;
  
  // Actions
  updateDailyScreenTime: (date: string, data: DailyScreenTime) => void;
  addBlockedApp: (app: BlockedApp) => void;
  removeBlockedApp: (packageName: string) => void;
  updateBlockedApp: (packageName: string, updates: Partial<BlockedApp>) => void;
  updateCurrentUsage: (usage: AppUsage[]) => void;
  addTokens: (tokens: number) => void;
  resetDailyData: () => void;
  getTodayScreenTime: () => DailyScreenTime | null;
  getWeeklyScreenTime: () => DailyScreenTime[];
}

const getTodayDateString = () => {
  return new Date().toISOString().split('T')[0];
};

export const useScreenTimeStore = create<ScreenTimeState>()(
  persist(
    (set, get) => ({
      dailyScreenTime: {},
      blockedApps: [],
      currentDayUsage: [],
      totalTokensEarned: 0,
      lastSyncTime: 0,
      
      updateDailyScreenTime: (date, data) =>
        set((state) => ({
          dailyScreenTime: {
            ...state.dailyScreenTime,
            [date]: data,
          },
        })),
      
      addBlockedApp: (app) =>
        set((state) => ({
          blockedApps: [...state.blockedApps.filter(a => a.packageName !== app.packageName), app],
        })),
      
      removeBlockedApp: (packageName) =>
        set((state) => ({
          blockedApps: state.blockedApps.filter(app => app.packageName !== packageName),
        })),
      
      updateBlockedApp: (packageName, updates) =>
        set((state) => ({
          blockedApps: state.blockedApps.map(app =>
            app.packageName === packageName ? { ...app, ...updates } : app
          ),
        })),
      
      updateCurrentUsage: (usage) =>
        set({
          currentDayUsage: usage,
          lastSyncTime: Date.now(),
        }),
      
      addTokens: (tokens) =>
        set((state) => ({
          totalTokensEarned: state.totalTokensEarned + tokens,
        })),
      
      resetDailyData: () =>
        set({
          currentDayUsage: [],
        }),
      
      getTodayScreenTime: () => {
        const today = getTodayDateString();
        return get().dailyScreenTime[today] || null;
      },
      
      getWeeklyScreenTime: () => {
        const { dailyScreenTime } = get();
        const weekDates = Array.from({ length: 7 }, (_, i) => {
          const date = new Date();
          date.setDate(date.getDate() - i);
          return date.toISOString().split('T')[0];
        });
        
        return weekDates
          .map(date => dailyScreenTime[date])
          .filter(Boolean)
          .reverse();
      },
    }),
    {
      name: 'foom-screentime-storage',
      storage: createJSONStorage(() => AsyncStorage),
    }
  )
);