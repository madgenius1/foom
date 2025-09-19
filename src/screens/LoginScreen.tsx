import React, { useState } from 'react';
import {
    View,
    StyleSheet,
    KeyboardAvoidingView,
    Platform,
    ScrollView,
} from 'react-native';
import {
    Text,
    TextInput,
    Button,
    Card,
    Title,
    Paragraph,
    Snackbar,
    ActivityIndicator,
} from 'react-native-paper';
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';
import { useNavigation } from '@react-navigation/native';
import { useAuth } from '../auth/AuthContext';
import { isValidEmail } from '../utils/helpers';

const LoginScreen: React.FC = () => {
    const navigation = useNavigation();
    const { signIn } = useAuth();

    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [loading, setLoading] = useState(false);
    const [showPassword, setShowPassword] = useState(false);
    const [error, setError] = useState('');
    const [snackbarVisible, setSnackbarVisible] = useState(false);

    const handleLogin = async () => {
        if (!email || !password) {
            setError('Please fill in all fields');
            setSnackbarVisible(true);
            return;
        }

        if (!isValidEmail(email)) {
            setError('Please enter a valid email address');
            setSnackbarVisible(true);
            return;
        }

        setLoading(true);
        setError('');

        try {
            await signIn(email, password);
            // Navigation will be handled by AuthContext
        } catch (error: any) {
            console.error('Login error:', error);

            let errorMessage = 'Login failed. Please try again.';

            if (error.code === 'auth/user-not-found') {
                errorMessage = 'No account found with this email';
            } else if (error.code === 'auth/wrong-password') {
                errorMessage = 'Invalid password';
            } else if (error.code === 'auth/invalid-email') {
                errorMessage = 'Invalid email address';
            } else if (error.code === 'auth/user-disabled') {
                errorMessage = 'This account has been disabled';
            } else if (error.code === 'auth/too-many-requests') {
                errorMessage = 'Too many failed attempts. Please try again later';
            }

            setError(errorMessage);
            setSnackbarVisible(true);
        } finally {
            setLoading(false);
        }
    };

    const navigateToRegister = () => {
        navigation.navigate('Register' as never);
    };

    return (
        <KeyboardAvoidingView
            style={styles.container}
            behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        >
            <ScrollView contentContainerStyle={styles.scrollContainer}>
                <View style={styles.header}>
                    <Icon name="account-circle" size={80} color="#6200EE" />
                    <Title style={styles.title}>Welcome to FOOM</Title>
                    <Paragraph style={styles.subtitle}>
                        Track your screen time and earn rewards
                    </Paragraph>
                </View>

                <Card style={styles.card}>
                    <Card.Content>
                        <Title style={styles.cardTitle}>Sign In</Title>

                        <TextInput
                            label="Email"
                            value={email}
                            onChangeText={setEmail}
                            mode="outlined"
                            keyboardType="email-address"
                            autoCapitalize="none"
                            autoComplete="email"
                            left={<TextInput.Icon icon="email" />}
                            style={styles.input}
                            disabled={loading}
                        />

                        <TextInput
                            label="Password"
                            value={password}
                            onChangeText={setPassword}
                            mode="outlined"
                            secureTextEntry={!showPassword}
                            autoComplete="password"
                            left={<TextInput.Icon icon="lock" />}
                            right={
                                <TextInput.Icon
                                    icon={showPassword ? 'eye-off' : 'eye'}
                                    onPress={() => setShowPassword(!showPassword)}
                                />
                            }
                            style={styles.input}
                            disabled={loading}
                        />

                        <Button
                            mode="contained"
                            onPress={handleLogin}
                            style={styles.loginButton}
                            disabled={loading}
                            loading={loading}
                        >
                            {loading ? 'Signing In...' : 'Sign In'}
                        </Button>

                        <View style={styles.registerContainer}>
                            <Text style={styles.registerText}>Don't have an account? </Text>
                            <Button
                                mode="text"
                                onPress={navigateToRegister}
                                disabled={loading}
                                compact
                            >
                                Sign Up
                            </Button>
                        </View>
                    </Card.Content>
                </Card>

                <View style={styles.footer}>
                    <Paragraph style={styles.footerText}>
                        By signing in, you agree to our Terms of Service and Privacy Policy
                    </Paragraph>
                </View>
            </ScrollView>

            <Snackbar
                visible={snackbarVisible}
                onDismiss={() => setSnackbarVisible(false)}
                duration={4000}
                action={{
                    label: 'Dismiss',
                    onPress: () => setSnackbarVisible(false),
                }}
            >
                {error}
            </Snackbar>
        </KeyboardAvoidingView>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#f5f5f5',
    },
    scrollContainer: {
        flexGrow: 1,
        justifyContent: 'center',
        padding: 20,
    },
    header: {
        alignItems: 'center',
        marginBottom: 32,
    },
    title: {
        fontSize: 28,
        fontWeight: 'bold',
        color: '#333',
        marginTop: 16,
    },
    subtitle: {
        fontSize: 16,
        color: '#666',
        textAlign: 'center',
        marginTop: 8,
    },
    card: {
        elevation: 8,
        borderRadius: 12,
    },
    cardTitle: {
        textAlign: 'center',
        marginBottom: 24,
        color: '#333',
    },
    input: {
        marginBottom: 16,
    },
    loginButton: {
        marginTop: 16,
        paddingVertical: 8,
    },
    registerContainer: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: 16,
    },
    registerText: {
        fontSize: 14,
        color: '#666',
    },
    footer: {
        marginTop: 32,
        paddingHorizontal: 16,
    },
    footerText: {
        fontSize: 12,
        color: '#999',
        textAlign: 'center',
        lineHeight: 18,
    },
});

export default LoginScreen;