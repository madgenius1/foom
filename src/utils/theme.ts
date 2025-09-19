import { MD3LightTheme } from 'react-native-paper';

export const theme = {
  ...MD3LightTheme,
  colors: {
    ...MD3LightTheme.colors,
    primary: '#6200EE',
    secondary: '#03DAC6',
    background: '#F5F5F5',
    surface: '#FFFFFF',
    error: '#B00020',
    onPrimary: '#FFFFFF',
    onSecondary: '#000000',
    onBackground: '#000000',
    onSurface: '#000000',
    onError: '#FFFFFF',
    // Custom colors for FOOM
    success: '#4CAF50',
    warning: '#FF9800',
    info: '#2196F3',
    token: '#FFD700',
    screenTime: '#FF5722',
    investment: '#9C27B0',
  },
  roundness: 8,
  fonts: {
    ...MD3LightTheme.fonts,
    default: {
      fontFamily: 'System',
    },
  },
};