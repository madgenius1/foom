// FOOM App Constants

export const CONSTANTS = {
  // App Information
  APP_NAME: 'FOOM',
  APP_VERSION: '1.0.0',
  APP_TAGLINE: 'Focus. Earn. Invest.',
  
  // Screen Time Constants
  TOKENS_PER_HOUR_SAVED: 10,
  DAILY_SCREEN_TIME_GOAL_HOURS: 8,
  MAX_DAILY_SCREEN_TIME_HOURS: 16,
  MIN_DAILY_SCREEN_TIME_HOURS: 1,
  
  // Token Economics
  TOKENS_PER_KES: 10, // 10 tokens = 1 KES
  KES_PER_TOKEN: 0.1, // 1 token = 0.1 KES
  MIN_INVESTMENT_TOKENS: 100, // Minimum 100 tokens to invest
  MIN_WITHDRAWAL_TOKENS: 50, // Minimum 50 tokens to withdraw
  
  // Investment Constants
  MIN_INVESTMENT_KES: 500,
  MAX_INVESTMENT_KES: 1000000,
  DAILY_COMPOUND_FREQUENCY: 365, // For daily compounding
  
  // Firebase Collections
  COLLECTIONS: {
    USERS: 'users',
    SCREEN_TIME: 'screenTime',
    TRANSACTIONS: 'transactions',
    INVESTMENTS: 'investments',
    USER_SETTINGS: 'userSettings',
    APP_BLOCKED: 'blockedApps',
    NOTIFICATIONS: 'notifications',
  },
  
  // Money Market Fund Options
  MMF_OPTIONS: [
    {
      id: 'cic_mmf',
      name: 'CIC Money Market Fund',
      rate: 8.5,
      minInvestment: 1000,
      riskLevel: 'Low',
      provider: 'CIC Asset Management',
      description: 'Conservative money market fund with steady returns',
    },
    {
      id: 'equity_mmf',
      name: 'Equity Money Market Fund',
      rate: 9.2,
      minInvestment: 1000,
      riskLevel: 'Low',
      provider: 'Equity Investment Bank',
      description: 'Well-managed fund with competitive returns',
    },
    {
      id: 'ncba_mmf',
      name: 'NCBA Money Market Fund',
      rate: 8.8,
      minInvestment: 500,
      riskLevel: 'Low',
      provider: 'NCBA Investment Bank',
      description: 'Accessible fund with low minimum investment',
    },
    {
      id: 'cytonn_mmf',
      name: 'Cytonn Money Market Fund',
      rate: 10.1,
      minInvestment: 1000,
      riskLevel: 'Medium',
      provider: 'Cytonn Asset Managers',
      description: 'Higher returns with slightly higher risk',
    },
    {
      id: 'britam_mmf',
      name: 'Britam Money Market Fund',
      rate: 8.3,
      minInvestment: 1000,
      riskLevel: 'Low',
      provider: 'Britam Asset Management',
      description: 'Stable returns from established fund manager',
    },
  ],
  
  // Popular Apps for Blocking/Monitoring
  POPULAR_APPS: [
    {
      packageName: 'com.instagram.android',
      appName: 'Instagram',
      category: 'Social Media',
      icon: 'instagram',
      color: '#E4405F',
    },
    {
      packageName: 'com.facebook.katana',
      appName: 'Facebook',
      category: 'Social Media',
      icon: 'facebook',
      color: '#1877F2',
    },
    {
      packageName: 'com.twitter.android',
      appName: 'Twitter',
      category: 'Social Media',
      icon: 'twitter',
      color: '#1DA1F2',
    },
    {
      packageName: 'com.zhiliaoapp.musically',
      appName: 'TikTok',
      category: 'Entertainment',
      icon: 'music-note',
      color: '#FF0050',
    },
    {
      packageName: 'com.google.android.youtube',
      appName: 'YouTube',
      category: 'Entertainment',
      icon: 'youtube',
      color: '#FF0000',
    },
    {
      packageName: 'com.snapchat.android',
      appName: 'Snapchat',
      category: 'Social Media',
      icon: 'snapchat',
      color: '#FFFC00',
    },
    {
      packageName: 'com.netflix.mediaclient',
      appName: 'Netflix',
      category: 'Entertainment',
      icon: 'netflix',
      color: '#E50914',
    },
    {
      packageName: 'com.whatsapp',
      appName: 'WhatsApp',
      category: 'Communication',
      icon: 'whatsapp',
      color: '#25D366',
    },
  ],
  
  // Notification Channels
  NOTIFICATION_CHANNELS: {
    SCREEN_TIME: {
      id: 'screen_time_alerts',
      name: 'Screen Time Alerts',
      description: 'Notifications about your daily screen time usage',
      importance: 'default',
    },
    REWARDS: {
      id: 'reward_notifications',
      name: 'Reward Notifications',
      description: 'Notifications when you earn tokens',
      importance: 'high',
    },
    INVESTMENTS: {
      id: 'investment_updates',
      name: 'Investment Updates',
      description: 'Updates about your investment performance',
      importance: 'default',
    },
    APP_BLOCKING: {
      id: 'app_blocking',
      name: 'App Blocking',
      description: 'Notifications when apps are blocked or limits reached',
      importance: 'high',
    },
    GENERAL: {
      id: 'general_notifications',
      name: 'General',
      description: 'General app notifications',
      importance: 'default',
    },
  },
  
  // Time Constants (in milliseconds)
  TIME: {
    SECOND: 1000,
    MINUTE: 60 * 1000,
    HOUR: 60 * 60 * 1000,
    DAY: 24 * 60 * 60 * 1000,
    WEEK: 7 * 24 * 60 * 60 * 1000,
    MONTH: 30 * 24 * 60 * 60 * 1000,
    YEAR: 365 * 24 * 60 * 60 * 1000,
  },
  
  // App Limits and Quotas
  LIMITS: {
    MAX_BLOCKED_APPS: 20,
    MAX_DAILY_LIMIT_HOURS: 12,
    MIN_DAILY_LIMIT_MINUTES: 5,
    MAX_TRANSACTIONS_HISTORY: 1000,
    MAX_INVESTMENT_HISTORY: 100,
  },
  
  // Validation Rules
  VALIDATION: {
    MIN_AGE: 13,
    MAX_AGE: 120,
    MIN_SAVINGS_GOAL: 1000,
    MAX_SAVINGS_GOAL: 10000000,
    MIN_PASSWORD_LENGTH: 6,
    MAX_DISPLAY_NAME_LENGTH: 50,
    MAX_PHONE_NUMBER_LENGTH: 15,
  },
  
  // Storage Keys for AsyncStorage
  STORAGE_KEYS: {
    USER_PREFERENCES: '@foom_user_preferences',
    SCREEN_TIME_DATA: '@foom_screen_time',
    BLOCKED_APPS: '@foom_blocked_apps',
    ONBOARDING_COMPLETE: '@foom_onboarding_complete',
    LAST_SYNC: '@foom_last_sync',
    APP_VERSION: '@foom_app_version',
  },
  
  // API Endpoints (for future M-Pesa integration)
  API: {
    MPESA_SANDBOX: 'https://sandbox.safaricom.co.ke',
    MPESA_PRODUCTION: 'https://api.safaricom.co.ke',
    TIMEOUT: 30000, // 30 seconds
    RETRY_ATTEMPTS: 3,
  },
  
  // Screen Time Categories
  SCREEN_TIME_CATEGORIES: {
    SOCIAL_MEDIA: 'Social Media',
    ENTERTAINMENT: 'Entertainment',
    PRODUCTIVITY: 'Productivity',
    COMMUNICATION: 'Communication',
    GAMES: 'Games',
    NEWS: 'News & Reading',
    SHOPPING: 'Shopping',
    FINANCE: 'Finance',
    HEALTH: 'Health & Fitness',
    EDUCATION: 'Education',
    UTILITIES: 'Utilities',
    OTHER: 'Other',
  },
  
  // Theme Colors
  COLORS: {
    PRIMARY: '#6200EE',
    SECONDARY: '#03DAC6',
    SUCCESS: '#4CAF50',
    WARNING: '#FF9800',
    ERROR: '#FF5722',
    INFO: '#2196F3',
    TOKEN: '#FFD700',
    INVESTMENT: '#9C27B0',
    SCREEN_TIME: '#FF5722',
    
    // Gradients
    PRIMARY_GRADIENT: ['#6200EE', '#3700B3'],
    SUCCESS_GRADIENT: ['#4CAF50', '#2E7D32'],
    WARNING_GRADIENT: ['#FF9800', '#F57C00'],
  },
  
  // Default Settings
  DEFAULT_SETTINGS: {
    NOTIFICATIONS_ENABLED: true,
    SCREEN_TIME_ALERTS: true,
    WEEKLY_REPORTS: true,
    INVESTMENT_UPDATES: true,
    DARK_MODE: false,
    LANGUAGE: 'en',
    CURRENCY: 'KES',
    TIME_FORMAT: '24h',
  },
  
  // Feature Flags
  FEATURES: {
    BIOMETRIC_AUTH: false,
    SOCIAL_FEATURES: false,
    ADVANCED_ANALYTICS: false,
    PUSH_NOTIFICATIONS: true,
    INVESTMENT_GOALS: true,
    APP_BLOCKING: true,
    USAGE_STATS: true,
  },
  
  // Error Messages
  ERRORS: {
    NETWORK: 'Network connection error. Please check your internet connection.',
    AUTH: 'Authentication failed. Please try again.',
    VALIDATION: 'Please check your input and try again.',
    PERMISSION: 'Permission required. Please grant the necessary permissions.',
    UNKNOWN: 'An unexpected error occurred. Please try again.',
    INSUFFICIENT_TOKENS: 'Insufficient tokens for this transaction.',
    INVESTMENT_FAILED: 'Investment failed. Please try again later.',
    SYNC_FAILED: 'Failed to sync data. Please try again.',
  },
  
  // Success Messages
  SUCCESS: {
    PROFILE_UPDATED: 'Profile updated successfully!',
    INVESTMENT_CREATED: 'Investment created successfully!',
    APP_BLOCKED: 'App blocked successfully!',
    TOKENS_EARNED: 'Tokens earned for reducing screen time!',
    WITHDRAWAL_COMPLETED: 'Withdrawal completed successfully!',
    SETTINGS_SAVED: 'Settings saved successfully!',
  },
};

// Export individual constants for convenience
export const {
  APP_NAME,
  APP_VERSION,
  TOKENS_PER_HOUR_SAVED,
  DAILY_SCREEN_TIME_GOAL_HOURS,
  TOKENS_PER_KES,
  MMF_OPTIONS,
  POPULAR_APPS,
  NOTIFICATION_CHANNELS,
  COLLECTIONS,
  TIME,
  COLORS,
  DEFAULT_SETTINGS,
} = CONSTANTS;