import React from 'react';
import { createStackNavigator } from '@react-navigation/stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';
import { useAuth } from '../auth/AuthContext';
import { useAuthStore } from '../store/authStore';

// Screens
import SplashScreen from '../screens/SplashScreen';
import OnboardingScreen from '../screens/OnboardingScreen';
import LoginScreen from '../screens/LoginScreen';
import RegisterScreen from '../screens/RegisterScreen';
import ProfileSetupScreen from '../screens/ProfileSetupScreen';
import DashboardScreen from '../screens/DashboardScreen';
import WalletScreen from '../screens/WalletScreen';
import AppManagementScreen from '../screens/AppManagementScreen';
import InvestScreen from '../screens/InvestScreen';
import SettingsScreen from '../screens/SettingsScreen';

import { RootStackParamList, MainTabParamList } from './types';

const Stack = createStackNavigator<RootStackParamList>();
const Tab = createBottomTabNavigator<MainTabParamList>();

const MainTabNavigator = () => {
    return (
        <Tab.Navigator
            screenOptions={({ route }) => ({
                tabBarIcon: ({ focused, color, size }) => {
                    let iconName: string;

                    switch (route.name) {
                        case 'Dashboard':
                            iconName = focused ? 'view-dashboard' : 'view-dashboard-outline';
                            break;
                        case 'Wallet':
                            iconName = focused ? 'wallet' : 'wallet-outline';
                            break;
                        case 'Apps':
                            iconName = focused ? 'cellphone-cog' : 'cellphone-settings';
                            break;
                        case 'Invest':
                            iconName = focused ? 'trending-up' : 'chart-line';
                            break;
                        case 'Settings':
                            iconName = focused ? 'cog' : 'cog-outline';
                            break;
                        default:
                            iconName = 'circle';
                    }

                    return <Icon name={iconName} size={size} color={color} />;
                },
                tabBarActiveTintColor: '#6200EE',
                tabBarInactiveTintColor: 'gray',
                headerShown: false,
            })}
        >
            <Tab.Screen name="Dashboard" component={DashboardScreen} />
            <Tab.Screen name="Wallet" component={WalletScreen} />
            <Tab.Screen name="Apps" component={AppManagementScreen} />
            <Tab.Screen name="Invest" component={InvestScreen} />
            <Tab.Screen name="Settings" component={SettingsScreen} />
        </Tab.Navigator>
    );
};

const AppNavigator: React.FC = () => {
    const { loading, user, userProfile } = useAuth();
    const { hasCompletedOnboarding } = useAuthStore();

    if (loading) {
        return <SplashScreen />;
    }

    return (
        <Stack.Navigator screenOptions={{ headerShown: false }}>
            {!user ? (
                // Auth Stack
                <>
                    {!hasCompletedOnboarding && (
                        <Stack.Screen name="Onboarding" component={OnboardingScreen} />
                    )}
                    <Stack.Screen name="Login" component={LoginScreen} />
                    <Stack.Screen name="Register" component={RegisterScreen} />
                </>
            ) : userProfile && !userProfile.profileComplete ? (
                // Profile Setup
                <Stack.Screen name="ProfileSetup" component={ProfileSetupScreen} />
            ) : (
                // Main App
                <Stack.Screen name="Main" component={MainTabNavigator} />
            )}
        </Stack.Navigator>
    );
};

export default AppNavigator;