import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { UserProfile } from '../auth/AuthContext';

interface AuthState {
  user: UserProfile | null;
  isAuthenticated: boolean;
  hasCompletedOnboarding: boolean;
  setAuthUser: (user: UserProfile) => void;
  clearAuthUser: () => void;
  setOnboardingComplete: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      isAuthenticated: false,
      hasCompletedOnboarding: false,
      
      setAuthUser: (user) =>
        set({
          user,
          isAuthenticated: true,
        }),
      
      clearAuthUser: () =>
        set({
          user: null,
          isAuthenticated: false,
        }),
      
      setOnboardingComplete: () =>
        set({
          hasCompletedOnboarding: true,
        }),
    }),
    {
      name: 'foom-auth-storage',
      storage: createJSONStorage(() => AsyncStorage),
    }
  )
);