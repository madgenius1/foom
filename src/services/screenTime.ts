import { Platform, PermissionsAndroid } from 'react-native';
import { AppUsage } from '../store/screenTimeStore';

// Mock data for development/iOS
const MOCK_APPS: AppUsage[] = [
  {
    packageName: 'com.instagram.android',
    appName: 'Instagram',
    timeSpent: 2 * 60 * 60 * 1000, // 2 hours in milliseconds
    lastUsed: Date.now() - 30 * 60 * 1000, // 30 minutes ago
  },
  {
    packageName: 'com.whatsapp',
    appName: 'WhatsApp',
    timeSpent: 1.5 * 60 * 60 * 1000, // 1.5 hours
    lastUsed: Date.now() - 10 * 60 * 1000, // 10 minutes ago
  },
  {
    packageName: 'com.tiktok',
    appName: 'TikTok',
    timeSpent: 3 * 60 * 60 * 1000, // 3 hours
    lastUsed: Date.now() - 5 * 60 * 1000, // 5 minutes ago
  },
  {
    packageName: 'com.facebook.katana',
    appName: 'Facebook',
    timeSpent: 45 * 60 * 1000, // 45 minutes
    lastUsed: Date.now() - 60 * 60 * 1000, // 1 hour ago
  },
  {
    packageName: 'com.twitter.android',
    appName: 'Twitter',
    timeSpent: 30 * 60 * 1000, // 30 minutes
    lastUsed: Date.now() - 2 * 60 * 60 * 1000, // 2 hours ago
  },
];

class ScreenTimeService {
  private hasUsageStatsPermission = false;

  async requestUsageStatsPermission(): Promise<boolean> {
    if (Platform.OS !== 'android') {
      return false;
    }

    try {
      // Check if we already have permission
      if (this.hasUsageStatsPermission) {
        return true;
      }

      // Request usage stats permission
      // Note: This requires special handling in React Native
      // You'll need to use a native module or library like react-native-usage-stats
      const granted = await PermissionsAndroid.request(
        PermissionsAndroid.PERMISSIONS.PACKAGE_USAGE_STATS as any,
        {
          title: 'Usage Stats Permission',
          message: 'FOOM needs access to usage stats to track your screen time and reward you with tokens.',
          buttonNeutral: 'Ask Me Later',
          buttonNegative: 'Cancel',
          buttonPositive: 'OK',
        }
      );

      this.hasUsageStatsPermission = granted === PermissionsAndroid.RESULTS.GRANTED;
      return this.hasUsageStatsPermission;
    } catch (error) {
      console.error('Error requesting usage stats permission:', error);
      return false;
    }
  }

  async getTodayUsage(): Promise<AppUsage[]> {
    try {
      if (Platform.OS === 'android' && this.hasUsageStatsPermission) {
        // Use native Android UsageStatsManager
        return await this.getAndroidUsageStats();
      } else {
        // Fallback to mock data for development/iOS
        return this.getMockUsageData();
      }
    } catch (error) {
      console.error('Error getting usage data:', error);
      return this.getMockUsageData();
    }
  }

  private async getAndroidUsageStats(): Promise<AppUsage[]> {
    // This would integrate with react-native-usage-stats or similar library
    // For now, return mock data
    console.log('Getting Android usage stats...');
    
    // In a real implementation, you would:
    // 1. Import the native module
    // 2. Query usage stats for today
    // 3. Format the data as AppUsage[]
    
    return this.getMockUsageData();
  }

  private getMockUsageData(): AppUsage[] {
    // Add some randomization to make it feel more realistic
    return MOCK_APPS.map(app => ({
      ...app,
      timeSpent: app.timeSpent + (Math.random() - 0.5) * 30 * 60 * 1000, // ±15 minutes
      lastUsed: app.lastUsed + Math.random() * 10 * 60 * 1000, // Random within 10 minutes
    }));
  }

  async getWeeklyUsage(): Promise<Record<string, AppUsage[]>> {
    const weeklyData: Record<string, AppUsage[]> = {};
    
    // Generate mock data for the past 7 days
    for (let i = 0; i < 7; i++) {
      const date = new Date();
      date.setDate(date.getDate() - i);
      const dateKey = date.toISOString().split('T')[0];
      
      weeklyData[dateKey] = MOCK_APPS.map(app => ({
        ...app,
        timeSpent: app.timeSpent * (0.5 + Math.random()), // Vary usage by day
        lastUsed: date.getTime() - Math.random() * 24 * 60 * 60 * 1000,
      }));
    }
    
    return weeklyData;
  }

  getTotalScreenTime(apps: AppUsage[]): number {
    return apps.reduce((total, app) => total + app.timeSpent, 0);
  }

  getMostUsedApps(apps: AppUsage[], limit: number = 5): AppUsage[] {
    return apps
      .sort((a, b) => b.timeSpent - a.timeSpent)
      .slice(0, limit);
  }

  calculateTokensEarned(screenTimeMs: number, goalHours: number = 8): number {
    const screenTimeHours = screenTimeMs / (1000 * 60 * 60);
    const hoursUnderGoal = Math.max(0, goalHours - screenTimeHours);
    return Math.round(hoursUnderGoal * 10); // 10 tokens per hour under goal
  }

  isAppBlocked(packageName: string, blockedApps: string[]): boolean {
    return blockedApps.includes(packageName);
  }

  formatUsageTime(milliseconds: number): string {
    const hours = Math.floor(milliseconds / (1000 * 60 * 60));
    const minutes = Math.floor((milliseconds % (1000 * 60 * 60)) / (1000 * 60));
    
    if (hours > 0) {
      return `${hours}h ${minutes}m`;
    }
    return `${minutes}m`;
  }

  // Simulate blocking an app (would require system-level access in production)
  async blockApp(packageName: string): Promise<boolean> {
    console.log(`Simulating blocking app: ${packageName}`);
    // In production, this would require accessibility service or device admin permissions
    return true;
  }

  async unblockApp(packageName: string): Promise<boolean> {
    console.log(`Simulating unblocking app: ${packageName}`);
    return true;
  }
}

export const screenTimeService = new ScreenTimeService();