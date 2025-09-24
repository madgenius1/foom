import { CONSTANTS } from '../utils/constants';

export interface RewardCalculation {
  tokensEarned: number;
  hoursUnderGoal: number;
  dailyGoalMet: boolean;
  streakBonus: number;
  totalReward: number;
  breakdown: RewardBreakdown[];
}

export interface RewardBreakdown {
  type: 'base' | 'streak' | 'milestone' | 'challenge';
  description: string;
  tokens: number;
}

export interface WeeklyStreak {
  currentStreak: number;
  longestStreak: number;
  weeklyGoalsMet: number;
}

export interface Challenge {
  id: string;
  title: string;
  description: string;
  targetValue: number;
  currentValue: number;
  reward: number;
  isCompleted: boolean;
  expiresAt: number;
}

class RewardsEngine {
  private readonly BASE_TOKENS_PER_HOUR = CONSTANTS.TOKENS_PER_HOUR_SAVED;
  private readonly DAILY_GOAL_HOURS = CONSTANTS.DAILY_SCREEN_TIME_GOAL_HOURS;

  /**
   * Calculate tokens earned based on screen time vs goal
   */
  calculateDailyReward(
    screenTimeMs: number,
    goalHours: number = this.DAILY_GOAL_HOURS,
    currentStreak: number = 0
  ): RewardCalculation {
    const screenTimeHours = screenTimeMs / CONSTANTS.TIME.HOUR;
    const hoursUnderGoal = Math.max(0, goalHours - screenTimeHours);
    const dailyGoalMet = screenTimeHours <= goalHours;
    
    const breakdown: RewardBreakdown[] = [];
    let totalTokens = 0;
    
    // Base reward for time under goal
    const baseTokens = Math.floor(hoursUnderGoal * this.BASE_TOKENS_PER_HOUR);
    if (baseTokens > 0) {
      breakdown.push({
        type: 'base',
        description: `${hoursUnderGoal.toFixed(1)} hours under goal`,
        tokens: baseTokens,
      });
      totalTokens += baseTokens;
    }
    
    // Streak bonus
    const streakBonus = this.calculateStreakBonus(currentStreak, dailyGoalMet);
    if (streakBonus > 0) {
      breakdown.push({
        type: 'streak',
        description: `${currentStreak} day streak bonus`,
        tokens: streakBonus,
      });
      totalTokens += streakBonus;
    }
    
    // Milestone bonuses
    const milestoneBonus = this.calculateMilestoneBonus(screenTimeHours, goalHours);
    if (milestoneBonus > 0) {
      breakdown.push({
        type: 'milestone',
        description: this.getMilestoneDescription(screenTimeHours, goalHours),
        tokens: milestoneBonus,
      });
      totalTokens += milestoneBonus;
    }
    
    return {
      tokensEarned: baseTokens,
      hoursUnderGoal,
      dailyGoalMet,
      streakBonus,
      totalReward: totalTokens,
      breakdown,
    };
  }
  
  /**
   * Calculate bonus tokens for maintaining streaks
   */
  calculateStreakBonus(currentStreak: number, goalMet: boolean): number {
    if (!goalMet || currentStreak < 2) return 0;
    
    // Escalating streak bonuses
    if (currentStreak >= 30) return 50; // Monthly streak
    if (currentStreak >= 21) return 35; // 3 weeks
    if (currentStreak >= 14) return 25; // 2 weeks
    if (currentStreak >= 7) return 15;  // 1 week
    if (currentStreak >= 3) return 5;   // 3 days
    
    return 2; // 2 days minimum
  }
  
  /**
   * Calculate milestone bonuses for exceptional performance
   */
  private calculateMilestoneBonus(screenTimeHours: number, goalHours: number): number {
    const percentageUnderGoal = ((goalHours - screenTimeHours) / goalHours) * 100;
    
    if (percentageUnderGoal >= 50) return 20; // 50%+ under goal
    if (percentageUnderGoal >= 25) return 10; // 25%+ under goal
    
    return 0;
  }
  
  /**
   * Get description for milestone achievements
   */
  private getMilestoneDescription(screenTimeHours: number, goalHours: number): string {
    const percentageUnderGoal = ((goalHours - screenTimeHours) / goalHours) * 100;
    
    if (percentageUnderGoal >= 50) return 'Exceptional! 50%+ under goal';
    if (percentageUnderGoal >= 25) return 'Great job! 25%+ under goal';
    
    return 'Milestone achieved';
  }
  
  /**
   * Calculate weekly performance summary
   */
  calculateWeeklyPerformance(dailyScreenTimes: number[]): {
    totalTokensEarned: number;
    averageScreenTime: number;
    goalsMetCount: number;
    streakData: WeeklyStreak;
    performance: 'excellent' | 'good' | 'needs_improvement';
  } {
    if (dailyScreenTimes.length === 0) {
      return {
        totalTokensEarned: 0,
        averageScreenTime: 0,
        goalsMetCount: 0,
        streakData: { currentStreak: 0, longestStreak: 0, weeklyGoalsMet: 0 },
        performance: 'needs_improvement',
      };
    }
    
    let totalTokens = 0;
    let goalsMetCount = 0;
    let currentStreak = 0;
    let longestStreak = 0;
    let tempStreak = 0;
    
    for (const screenTimeMs of dailyScreenTimes) {
      const reward = this.calculateDailyReward(screenTimeMs, this.DAILY_GOAL_HOURS, tempStreak);
      totalTokens += reward.totalReward;
      
      if (reward.dailyGoalMet) {
        goalsMetCount++;
        tempStreak++;
        longestStreak = Math.max(longestStreak, tempStreak);
      } else {
        tempStreak = 0;
      }
    }
    
    currentStreak = tempStreak;
    const averageScreenTime = dailyScreenTimes.reduce((sum, time) => sum + time, 0) / dailyScreenTimes.length;
    
    // Determine performance level
    let performance: 'excellent' | 'good' | 'needs_improvement';
    const goalPercentage = goalsMetCount / dailyScreenTimes.length;
    
    if (goalPercentage >= 0.8) performance = 'excellent';
    else if (goalPercentage >= 0.5) performance = 'good';
    else performance = 'needs_improvement';
    
    return {
      totalTokensEarned: totalTokens,
      averageScreenTime,
      goalsMetCount,
      streakData: {
        currentStreak,
        longestStreak,
        weeklyGoalsMet: goalsMetCount,
      },
      performance,
    };
  }
  
  /**
   * Generate daily challenges for users
   */
  generateDailyChallenges(): Challenge[] {
    const now = Date.now();
    const tomorrow = now + CONSTANTS.TIME.DAY;
    
    return [
      {
        id: 'social_media_free',
        title: 'Social Media Free Morning',
        description: 'Avoid social media apps before 10 AM',
        targetValue: 1, // Binary: 0 or 1
        currentValue: 0,
        reward: 15,
        isCompleted: false,
        expiresAt: tomorrow,
      },
      {
        id: 'under_goal_challenge',
        title: 'Beat Your Goal by 1 Hour',
        description: 'Stay 1 hour under your daily screen time goal',
        targetValue: 1,
        currentValue: 0,
        reward: 20,
        isCompleted: false,
        expiresAt: tomorrow,
      },
      {
        id: 'productive_hour',
        title: 'One Productive Hour',
        description: 'Spend at least 1 hour on productivity apps',
        targetValue: 60, // 60 minutes
        currentValue: 0,
        reward: 10,
        isCompleted: false,
        expiresAt: tomorrow,
      },
    ];
  }
  
  /**
   * Generate weekly challenges
   */
  generateWeeklyChallenges(): Challenge[] {
    const now = Date.now();
    const nextWeek = now + (7 * CONSTANTS.TIME.DAY);
    
    return [
      {
        id: 'perfect_week',
        title: 'Perfect Week',
        description: 'Meet your daily goal every day this week',
        targetValue: 7,
        currentValue: 0,
        reward: 100,
        isCompleted: false,
        expiresAt: nextWeek,
      },
      {
        id: 'weekend_warrior',
        title: 'Weekend Warrior',
        description: 'Reduce weekend screen time by 20%',
        targetValue: 2, // Both weekend days
        currentValue: 0,
        reward: 30,
        isCompleted: false,
        expiresAt: nextWeek,
      },
    ];
  }
  
  /**
   * Calculate bonus for completing challenges
   */
  calculateChallengeReward(challenge: Challenge): number {
    if (!challenge.isCompleted) return 0;
    
    // Bonus multiplier based on challenge difficulty
    let multiplier = 1;
    
    if (challenge.reward >= 50) multiplier = 1.5; // Hard challenges
    else if (challenge.reward >= 25) multiplier = 1.2; // Medium challenges
    
    return Math.floor(challenge.reward * multiplier);
  }
  
  /**
   * Get personalized reward message
   */
  getRewardMessage(reward: RewardCalculation): string {
    if (reward.totalReward === 0) {
      return "Keep trying! Every hour matters toward your goal.";
    }
    
    if (reward.totalReward >= 50) {
      return `🎉 Amazing! You earned ${reward.totalReward} tokens today!`;
    }
    
    if (reward.totalReward >= 20) {
      return `🌟 Great job! You earned ${reward.totalReward} tokens!`;
    }
    
    return `👍 Nice work! You earned ${reward.totalReward} tokens today.`;
  }
  
  /**
   * Calculate potential earnings for motivation
   */
  calculatePotentialEarnings(currentScreenTimeMs: number, goalHours: number): {
    currentTokens: number;
    potentialTokens: number;
    hoursToMaxReward: number;
    maxPossibleTokens: number;
  } {
    const currentReward = this.calculateDailyReward(currentScreenTimeMs, goalHours);
    
    // Calculate potential if user stops using devices now
    const hoursToMaxReward = Math.max(0, goalHours);
    const maxPossibleTokens = hoursToMaxReward * this.BASE_TOKENS_PER_HOUR;
    
    // Calculate what they could earn if they meet their goal
    const goalScreenTimeMs = goalHours * CONSTANTS.TIME.HOUR;
    const potentialReward = this.calculateDailyReward(goalScreenTimeMs, goalHours);
    
    return {
      currentTokens: currentReward.totalReward,
      potentialTokens: potentialReward.totalReward,
      hoursToMaxReward,
      maxPossibleTokens,
    };
  }

  /**
   * Calculate app-specific rewards and penalties
   */
  calculateAppSpecificRewards(appUsage: Array<{
    packageName: string;
    timeSpent: number;
    category: string;
  }>): {
    productiveAppBonus: number;
    socialMediaPenalty: number;
    categoryBreakdown: Record<string, number>;
  } {
    let productiveAppBonus = 0;
    let socialMediaPenalty = 0;
    const categoryBreakdown: Record<string, number> = {};

    appUsage.forEach(app => {
      const hours = app.timeSpent / CONSTANTS.TIME.HOUR;
      
      // Bonus for productive apps
      if (app.category === 'Productivity' || app.category === 'Education') {
        const bonus = Math.floor(hours * 2); // 2 tokens per hour
        productiveAppBonus += bonus;
        categoryBreakdown[app.category] = (categoryBreakdown[app.category] || 0) + bonus;
      }
      
      // Penalty for excessive social media
      if (app.category === 'Social Media' && hours > 2) {
        const penalty = Math.floor((hours - 2) * 3); // 3 token penalty per hour over 2 hours
        socialMediaPenalty += penalty;
        categoryBreakdown[app.category] = (categoryBreakdown[app.category] || 0) - penalty;
      }
    });

    return {
      productiveAppBonus,
      socialMediaPenalty,
      categoryBreakdown,
    };
  }

  /**
   * Generate personalized recommendations based on usage patterns
   */
  generateRecommendations(screenTimeData: {
    dailyScreenTimes: number[];
    appUsage: Array<{packageName: string; timeSpent: number; category: string}>;
    currentStreak: number;
  }): string[] {
    const recommendations: string[] = [];
    const avgScreenTime = screenTimeData.dailyScreenTimes.reduce((a, b) => a + b, 0) / screenTimeData.dailyScreenTimes.length;
    const avgHours = avgScreenTime / CONSTANTS.TIME.HOUR;

    // Screen time recommendations
    if (avgHours > this.DAILY_GOAL_HOURS + 2) {
      recommendations.push('Try reducing screen time by 1 hour daily for better rewards');
    }

    // App-specific recommendations
    const socialMediaTime = screenTimeData.appUsage
      .filter(app => app.category === 'Social Media')
      .reduce((total, app) => total + app.timeSpent, 0);
    
    if (socialMediaTime > 2 * CONSTANTS.TIME.HOUR) {
      recommendations.push('Consider limiting social media to 2 hours daily');
    }

    // Streak recommendations
    if (screenTimeData.currentStreak === 0) {
      recommendations.push('Start a streak by meeting your daily goal!');
    } else if (screenTimeData.currentStreak < 7) {
      recommendations.push('Keep going! Aim for a 7-day streak for bonus rewards');
    }

    // Productivity recommendations
    const productiveTime = screenTimeData.appUsage
      .filter(app => app.category === 'Productivity' || app.category === 'Education')
      .reduce((total, app) => total + app.timeSpent, 0);
    
    if (productiveTime < CONSTANTS.TIME.HOUR) {
      recommendations.push('Spend at least 1 hour on productive apps for bonus tokens');
    }

    return recommendations.slice(0, 3); // Limit to top 3 recommendations
  }

  /**
   * Calculate seasonal/event bonuses
   */
  calculateEventBonus(date: Date = new Date()): {
    eventName: string;
    bonusMultiplier: number;
    description: string;
  } | null {
    const month = date.getMonth();
    const day = date.getDate();

    // New Year resolution boost
    if (month === 0 && day <= 31) {
      return {
        eventName: 'New Year Resolution',
        bonusMultiplier: 1.5,
        description: 'Double rewards for building healthy habits in January!',
      };
    }

    // Back to school focus (September)
    if (month === 8) {
      return {
        eventName: 'Focus Month',
        bonusMultiplier: 1.25,
        description: 'Extra rewards for staying focused during back-to-school season!',
      };
    }

    return null;
  }
}

export const rewardsEngine = new RewardsEngine();