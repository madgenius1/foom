import React, { useState } from 'react';
import {
  View,
  ScrollView,
  StyleSheet,
  Alert,
} from 'react-native';
import {
  Card,
  Title,
  Paragraph,
  Text,
  List,
  Switch,
  Button,
  Dialog,
  Portal,
  TextInput,
  Snackbar,
  Divider,
} from 'react-native-paper';
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';
import { useAuth } from '../auth/AuthContext';
import { useAuthStore } from '../store/authStore';
import { useScreenTimeStore } from '../store/screenTimeStore';
import { useWalletStore } from '../store/walletStore';
import { formatCurrency } from '../utils/helpers';
import { CONSTANTS } from '../utils/constants';

const SettingsScreen: React.FC = () => {
  const { user, userProfile, signOut, updateUserProfile } = useAuth();
  const { clearAuthUser } = useAuthStore();
  const { resetDailyData } = useScreenTimeStore();
  const { tokenBalance, getTotalPortfolioValue } = useWalletStore();
  
  const [notifications, setNotifications] = useState(true);
  const [screenTimeAlerts, setScreenTimeAlerts] = useState(true);
  const [weeklyReports, setWeeklyReports] = useState(true);
  const [investmentUpdates, setInvestmentUpdates] = useState(true);
  
  const [showProfileDialog, setShowProfileDialog] = useState(false);
  const [showDeleteDialog, setShowDeleteDialog] = useState(false);
  const [profileData, setProfileData] = useState({
    displayName: userProfile?.displayName || '',
    phoneNumber: userProfile?.phoneNumber || '',
    savingsGoal: userProfile?.savingsGoal?.toString() || '',
  });
  
  const [loading, setLoading] = useState(false);
  const [snackbarVisible, setSnackbarVisible] = useState(false);
  const [snackbarMessage, setSnackbarMessage] = useState('');

  const portfolioValue = getTotalPortfolioValue();

  const handleSignOut = () => {
    Alert.alert(
      'Sign Out',
      'Are you sure you want to sign out?',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Sign Out',
          style: 'destructive',
          onPress: async () => {
            try {
              await signOut();
            } catch (error) {
              console.error('Sign out error:', error);
            }
          }
        }
      ]
    );
  };

  const handleUpdateProfile = async () => {
    setLoading(true);
    
    try {
      await updateUserProfile({
        displayName: profileData.displayName,
        phoneNumber: profileData.phoneNumber,
        savingsGoal: parseInt(profileData.savingsGoal) || undefined,
      });
      
      setSnackbarMessage('Profile updated successfully');
      setSnackbarVisible(true);
      setShowProfileDialog(false);
    } catch (error) {
      console.error('Profile update error:', error);
      setSnackbarMessage('Failed to update profile');
      setSnackbarVisible(true);
    } finally {
      setLoading(false);
    }
  };

  const handleDeleteAccount = () => {
    Alert.alert(
      'Delete Account',
      'This will permanently delete your account and all data. This action cannot be undone.',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Delete',
          style: 'destructive',
          onPress: () => {
            // In a real app, this would call a delete account API
            Alert.alert('Account Deletion', 'This feature will be available in a future update.');
          }
        }
      ]
    );
  };

  const handleResetData = () => {
    Alert.alert(
      'Reset App Data',
      'This will clear all screen time data and blocked app settings. Your investments and tokens will remain safe.',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Reset',
          style: 'destructive',
          onPress: () => {
            resetDailyData();
            setSnackbarMessage('App data reset successfully');
            setSnackbarVisible(true);
          }
        }
      ]
    );
  };

  const handleExportData = () => {
    Alert.alert(
      'Export Data',
      'Export your FOOM data including screen time, transactions, and investments.',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Export',
          onPress: () => {
            // In a real app, this would generate and share a data export
            setSnackbarMessage('Data export feature coming soon');
            setSnackbarVisible(true);
          }
        }
      ]
    );
  };

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Title style={styles.title}>Settings</Title>
        <Paragraph style={styles.subtitle}>
          Manage your account and preferences
        </Paragraph>
      </View>

      {/* Profile Section */}
      <Card style={styles.card}>
        <Card.Content>
          <View style={styles.profileHeader}>
            <Icon name="account-circle" size={48} color="#6200EE" />
            <View style={styles.profileInfo}>
              <Text style={styles.profileName}>
                {userProfile?.displayName || 'User'}
              </Text>
              <Text style={styles.profileEmail}>{user?.email}</Text>
              <Text style={styles.profileStats}>
                {tokenBalance} tokens • {formatCurrency(portfolioValue)} portfolio
              </Text>
            </View>
          </View>
          
          <Button
            mode="outlined"
            onPress={() => {
              setProfileData({
                displayName: userProfile?.displayName || '',
                phoneNumber: userProfile?.phoneNumber || '',
                savingsGoal: userProfile?.savingsGoal?.toString() || '',
              });
              setShowProfileDialog(true);
            }}
            style={styles.editButton}
          >
            Edit Profile
          </Button>
        </Card.Content>
      </Card>

      {/* Notifications */}
      <Card style={styles.card}>
        <Card.Content>
          <Title style={styles.cardTitle}>Notifications</Title>
          
          <List.Item
            title="Push Notifications"
            description="Receive app notifications"
            left={(props) => <Icon {...props} name="bell" />}
            right={() => (
              <Switch
                value={notifications}
                onValueChange={setNotifications}
              />
            )}
          />
          
          <List.Item
            title="Screen Time Alerts"
            description="Alerts when approaching daily limit"
            left={(props) => <Icon {...props} name="clock-alert" />}
            right={() => (
              <Switch
                value={screenTimeAlerts}
                onValueChange={setScreenTimeAlerts}
                disabled={!notifications}
              />
            )}
          />
          
          <List.Item
            title="Weekly Reports"
            description="Weekly screen time and progress reports"
            left={(props) => <Icon {...props} name="chart-timeline" />}
            right={() => (
              <Switch
                value={weeklyReports}
                onValueChange={setWeeklyReports}
                disabled={!notifications}
              />
            )}
          />
          
          <List.Item
            title="Investment Updates"
            description="Notifications about your investments"
            left={(props) => <Icon {...props} name="trending-up" />}
            right={() => (
              <Switch
                value={investmentUpdates}
                onValueChange={setInvestmentUpdates}
                disabled={!notifications}
              />
            )}
          />
        </Card.Content>
      </Card>

      {/* Privacy & Security */}
      <Card style={styles.card}>
        <Card.Content>
          <Title style={styles.cardTitle}>Privacy & Security</Title>
          
          <List.Item
            title="Change Password"
            description="Update your account password"
            left={(props) => <Icon {...props} name="lock" />}
            right={(props) => <Icon {...props} name="chevron-right" />}
            onPress={() => {
              Alert.alert(
                'Change Password',
                'You will be redirected to change your password',
                [{ text: 'OK' }]
              );
            }}
          />
          
          <List.Item
            title="Two-Factor Authentication"
            description="Add extra security to your account"
            left={(props) => <Icon {...props} name="security" />}
            right={(props) => <Icon {...props} name="chevron-right" />}
            onPress={() => {
              Alert.alert(
                '2FA Setup',
                'Two-factor authentication will be available in a future update',
                [{ text: 'OK' }]
              );
            }}
          />
          
          <List.Item
            title="Privacy Policy"
            description="Read our privacy policy"
            left={(props) => <Icon {...props} name="shield-check" />}
            right={(props) => <Icon {...props} name="chevron-right" />}
            onPress={() => {
              Alert.alert(
                'Privacy Policy',
                'Privacy policy will be available in the app settings',
                [{ text: 'OK' }]
              );
            }}
          />
        </Card.Content>
      </Card>

      {/* Data Management */}
      <Card style={styles.card}>
        <Card.Content>
          <Title style={styles.cardTitle}>Data Management</Title>
          
          <List.Item
            title="Export Data"
            description="Download your FOOM data"
            left={(props) => <Icon {...props} name="download" />}
            right={(props) => <Icon {...props} name="chevron-right" />}
            onPress={handleExportData}
          />
          
          <List.Item
            title="Reset App Data"
            description="Clear screen time and app settings"
            left={(props) => <Icon {...props} name="refresh" />}
            right={(props) => <Icon {...props} name="chevron-right" />}
            onPress={handleResetData}
          />
          
          <Divider style={styles.divider} />
          
          <List.Item
            title="Delete Account"
            description="Permanently delete your account"
            left={(props) => <Icon {...props} name="delete" color="#FF5722" />}
            right={(props) => <Icon {...props} name="chevron-right" />}
            onPress={handleDeleteAccount}
            titleStyle={{ color: '#FF5722' }}
          />
        </Card.Content>
      </Card>

      {/* App Information */}
      <Card style={styles.card}>
        <Card.Content>
          <Title style={styles.cardTitle}>About FOOM</Title>
          
          <List.Item
            title="App Version"
            description={CONSTANTS.APP_VERSION}
            left={(props) => <Icon {...props} name="information" />}
          />
          
          <List.Item
            title="Terms of Service"
            description="Read our terms of service"
            left={(props) => <Icon {...props} name="file-document" />}
            right={(props) => <Icon {...props} name="chevron-right" />}
            onPress={() => {
              Alert.alert(
                'Terms of Service',
                'Terms of service will be available in the app',
                [{ text: 'OK' }]
              );
            }}
          />
          
          <List.Item
            title="Contact Support"
            description="Get help with FOOM"
            left={(props) => <Icon {...props} name="help-circle" />}
            right={(props) => <Icon {...props} name="chevron-right" />}
            onPress={() => {
              Alert.alert(
                'Contact Support',
                'Email us at support@foom.app for assistance',
                [{ text: 'OK' }]
              );
            }}
          />
          
          <List.Item
            title="Rate FOOM"
            description="Rate us on the Play Store"
            left={(props) => <Icon {...props} name="star" />}
            right={(props) => <Icon {...props} name="chevron-right" />}
            onPress={() => {
              Alert.alert(
                'Rate FOOM',
                'Thank you for using FOOM! Please rate us on the Play Store.',
                [{ text: 'OK' }]
              );
            }}
          />
        </Card.Content>
      </Card>

      {/* Sign Out */}
      <Card style={[styles.card, styles.lastCard]}>
        <Card.Content>
          <Button
            mode="contained"
            onPress={handleSignOut}
            style={[styles.signOutButton, { backgroundColor: '#FF5722' }]}
            labelStyle={{ color: '#FFFFFF' }}
            icon="logout"
          >
            Sign Out
          </Button>
        </Card.Content>
      </Card>

      {/* Profile Edit Dialog */}
      <Portal>
        <Dialog visible={showProfileDialog} onDismiss={() => setShowProfileDialog(false)}>
          <Dialog.Title>Edit Profile</Dialog.Title>
          <Dialog.Content>
            <TextInput
              label="Display Name"
              value={profileData.displayName}
              onChangeText={(text) => setProfileData({...profileData, displayName: text})}
              mode="outlined"
              style={styles.dialogInput}
            />
            
            <TextInput
              label="Phone Number"
              value={profileData.phoneNumber}
              onChangeText={(text) => setProfileData({...profileData, phoneNumber: text})}
              keyboardType="phone-pad"
              mode="outlined"
              style={styles.dialogInput}
            />
            
            <TextInput
              label="Savings Goal (KES)"
              value={profileData.savingsGoal}
              onChangeText={(text) => setProfileData({...profileData, savingsGoal: text})}
              keyboardType="numeric"
              mode="outlined"
              style={styles.dialogInput}
            />
          </Dialog.Content>
          <Dialog.Actions>
            <Button onPress={() => setShowProfileDialog(false)}>Cancel</Button>
            <Button mode="contained" onPress={handleUpdateProfile} loading={loading}>
              Save
            </Button>
          </Dialog.Actions>
        </Dialog>
      </Portal>

      <Snackbar
        visible={snackbarVisible}
        onDismiss={() => setSnackbarVisible(false)}
        duration={3000}
        action={{
          label: 'Dismiss',
          onPress: () => setSnackbarVisible(false),
        }}
      >
        {snackbarMessage}
      </Snackbar>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  header: {
    padding: 20,
    paddingTop: 40,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#333',
  },
  subtitle: {
    fontSize: 16,
    color: '#666',
    marginTop: 4,
  },
  card: {
    marginHorizontal: 16,
    marginBottom: 16,
    elevation: 4,
  },
  lastCard: {
    marginBottom: 32,
  },
  cardTitle: {
    fontSize: 18,
    marginBottom: 8,
  },
  profileHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 16,
  },
  profileInfo: {
    marginLeft: 16,
    flex: 1,
  },
  profileName: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#333',
  },
  profileEmail: {
    fontSize: 14,
    color: '#666',
    marginTop: 4,
  },
  profileStats: {
    fontSize: 12,
    color: '#6200EE',
    marginTop: 4,
  },
  editButton: {
    alignSelf: 'flex-start',
  },
  divider: {
    marginVertical: 8,
  },
  signOutButton: {
    marginTop: 8,
  },
  dialogInput: {
    marginBottom: 16,
  },
});

export default SettingsScreen;