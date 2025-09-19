import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { PaperProvider } from 'react-native-paper';
import { StatusBar } from 'react-native';
import { AuthProvider } from './src/auth/AuthContext';
import AppNavigator from './src/navigation/AppNavigator';
import { theme } from './src/utils/theme';

const App: React.FC = () => {
    return (
        <PaperProvider theme={theme}>
            <AuthProvider>
                <NavigationContainer>
                    <StatusBar barStyle="dark-content" backgroundColor={theme.colors.surface} />
                    <AppNavigator />
                </NavigationContainer>
            </AuthProvider>
        </PaperProvider>
    );
};

export default App;