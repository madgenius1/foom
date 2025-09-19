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
} from 'react-native-paper';
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';
import { useNavigation } from '@react-navigation/native';
import { useAuth } from '../auth/AuthContext';
import { isValidEmail } from '../utils/helpers';

const RegisterScreen: React.FC = () => {
  const navigation = useNavigation();
  const { signUp } = useAuth();
  
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    confirmPassword: '',
    displayName: '',
  });
  const [loading, setLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [snackbarVisible, setSnackbarVisible] = useState(false);

  const handleRegister = async () => {
    if (!formData.email || !formData.password || !formData.displayName) {
      setError('Please fill in all fields');
      setSnackbarVisible(true);
      return;
    }

    if (!isValidEmail(formData.email)) {
      setError('Please enter a valid email address');
      setSnackbarVisible(true);
      return;
    }

    if (formData.password !== formData.confirmPassword) {
      setError('Passwords do not match');
      setSnackbarVisible(true);
      return;
    }

    if (formData.password.length < 6) {
      setError('Password must be at least 6 characters');
      setSnackbarVisible(true);
      return;
    }

    setLoading(true);
    setError('');

    try {
      await signUp(formData.email, formData.password, formData.displayName);
    } catch (error: any) {
      console.error('Register error:', error);
      
      let errorMessage = 'Registration failed. Please try again.';
      
      if (error.code === 'auth/email-already-in-use') {
        errorMessage = 'This email is already registered';
      } else if (error.code === 'auth/weak-password') {
        errorMessage = 'Password is too weak';
      } else if (error.code === 'auth/invalid-email') {
        errorMessage = 'Invalid email address';
      }
      
      setError(errorMessage);
      setSnackbarVisible(true);
    } finally {
      setLoading(false);
    }
  };

  const navigateToLogin = () => {
    navigation.navigate('Login' as never);
  };

  return (
    <KeyboardAvoidingView
      style={styles.container}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <ScrollView contentContainerStyle={styles.scrollContainer}>
        <View style={styles.header}>
          <Icon name="account-plus" size={80} color="#6200EE" />
          <Title style={styles.title}>Join FOOM</Title>
          <Paragraph style={styles.subtitle}>
            Start your digital wellness journey
          </Paragraph>
        </View>

        <Card style={styles.card}>
          <Card.Content>
            <Title style={styles.cardTitle}>Create Account</Title>
            
            <TextInput
              label="Full Name"
              value={formData.displayName}
              onChangeText={(text) => setFormData({...formData, displayName: text})}
              mode="outlined"
              left={<TextInput.Icon icon="account" />}
              style={styles.input}
              disabled={loading}
            />

            <TextInput
              label="Email"
              value={formData.email}
              onChangeText={(text) => setFormData({...formData, email: text})}
              mode="outlined"
              keyboardType="email-address"
              autoCapitalize="none"
              left={<TextInput.Icon icon="email" />}
              style={styles.input}
              disabled={loading}
            />

            <TextInput
              label="Password"
              value={formData.password}
              onChangeText={(text) => setFormData({...formData, password: text})}
              mode="outlined"
              secureTextEntry={!showPassword}
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

            <TextInput
              label="Confirm Password"
              value={formData.confirmPassword}
              onChangeText={(text) => setFormData({...formData, confirmPassword: text})}
              mode="outlined"
              secureTextEntry={!showPassword}
              left={<TextInput.Icon icon="lock-check" />}
              style={styles.input}
              disabled={loading}
            />

            <Button
              mode="contained"
              onPress={handleRegister}
              style={styles.registerButton}
              disabled={loading}
              loading={loading}
            >
              {loading ? 'Creating Account...' : 'Create Account'}
            </Button>

            <View style={styles.loginContainer}>
              <Text style={styles.loginText}>Already have an account? </Text>
              <Button
                mode="text"
                onPress={navigateToLogin}
                disabled={loading}
                compact
              >
                Sign In
              </Button>
            </View>
          </Card.Content>
        </Card>
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
  registerButton: {
    marginTop: 16,
    paddingVertical: 8,
  },
  loginContainer: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: 16,
  },
  loginText: {
    fontSize: 14,
    color: '#666',
  },
});

export default RegisterScreen;