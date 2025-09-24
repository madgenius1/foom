import { CONSTANTS } from '../utils/constants';
import { SavingsGoal } from '../store/walletStore';

export interface SavingsProjection {
  timeToGoal: number; // in days
  monthlyRequired: number; // KES required monthly
  weeklyRequired: number; // KES required weekly
  dailyRequired: number; // KES required daily
  feasible: boolean;
  recommendations: string[];
}

export interface InvestmentProjection {
  principal: number;
  projectedValue: number;
  totalReturn: number;
  returnPercentage: number;
  timeHorizon: number; // in days
  monthlyContribution: number;
}

export interface ScreenTimeToSavings {
  currentDailyScreenTime: number; // hours
  targetDailyScreenTime: number; // hours
  dailyTokensPotential: number;
  monthlyTokensPotential: number;
  monthlyKESEquivalent: number;
  annualSavingsPotential: number;
}

class SavingsSimulator {
  /**
   * Calculate how long it will take to reach a savings goal
   */
  calculateSavingsProjection(
    currentSavings: number,
    goalAmount: number,
    targetDate: number,
    averageDailyTokens: number = 20
  ): SavingsProjection {
    const now = Date.now();
    const daysToGoal = Math.max(1, Math.ceil((targetDate - now) / CONSTANTS.TIME.DAY));
    const amountNeeded = Math.max(0, goalAmount - currentSavings);
    
    // Convert daily tokens to KES
    const dailyKESFromTokens = averageDailyTokens * CONSTANTS.KES_PER_TOKEN;
    const monthlyKESFromTokens = dailyKESFromTokens * 30;
    
    // Calculate required savings
    const dailyRequired = amountNeeded / daysToGoal;
    const weeklyRequired = dailyRequired * 7;
    const monthlyRequired = dailyRequired * 30;
    
    // Check if goal is feasible with current token earning
    const feasibleWithTokensOnly = monthlyKESFromTokens >= monthlyRequired;
    const feasible = feasibleWithTokensOnly || monthlyRequired <= 10000; // Reasonable monthly goal
    
    const recommendations: string[] = [];
    
    if (!feasible) {
      recommendations.push('Consider extending your target date or reducing the goal amount');
    }
    
    if (monthlyRequired > monthlyKESFromTokens) {
      const additionalNeeded = monthlyRequired - monthlyKESFromTokens;
      recommendations.push(`You'll need an additional ${additionalNeeded.toFixed(0)} KES monthly beyond tokens`);
    }
    
    if (averageDailyTokens < 30) {
      recommendations.push('Reduce your screen time more to earn additional tokens');
    }
    
    recommendations.push('Consider investing tokens in MMFs for compound growth');
    
    return {
      timeToGoal: daysToGoal,
      monthlyRequired,
      weeklyRequired,
      dailyRequired,
      feasible,
      recommendations,
    };
  }

  /**
   * Project investment growth over time
   */
  calculateInvestmentProjection(
    principal: number,
    annualRate: number,
    timeHorizonDays: number,
    monthlyContribution: number = 0
  ): InvestmentProjection {
    const years = timeHorizonDays / 365;
    const monthlyRate = annualRate / 100 / 12;
    const months = timeHorizonDays / 30;
    
    // Calculate compound interest with monthly contributions
    let projectedValue = principal;
    
    if (monthlyContribution > 0) {
      // Future value of annuity formula + compound interest on principal
      const annuityFV = monthlyContribution * (((1 + monthlyRate) ** months - 1) / monthlyRate);
      const principalFV = principal * ((1 + monthlyRate) ** months);
      projectedValue = principalFV + annuityFV;
    } else {
      // Simple compound interest
      projectedValue = principal * Math.pow(1 + annualRate / 100, years);
    }
    
    const totalReturn = projectedValue - principal - (monthlyContribution * months);
    const returnPercentage = ((projectedValue - principal) / principal) * 100;
    
    return {
      principal,
      projectedValue: Math.round(projectedValue),
      totalReturn: Math.round(totalReturn),
      returnPercentage: Math.round(returnPercentage * 100) / 100,
      timeHorizon: timeHorizonDays,
      monthlyContribution,
    };
  }

  /**
   * Calculate potential savings from reducing screen time
   */
  calculateScreenTimeToSavings(
    currentScreenTimeHours: number,
    targetScreenTimeHours: number,
    dailyGoalHours: number = CONSTANTS.DAILY_SCREEN_TIME_GOAL_HOURS
  ): ScreenTimeToSavings {
    // Calculate tokens earned at current screen time
    const currentHoursUnderGoal = Math.max(0, dailyGoalHours - currentScreenTimeHours);
    const currentDailyTokens = currentHoursUnderGoal * CONSTANTS.TOKENS_PER_HOUR_SAVED;
    
    // Calculate tokens earned at target screen time
    const targetHoursUnderGoal = Math.max(0, dailyGoalHours - targetScreenTimeHours);
    const targetDailyTokens = targetHoursUnderGoal * CONSTANTS.TOKENS_PER_HOUR_SAVED;
    
    // Calculate potential increase
    const dailyTokensPotential = Math.max(0, targetDailyTokens - currentDailyTokens);
    const monthlyTokensPotential = dailyTokensPotential * 30;
    const monthlyKESEquivalent = monthlyTokensPotential * CONSTANTS.KES_PER_TOKEN;
    const annualSavingsPotential = monthlyKESEquivalent * 12;
    
    return {
      currentDailyScreenTime: currentScreenTimeHours,
      targetDailyScreenTime: targetScreenTimeHours,
      dailyTokensPotential,
      monthlyTokensPotential,
      monthlyKESEquivalent,
      annualSavingsPotential,
    };
  }

  /**
   * Simulate different screen time reduction scenarios
   */
  generateScreenTimeScenarios(currentScreenTimeHours: number): {
    scenario: string;
    targetHours: number;
    dailyTokens: number;
    monthlyKES: number;
    annualKES: number;
    difficulty: 'easy' | 'medium' | 'hard';
  }[] {
    const scenarios = [
      {
        scenario: 'Modest Reduction',
        reduction: 1,
        difficulty: 'easy' as const,
      },
      {
        scenario: 'Moderate Reduction', 
        reduction: 2,
        difficulty: 'medium' as const,
      },
      {
        scenario: 'Aggressive Reduction',
        reduction: 3,
        difficulty: 'hard' as const,
      },
      {
        scenario: 'Meet Daily Goal',
        reduction: Math.max(0, currentScreenTimeHours - CONSTANTS.DAILY_SCREEN_TIME_GOAL_HOURS),
        difficulty: currentScreenTimeHours > 10 ? 'hard' : 'medium' as const,
      },
    ];

    return scenarios.map(({ scenario, reduction, difficulty }) => {
      const targetHours = Math.max(1, currentScreenTimeHours - reduction);
      const savings = this.calculateScreenTimeToSavings(currentScreenTimeHours, targetHours);
      
      return {
        scenario,
        targetHours,
        dailyTokens: savings.dailyTokensPotential,
        monthlyKES: Math.round(savings.monthlyKESEquivalent),
        annualKES: Math.round(savings.annualSavingsPotential),
        difficulty,
      };
    }).filter(s => s.dailyTokens > 0); // Only show scenarios that earn tokens
  }

  /**
   * Calculate retirement/long-term savings projection
   */
  calculateLongTermSavings(
    monthlyTokenContribution: number,
    years: number,
    averageMMFRate: number = 9 // Average MMF rate
  ): {
    totalContributions: number;
    projectedValue: number;
    totalReturns: number;
    monthlyKESValue: number;
    breakdownByYear: Array<{
      year: number;
      contributions: number;
      value: number;
      returns: number;
    }>;
  } {
    const monthlyKESContribution = monthlyTokenContribution * CONSTANTS.KES_PER_TOKEN;
    const monthlyRate = averageMMFRate / 100 / 12;
    const totalMonths = years * 12;
    
    // Calculate future value of monthly contributions
    const futureValue = monthlyKESContribution * (((1 + monthlyRate) ** totalMonths - 1) / monthlyRate);
    const totalContributions = monthlyKESContribution * totalMonths;
    const totalReturns = futureValue - totalContributions;
    
    // Generate year-by-year breakdown
    const breakdownByYear = [];
    for (let year = 1; year <= years; year++) {
      const monthsToThisYear = year * 12;
      const valueAtYear = monthlyKESContribution * (((1 + monthlyRate) ** monthsToThisYear - 1) / monthlyRate);
      const contributionsAtYear = monthlyKESContribution * monthsToThisYear;
      const returnsAtYear = valueAtYear - contributionsAtYear;
      
      breakdownByYear.push({
        year,
        contributions: Math.round(contributionsAtYear),
        value: Math.round(valueAtYear),
        returns: Math.round(returnsAtYear),
      });
    }
    
    return {
      totalContributions: Math.round(totalContributions),
      projectedValue: Math.round(futureValue),
      totalReturns: Math.round(totalReturns),
      monthlyKESValue: Math.round(monthlyKESContribution),
      breakdownByYear,
    };
  }

  /**
   * Calculate optimal savings allocation
   */
  calculateOptimalAllocation(
    monthlyTokens: number,
    savingsGoals: SavingsGoal[]
  ): {
    allocation: Array<{
      goalId: string;
      goalName: string;
      recommendedTokens: number;
      recommendedKES: number;
      priority: 'high' | 'medium' | 'low';
    }>;
    remainingTokens: number;
    totalAllocated: number;
  } {
    if (savingsGoals.length === 0) {
      return {
        allocation: [],
        remainingTokens: monthlyTokens,
        totalAllocated: 0,
      };
    }

    // Sort goals by urgency (time to target date) and completion percentage
    const prioritizedGoals = savingsGoals
      .filter(goal => goal.isActive)
      .map(goal => {
        const timeRemaining = goal.targetDate - Date.now();
        const completion = goal.currentAmount / goal.targetAmount;
        const urgency = timeRemaining / CONSTANTS.TIME.DAY; // Days remaining
        
        let priority: 'high' | 'medium' | 'low' = 'medium';
        if (urgency < 30 && completion < 0.8) priority = 'high';
        else if (urgency < 90 || completion > 0.8) priority = 'medium';
        else priority = 'low';
        
        return { ...goal, urgency, completion, priority };
      })
      .sort((a, b) => {
        // Sort by priority first, then by urgency
        const priorityOrder = { high: 0, medium: 1, low: 2 };
        if (priorityOrder[a.priority] !== priorityOrder[b.priority]) {
          return priorityOrder[a.priority] - priorityOrder[b.priority];
        }
        return a.urgency - b.urgency;
      });

    const monthlyKES = monthlyTokens * CONSTANTS.KES_PER_TOKEN;
    let remainingKES = monthlyKES;
    let totalAllocatedTokens = 0;
    
    const allocation = prioritizedGoals.map(goal => {
      const amountNeeded = goal.targetAmount - goal.currentAmount;
      const timeRemainingDays = Math.max(1, goal.urgency);
      const monthlyNeed = (amountNeeded / timeRemainingDays) * 30;
      
      // Allocate based on priority and available funds
      let recommendedKES = Math.min(remainingKES, monthlyNeed);
      
      // Minimum allocation for high priority goals
      if (goal.priority === 'high' && recommendedKES < monthlyNeed * 0.3) {
        recommendedKES = Math.min(remainingKES, monthlyNeed * 0.5);
      }
      
      const recommendedTokens = Math.floor(recommendedKES / CONSTANTS.KES_PER_TOKEN);
      recommendedKES = recommendedTokens * CONSTANTS.KES_PER_TOKEN; // Align with token conversion
      
      remainingKES -= recommendedKES;
      totalAllocatedTokens += recommendedTokens;
      
      return {
        goalId: goal.id,
        goalName: goal.name,
        recommendedTokens,
        recommendedKES,
        priority: goal.priority,
      };
    }).filter(allocation => allocation.recommendedTokens > 0);

    return {
      allocation,
      remainingTokens: monthlyTokens - totalAllocatedTokens,
      totalAllocated: totalAllocatedTokens,
    };
  }
}

export const savingsSimulator = new SavingsSimulator();
