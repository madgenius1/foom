/**
 * Format milliseconds to human-readable time string
 */
export const formatTime = (milliseconds: number): string => {
  const hours = Math.floor(milliseconds / (1000 * 60 * 60));
  const minutes = Math.floor((milliseconds % (1000 * 60 * 60)) / (1000 * 60));
  
  if (hours > 0) {
    return `${hours}h ${minutes}m`;
  }
  return `${minutes}m`;
};

/**
 * Format currency in Kenyan Shillings
 */
export const formatCurrency = (amount: number, currency: string = 'KES'): string => {
  return `${currency} ${amount.toLocaleString('en-KE', {
    minimumFractionDigits: 0,
    maximumFractionDigits: 2,
  })}`;
};

/**
 * Format date to readable string
 */
export const formatDate = (timestamp: number): string => {
  return new Date(timestamp).toLocaleDateString('en-KE', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  });
};

/**
 * Format date and time
 */
export const formatDateTime = (timestamp: number): string => {
  return new Date(timestamp).toLocaleString('en-KE', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });
};

/**
 * Calculate percentage
 */
export const calculatePercentage = (value: number, total: number): number => {
  if (total === 0) return 0;
  return Math.round((value / total) * 100);
};

/**
 * Generate a random ID
 */
export const generateId = (): string => {
  return Date.now().toString(36) + Math.random().toString(36).substr(2);
};

/**
 * Validate email format
 */
export const isValidEmail = (email: string): boolean => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

/**
 * Validate phone number (Kenyan format)
 */
export const isValidPhoneNumber = (phone: string): boolean => {
  // Kenyan phone numbers: +254XXXXXXXXX or 07XXXXXXXX or 01XXXXXXXX
  const phoneRegex = /^(\+254|0)[17]\d{8}$/;
  return phoneRegex.test(phone.replace(/\s/g, ''));
};

/**
 * Format phone number to Kenyan format
 */
export const formatPhoneNumber = (phone: string): string => {
  const cleaned = phone.replace(/\s/g, '');
  
  if (cleaned.startsWith('0')) {
    return '+254' + cleaned.substring(1);
  }
  
  if (cleaned.startsWith('254')) {
    return '+' + cleaned;
  }
  
  if (cleaned.startsWith('+254')) {
    return cleaned;
  }
  
  return phone;
};

/**
 * Get time ago string
 */
export const getTimeAgo = (timestamp: number): string => {
  const now = Date.now();
  const diff = now - timestamp;
  
  const minute = 60 * 1000;
  const hour = minute * 60;
  const day = hour * 24;
  const week = day * 7;
  const month = day * 30;
  const year = day * 365;
  
  if (diff < minute) {
    return 'Just now';
  } else if (diff < hour) {
    const minutes = Math.floor(diff / minute);
    return `${minutes} minute${minutes > 1 ? 's' : ''} ago`;
  } else if (diff < day) {
    const hours = Math.floor(diff / hour);
    return `${hours} hour${hours > 1 ? 's' : ''} ago`;
  } else if (diff < week) {
    const days = Math.floor(diff / day);
    return `${days} day${days > 1 ? 's' : ''} ago`;
  } else if (diff < month) {
    const weeks = Math.floor(diff / week);
    return `${weeks} week${weeks > 1 ? 's' : ''} ago`;
  } else if (diff < year) {
    const months = Math.floor(diff / month);
    return `${months} month${months > 1 ? 's' : ''} ago`;
  } else {
    const years = Math.floor(diff / year);
    return `${years} year${years > 1 ? 's' : ''} ago`;
  }
};

/**
 * Debounce function
 */
export const debounce = <T extends (...args: any[]) => any>(
  func: T,
  wait: number
): ((...args: Parameters<T>) => void) => {
  let timeout: NodeJS.Timeout;
  
  return (...args: Parameters<T>) => {
    clearTimeout(timeout);
    timeout = setTimeout(() => func.apply(null, args), wait);
  };
};

/**
 * Calculate MMF returns (mock calculation)
 */
export const calculateMMFReturns = (
  principal: number,
  rate: number,
  days: number
): number => {
  const dailyRate = rate / 365 / 100;
  return principal * Math.pow(1 + dailyRate, days);
};

/**
 * Get MMF options
 */
export const getMMFOptions = () => [
  {
    id: 'cic_mmf',
    name: 'CIC Money Market Fund',
    rate: 8.5,
    minInvestment: 1000,
    riskLevel: 'Low',
  },
  {
    id: 'equity_mmf',
    name: 'Equity Money Market Fund',
    rate: 9.2,
    minInvestment: 1000,
    riskLevel: 'Low',
  },
  {
    id: 'ncba_mmf',
    name: 'NCBA Money Market Fund',
    rate: 8.8,
    minInvestment: 500,
    riskLevel: 'Low',
  },
  {
    id: 'cytonn_mmf',
    name: 'Cytonn Money Market Fund',
    rate: 10.1,
    minInvestment: 1000,
    riskLevel: 'Medium',
  },
];

/**
 * Convert tokens to KES (mock conversion)
 */
export const tokensToKES = (tokens: number): number => {
  return tokens * 0.1; // 10 tokens = 1 KES
};

/**
 * Convert KES to tokens
 */
export const kesTokens = (kes: number): number => {
  return kes * 10; // 1 KES = 10 tokens
};

/**
 * Validate investment amount
 */
export const validateInvestmentAmount = (
  amount: number,
  tokenBalance: number,
  minInvestment: number
): string | null => {
  const kesAmount = tokensToKES(amount);
  
  if (amount <= 0) {
    return 'Investment amount must be greater than 0';
  }
  
  if (amount > tokenBalance) {
    return 'Insufficient token balance';
  }
  
  if (kesAmount < minInvestment) {
    return `Minimum investment is KES ${minInvestment}`;
  }
  
  return null;
};

/**
 * Generate mock transaction reference
 */
export const generateTransactionRef = (): string => {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let result = 'FOOM';
  
  for (let i = 0; i < 8; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  
  return result;
};