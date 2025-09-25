import AsyncStorage from '@react-native-async-storage/async-storage';
import { CONSTANTS } from '../utils/constants';

export interface StorageItem<T = any> {
  value: T;
  timestamp: number;
  expiresAt?: number;
}

class StorageService {
  /**
   * Store data in AsyncStorage with optional expiration
   */
  async setItem<T>(key: string, value: T, expirationMinutes?: number): Promise<void> {
    try {
      const item: StorageItem<T> = {
        value,
        timestamp: Date.now(),
        expiresAt: expirationMinutes ? Date.now() + (expirationMinutes * 60 * 1000) : undefined,
      };
      
      await AsyncStorage.setItem(key, JSON.stringify(item));
    } catch (error) {
      console.error(`Error storing item with key ${key}:`, error);
      throw new Error(`Failed to store data: ${error}`);
    }
  }

  /**
   * Retrieve data from AsyncStorage with expiration check
   */
  async getItem<T>(key: string): Promise<T | null> {
    try {
      const stored = await AsyncStorage.getItem(key);
      
      if (!stored) {
        return null;
      }
      
      const item: StorageItem<T> = JSON.parse(stored);
      
      // Check if item has expired
      if (item.expiresAt && Date.now() > item.expiresAt) {
        await this.removeItem(key);
        return null;
      }
      
      return item.value;
    } catch (error) {
      console.error(`Error retrieving item with key ${key}:`, error);
      return null;
    }
  }

  /**
   * Remove item from AsyncStorage
   */
  async removeItem(key: string): Promise<void> {
    try {
      await AsyncStorage.removeItem(key);
    } catch (error) {
      console.error(`Error removing item with key ${key}:`, error);
      throw new Error(`Failed to remove data: ${error}`);
    }
  }

  /**
   * Clear all AsyncStorage data
   */
  async clear(): Promise<void> {
    try {
      await AsyncStorage.clear();
    } catch (error) {
      console.error('Error clearing AsyncStorage:', error);
      throw new Error(`Failed to clear storage: ${error}`);
    }
  }

  /**
   * Get all keys from AsyncStorage
   */
  async getAllKeys(): Promise<string[]> {
    try {
      return await AsyncStorage.getAllKeys();
    } catch (error) {
      console.error('Error getting all keys:', error);
      return [];
    }
  }

  /**
   * Get multiple items at once
   */
  async multiGet(keys: string[]): Promise<Record<string, any>> {
    try {
      const results = await AsyncStorage.multiGet(keys);
      const data: Record<string, any> = {};
      
      for (const [key, value] of results) {
        if (value) {
          try {
            const item: StorageItem = JSON.parse(value);
            
            // Check expiration
            if (item.expiresAt && Date.now() > item.expiresAt) {
              await this.removeItem(key);
              continue;
            }
            
            data[key] = item.value;
          } catch (parseError) {
            console.warn(`Failed to parse item with key ${key}:`, parseError);
          }
        }
      }
      
      return data;
    } catch (error) {
      console.error('Error getting multiple items:', error);
      return {};
    }
  }

  /**
   * Store multiple items at once
   */
  async multiSet(items: Array<[string, any]>): Promise<void> {
    try {
      const preparedItems: Array<[string, string]> = items.map(([key, value]) => {
        const item: StorageItem = {
          value,
          timestamp: Date.now(),
        };
        return [key, JSON.stringify(item)];
      });
      
      await AsyncStorage.multiSet(preparedItems);
    } catch (error) {
      console.error('Error setting multiple items:', error);
      throw new Error(`Failed to store multiple items: ${error}`);
    }
  }

  /**
   * Check if key exists in storage
   */
  async hasItem(key: string): Promise<boolean> {
    try {
      const value = await AsyncStorage.getItem(key);
      return value !== null;
    } catch (error) {
      console.error(`Error checking if key ${key} exists:`, error);
      return false;
    }
  }

  /**
   * Get storage size information
   */
  async getStorageSize(): Promise<{
    used: number;
    available: number;
    total: number;
    keys: number;
  }> {
    try {
      const keys = await this.getAllKeys();
      let totalSize = 0;
      
      for (const key of keys) {
        const value = await AsyncStorage.getItem(key);
        if (value) {
          totalSize += key.length + value.length;
        }
      }
      
      // Rough estimates (actual limits vary by device)
      const estimatedLimit = 10 * 1024 * 1024; // 10MB estimate
      
      return {
        used: totalSize,
        available: Math.max(0, estimatedLimit - totalSize),
        total: estimatedLimit,
        keys: keys.length,
      };
    } catch (error) {
      console.error('Error calculating storage size:', error);
      return { used: 0, available: 0, total: 0, keys: 0 };
    }
  }

  /**
   * Clean up expired items
   */
  async cleanupExpired(): Promise<number> {
    try {
      const keys = await this.getAllKeys();
      let cleanedCount = 0;
      
      for (const key of keys) {
        try {
          const stored = await AsyncStorage.getItem(key);
          if (stored) {
            const item: StorageItem = JSON.parse(stored);
            if (item.expiresAt && Date.now() > item.expiresAt) {
              await this.removeItem(key);
              cleanedCount++;
            }
          }
        } catch (error) {
          // If item is corrupted, remove it
          await this.removeItem(key);
          cleanedCount++;
        }
      }
      
      return cleanedCount;
    } catch (error) {
      console.error('Error cleaning up expired items:', error);
      return 0;
    }
  }

  // FOOM-specific storage methods
  
  /**
   * Store user preferences
   */
  async setUserPreferences(preferences: any): Promise<void> {
    await this.setItem(CONSTANTS.STORAGE_KEYS.USER_PREFERENCES, preferences);
  }

  /**
   * Get user preferences
   */
  async getUserPreferences(): Promise<any> {
    return await this.getItem(CONSTANTS.STORAGE_KEYS.USER_PREFERENCES);
  }

  /**
   * Store screen time data
   */
  async setScreenTimeData(date: string, data: any): Promise<void> {
    const key = `${CONSTANTS.STORAGE_KEYS.SCREEN_TIME_DATA}_${date}`;
    await this.setItem(key, data);
  }

  /**
   * Get screen time data for a specific date
   */
  async getScreenTimeData(date: string): Promise<any> {
    const key = `${CONSTANTS.STORAGE_KEYS.SCREEN_TIME_DATA}_${date}`;
    return await this.getItem(key);
  }

  /**
   * Store blocked apps configuration
   */
  async setBlockedApps(apps: any[]): Promise<void> {
    await this.setItem(CONSTANTS.STORAGE_KEYS.BLOCKED_APPS, apps);
  }

  /**
   * Get blocked apps configuration
   */
  async getBlockedApps(): Promise<any[]> {
    const apps = await this.getItem(CONSTANTS.STORAGE_KEYS.BLOCKED_APPS);
    return apps || [];
  }

  /**
   * Mark onboarding as complete
   */
  async setOnboardingComplete(): Promise<void> {
    await this.setItem(CONSTANTS.STORAGE_KEYS.ONBOARDING_COMPLETE, true);
  }

  /**
   * Check if onboarding is complete
   */
  async isOnboardingComplete(): Promise<boolean> {
    const completed = await this.getItem(CONSTANTS.STORAGE_KEYS.ONBOARDING_COMPLETE);
    return completed === true;
  }

  /**
   * Store last sync timestamp
   */
  async setLastSync(timestamp: number): Promise<void> {
    await this.setItem(CONSTANTS.STORAGE_KEYS.LAST_SYNC, timestamp);
  }

  /**
   * Get last sync timestamp
   */
  async getLastSync(): Promise<number> {
    const timestamp = await this.getItem(CONSTANTS.STORAGE_KEYS.LAST_SYNC);
    return timestamp || 0;
  }

  /**
   * Store app version for migration purposes
   */
  async setAppVersion(version: string): Promise<void> {
    await this.setItem(CONSTANTS.STORAGE_KEYS.APP_VERSION, version);
  }

  /**
   * Get stored app version
   */
  async getAppVersion(): Promise<string | null> {
    return await this.getItem(CONSTANTS.STORAGE_KEYS.APP_VERSION);
  }

  /**
   * Cache data temporarily (with expiration)
   */
  async setCacheData(key: string, data: any, expirationMinutes: number = 60): Promise<void> {
    await this.setItem(`cache_${key}`, data, expirationMinutes);
  }

  /**
   * Get cached data
   */
  async getCacheData(key: string): Promise<any> {
    return await this.getItem(`cache_${key}`);
  }

  /**
   * Clear all cache data
   */
  async clearCache(): Promise<void> {
    try {
      const keys = await this.getAllKeys();
      const cacheKeys = keys.filter(key => key.startsWith('cache_'));
      
      for (const key of cacheKeys) {
        await this.removeItem(key);
      }
    } catch (error) {
      console.error('Error clearing cache:', error);
    }
  }

  /**
   * Store user authentication token
   */
  async setAuthToken(token: string, expirationMinutes: number = 60 * 24): Promise<void> {
    await this.setItem('@foom_auth_token', token, expirationMinutes);
  }

  /**
   * Get user authentication token
   */
  async getAuthToken(): Promise<string | null> {
    return await this.getItem('@foom_auth_token');
  }

  /**
   * Remove authentication token
   */
  async removeAuthToken(): Promise<void> {
    await this.removeItem('@foom_auth_token');
  }

  /**
   * Store screen time goals
   */
  async setScreenTimeGoals(goals: any): Promise<void> {
    await this.setItem('@foom_screen_time_goals', goals);
  }

  /**
   * Get screen time goals
   */
  async getScreenTimeGoals(): Promise<any> {
    return await this.getItem('@foom_screen_time_goals');
  }

  /**
   * Store investment preferences
   */
  async setInvestmentPreferences(preferences: any): Promise<void> {
    await this.setItem('@foom_investment_preferences', preferences);
  }

  /**
   * Get investment preferences
   */
  async getInvestmentPreferences(): Promise<any> {
    return await this.getItem('@foom_investment_preferences');
  }

  /**
   * Store notification settings
   */
  async setNotificationSettings(settings: any): Promise<void> {
    await this.setItem('@foom_notification_settings', settings);
  }

  /**
   * Get notification settings
   */
  async getNotificationSettings(): Promise<any> {
    const defaultSettings = {
      screenTimeAlerts: true,
      rewardNotifications: true,
      investmentUpdates: true,
      weeklyReports: true,
      dailyReminders: false,
    };
    
    const stored = await this.getItem('@foom_notification_settings');
    return { ...defaultSettings, ...stored };
  }

  /**
   * Store app usage statistics
   */
  async setAppUsageStats(date: string, stats: any): Promise<void> {
    const key = `@foom_usage_stats_${date}`;
    await this.setItem(key, stats);
  }

  /**
   * Get app usage statistics for date range
   */
  async getAppUsageStats(startDate: string, endDate: string): Promise<any[]> {
    const keys = await this.getAllKeys();
    const usageKeys = keys.filter(key => 
      key.startsWith('@foom_usage_stats_') && 
      key >= `@foom_usage_stats_${startDate}` && 
      key <= `@foom_usage_stats_${endDate}`
    );
    
    const usageData = await this.multiGet(usageKeys);
    return Object.values(usageData);
  }

  /**
   * Store rewards history
   */
  async setRewardsHistory(rewards: any[]): Promise<void> {
    await this.setItem('@foom_rewards_history', rewards);
  }

  /**
   * Get rewards history
   */
  async getRewardsHistory(): Promise<any[]> {
    const history = await this.getItem('@foom_rewards_history');
    return history || [];
  }

  /**
   * Add single reward to history
   */
  async addReward(reward: any): Promise<void> {
    const history = await this.getRewardsHistory();
    history.unshift(reward); // Add to beginning
    
    // Keep only last 1000 rewards
    if (history.length > 1000) {
      history.splice(1000);
    }
    
    await this.setRewardsHistory(history);
  }

  /**
   * Export all FOOM data for backup
   */
  async exportData(): Promise<string> {
    try {
      const keys = await this.getAllKeys();
      const foomKeys = keys.filter(key => 
        key.startsWith('@foom_') || 
        Object.values(CONSTANTS.STORAGE_KEYS).some(storageKey => key.startsWith(storageKey))
      );
      
      const data = await this.multiGet(foomKeys);
      
      const exportData = {
        version: CONSTANTS.APP_VERSION,
        exportedAt: new Date().toISOString(),
        dataType: 'FOOM_BACKUP',
        data,
      };
      
      return JSON.stringify(exportData, null, 2);
    } catch (error) {
      console.error('Error exporting data:', error);
      throw new Error('Failed to export data');
    }
  }

  /**
   * Import data from backup
   */
  async importData(importString: string): Promise<void> {
    try {
      const importData = JSON.parse(importString);
      
      if (importData.dataType !== 'FOOM_BACKUP' || !importData.data) {
        throw new Error('Invalid backup file format');
      }
      
      // Validate version compatibility
      if (importData.version && importData.version !== CONSTANTS.APP_VERSION) {
        console.warn(`Importing data from different app version: ${importData.version}`);
      }
      
      // Import data
      const items: Array<[string, any]> = Object.entries(importData.data);
      await this.multiSet(items);
      
      console.log(`Successfully imported ${items.length} items from backup`);
      
    } catch (error) {
      console.error('Error importing data:', error);
      throw new Error(`Failed to import data: ${error}`);
    }
  }

  /**
   * Reset all FOOM data (for app reset)
   */
  async resetAppData(): Promise<void> {
    try {
      const keys = await this.getAllKeys();
      const foomKeys = keys.filter(key => 
        key.startsWith('@foom_') || 
        Object.values(CONSTANTS.STORAGE_KEYS).some(storageKey => key.startsWith(storageKey))
      );
      
      for (const key of foomKeys) {
        await this.removeItem(key);
      }
      
      console.log(`Successfully reset ${foomKeys.length} FOOM data items`);
    } catch (error) {
      console.error('Error resetting app data:', error);
      throw new Error('Failed to reset app data');
    }
  }

  /**
   * Migrate data between app versions
   */
  async migrateData(fromVersion: string, toVersion: string): Promise<void> {
    try {
      console.log(`Migrating data from ${fromVersion} to ${toVersion}`);
      
      // Add version-specific migration logic here
      if (fromVersion === '1.0.0' && toVersion === '1.1.0') {
        // Example migration logic
        const preferences = await this.getUserPreferences();
        if (preferences) {
          // Add new default preferences
          const updatedPreferences = {
            ...preferences,
            newFeatureEnabled: true,
          };
          await this.setUserPreferences(updatedPreferences);
        }
      }
      
      // Update stored app version
      await this.setAppVersion(toVersion);
      
      console.log('Data migration completed successfully');
    } catch (error) {
      console.error('Error during data migration:', error);
      throw new Error(`Migration failed: ${error}`);
    }
  }

  /**
   * Validate storage integrity
   */
  async validateStorageIntegrity(): Promise<{
    isValid: boolean;
    errors: string[];
    corruptedKeys: string[];
  }> {
    const errors: string[] = [];
    const corruptedKeys: string[] = [];
    
    try {
      const keys = await this.getAllKeys();
      
      for (const key of keys) {
        try {
          const value = await AsyncStorage.getItem(key);
          if (value) {
            JSON.parse(value); // Test if parseable
          }
        } catch (parseError) {
          errors.push(`Corrupted data for key: ${key}`);
          corruptedKeys.push(key);
        }
      }
      
      return {
        isValid: errors.length === 0,
        errors,
        corruptedKeys,
      };
    } catch (error) {
      return {
        isValid: false,
        errors: [`Storage validation failed: ${error}`],
        corruptedKeys: [],
      };
    }
  }

  /**
   * Repair corrupted storage items
   */
  async repairStorage(): Promise<number> {
    try {
      const { corruptedKeys } = await this.validateStorageIntegrity();
      
      for (const key of corruptedKeys) {
        await this.removeItem(key);
      }
      
      console.log(`Repaired storage by removing ${corruptedKeys.length} corrupted items`);
      return corruptedKeys.length;
    } catch (error) {
      console.error('Error repairing storage:', error);
      return 0;
    }
  }
}

export const storageService = new StorageService();