import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import AsyncStorage from '@react-native-async-storage/async-storage';

export interface TokenTransaction {
  id: string;
  type: 'earned' | 'invested' | 'withdrawn';
  amount: number;
  description: string;
  timestamp: number;
  relatedScreenTime?: number; // in minutes
}

export interface Investment {
  id: string;
  mmfName: string;
  amount: number;
  tokensInvested: number;
  currentValue: number;
  returnRate: number;
  investedAt: number;
  maturityDate?: number;
}

export interface SavingsGoal {
  id: string;
  name: string;
  targetAmount: number;
  currentAmount: number;
  targetDate: number;
  isActive: boolean;
  createdAt: number;
}

interface WalletState {
  tokenBalance: number;
  totalEarned: number;
  totalInvested: number;
  currentSavings: number;
  transactions: TokenTransaction[];
  investments: Investment[];
  savingsGoals: SavingsGoal[];
  
  // Actions
  addTokens: (amount: number, screenTime?: number) => void;
  deductTokens: (amount: number, reason: string) => void;
  addTransaction: (transaction: Omit<TokenTransaction, 'id'>) => void;
  investTokens: (mmfName: string, tokens: number, kesAmount: number) => void;
  updateInvestmentValue: (investmentId: string, newValue: number, returnRate: number) => void;
  withdrawInvestment: (investmentId: string) => void;
  createSavingsGoal: (goal: Omit<SavingsGoal, 'id' | 'currentAmount' | 'createdAt'>) => void;
  updateSavingsGoal: (goalId: string, updates: Partial<SavingsGoal>) => void;
  addToSavingsGoal: (goalId: string, amount: number) => void;
  getRecentTransactions: (limit?: number) => TokenTransaction[];
  getTotalPortfolioValue: () => number;
}

const generateId = () => Date.now().toString() + Math.random().toString(36).substr(2, 9);

export const useWalletStore = create<WalletState>()(
  persist(
    (set, get) => ({
      tokenBalance: 0,
      totalEarned: 0,
      totalInvested: 0,
      currentSavings: 0,
      transactions: [],
      investments: [],
      savingsGoals: [],
      
      addTokens: (amount, screenTime) => {
        const transaction: TokenTransaction = {
          id: generateId(),
          type: 'earned',
          amount,
          description: screenTime 
            ? `Earned from ${Math.round(screenTime)} minutes of reduced screen time`
            : 'Tokens earned',
          timestamp: Date.now(),
          relatedScreenTime: screenTime,
        };
        
        set((state) => ({
          tokenBalance: state.tokenBalance + amount,
          totalEarned: state.totalEarned + amount,
          transactions: [transaction, ...state.transactions],
        }));
      },
      
      deductTokens: (amount, reason) => {
        const state = get();
        if (state.tokenBalance < amount) {
          throw new Error('Insufficient token balance');
        }
        
        const transaction: TokenTransaction = {
          id: generateId(),
          type: 'withdrawn',
          amount: -amount,
          description: reason,
          timestamp: Date.now(),
        };
        
        set({
          tokenBalance: state.tokenBalance - amount,
          transactions: [transaction, ...state.transactions],
        });
      },
      
      addTransaction: (transactionData) => {
        const transaction: TokenTransaction = {
          ...transactionData,
          id: generateId(),
        };
        
        set((state) => ({
          transactions: [transaction, ...state.transactions],
        }));
      },
      
      investTokens: (mmfName, tokens, kesAmount) => {
        const state = get();
        if (state.tokenBalance < tokens) {
          throw new Error('Insufficient token balance');
        }
        
        const investment: Investment = {
          id: generateId(),
          mmfName,
          amount: kesAmount,
          tokensInvested: tokens,
          currentValue: kesAmount,
          returnRate: 0,
          investedAt: Date.now(),
        };
        
        const transaction: TokenTransaction = {
          id: generateId(),
          type: 'invested',
          amount: -tokens,
          description: `Invested in ${mmfName}`,
          timestamp: Date.now(),
        };
        
        set({
          tokenBalance: state.tokenBalance - tokens,
          totalInvested: state.totalInvested + kesAmount,
          investments: [...state.investments, investment],
          transactions: [transaction, ...state.transactions],
        });
      },
      
      updateInvestmentValue: (investmentId, newValue, returnRate) =>
        set((state) => ({
          investments: state.investments.map(inv =>
            inv.id === investmentId
              ? { ...inv, currentValue: newValue, returnRate }
              : inv
          ),
        })),
      
      withdrawInvestment: (investmentId) => {
        const state = get();
        const investment = state.investments.find(inv => inv.id === investmentId);
        if (!investment) return;
        
        const tokensReturned = Math.round(investment.currentValue * 0.1); // 10 tokens per KES
        
        const transaction: TokenTransaction = {
          id: generateId(),
          type: 'earned',
          amount: tokensReturned,
          description: `Withdrawn from ${investment.mmfName}`,
          timestamp: Date.now(),
        };
        
        set({
          tokenBalance: state.tokenBalance + tokensReturned,
          investments: state.investments.filter(inv => inv.id !== investmentId),
          transactions: [transaction, ...state.transactions],
        });
      },
      
      createSavingsGoal: (goalData) => {
        const goal: SavingsGoal = {
          ...goalData,
          id: generateId(),
          currentAmount: 0,
          createdAt: Date.now(),
        };
        
        set((state) => ({
          savingsGoals: [...state.savingsGoals, goal],
        }));
      },
      
      updateSavingsGoal: (goalId, updates) =>
        set((state) => ({
          savingsGoals: state.savingsGoals.map(goal =>
            goal.id === goalId ? { ...goal, ...updates } : goal
          ),
        })),
      
      addToSavingsGoal: (goalId, amount) =>
        set((state) => ({
          savingsGoals: state.savingsGoals.map(goal =>
            goal.id === goalId
              ? { ...goal, currentAmount: goal.currentAmount + amount }
              : goal
          ),
          currentSavings: state.currentSavings + amount,
        })),
      
      getRecentTransactions: (limit = 10) => {
        return get().transactions.slice(0, limit);
      },
      
      getTotalPortfolioValue: () => {
        const { investments, currentSavings } = get();
        const investmentValue = investments.reduce((total, inv) => total + inv.currentValue, 0);
        return investmentValue + currentSavings;
      },
    }),
    {
      name: 'foom-wallet-storage',
      storage: createJSONStorage(() => AsyncStorage),
    }
  )
);