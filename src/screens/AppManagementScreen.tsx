import React, { useState, useEffect } from 'react';
import {
  View,
  ScrollView,
  StyleSheet,
  Alert,
  RefreshControl,
} from 'react-native';
import {
  Card,
  Title,
  Paragraph,
  Text,
  List,
  Switch,
  Button,
  TextInput,
  Chip,
  Snackbar,
  Dialog,
  Portal,
} from 'react-native-paper';
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';
import { useScreenTimeStore, BlockedApp } from '../store/screenTimeStore';
import { screenTimeService } from '../services/screenTime';

interface AppWithUsage extends BlockedApp {
  todayUsage: number; // in minutes
  isOverLimit: boolean;
}

const AppManagementScreen: React.FC = () => {
  const {
    blockedApps,
    addBlockedApp,
    updateBlockedApp,
    removeBlockedApp,
    currentDayUsage,
  } = useScreenTimeStore();
  
  const [refreshing, setRefreshing] = useState(false);
  const [apps, setApps] = useState<AppWithUsage[]>([]);
  const [showAddDialog, setShowAddDialog] = useState(false);
  const [showLimitDialog, setShowLimitDialog] = useState(false);
  const [selectedApp, setSelectedApp] = useState<AppWithUsage | null>(null);
  const [newLimit, setNewLimit] = useState('');
  const [snackbarVisible, setSnackbarVisible] = useState(false);
  const [snackbarMessage, setSnackbarMessage] = useState('');

  // Popular apps that users commonly want to block
  const POPULAR_APPS = [
    {
      packageName: 'com.instagram.android',
      appName: 'Instagram',
      icon: 'instagram',
    },
    {
      packageName: 'com.facebook.katana',
      appName: 'Facebook',
      icon: 'facebook',
    },
    {
      packageName: 'com.twitter.android',
      appName: 'Twitter',
      icon: 'twitter',
    },
    {
      packageName: 'com.zhiliaoapp.musically',
      appName: 'TikTok',
      icon: 'music-note',
    },
    {
      packageName: 'com.google.android.youtube',
      appName: 'YouTube',
      icon: 'youtube',
    },
    {
      packageName: 'com.snapchat.android',
      appName: 'Snapchat',
      icon: 'snapchat',
    },
    {
      packageName: 'com.netflix.mediaclient',
      appName: 'Netflix',
      icon: 'netflix',
    },
  ];

  useEffect(() => {
    loadAppsData();
  }, [blockedApps, currentDayUsage]);

  const loadAppsData = () => {
    const appsWithUsage: AppWithUsage[] = POPULAR_APPS.map(app => {
      const blockedApp = blockedApps.find(blocked => blocked.packageName === app.packageName);
      const usage = currentDayUsage.find(usage => usage.packageName === app.packageName);
      const todayUsageMinutes = usage ? Math.round(usage.timeSpent / (1000 * 60)) : 0;
      
      return {
        packageName: app.packageName,
        appName: app.appName,
        isBlocked: blockedApp?.isBlocked || false,
        dailyLimit: blockedApp?.dailyLimit || undefined,
        todayUsage: todayUsageMinutes,
        isOverLimit: blockedApp?.dailyLimit ? todayUsageMinutes > blockedApp.dailyLimit : false,
      };
    });

    setApps(appsWithUsage);
  };

  const onRefresh = async () => {
    setRefreshing(true);
    try {
      // In a real app, this would refresh usage stats from the system
      await new Promise(resolve => setTimeout(resolve, 1000));
      loadAppsData();
    } finally {
      setRefreshing(false);
    }
  };

  const handleToggleBlock = async (app: AppWithUsage) => {
    try {
      if (app.isBlocked) {
        // Unblock app
        await screenTimeService.unblockApp(app.packageName);
        updateBlockedApp(app.packageName, { isBlocked: false });
        setSnackbarMessage(`${app.appName} unblocked`);
      } else {
        // Block app
        await screenTimeService.blockApp(app.packageName);
        const blockedApp: BlockedApp = {
          packageName: app.packageName,
          appName: app.appName,
          isBlocked: true,
          dailyLimit: app.dailyLimit,
        };
        addBlockedApp(blockedApp);
        setSnackbarMessage(`${app.appName} blocked`);
      }
      setSnackbarVisible(true);
    } catch (error) {
      console.error('Error toggling app block:', error);
      Alert.alert('Error', 'Failed to update app block status. Please try again.');
    }
  };

  const handleSetLimit = (app: AppWithUsage) => {
    setSelectedApp(app);
    setNewLimit(app.dailyLimit?.toString() || '');
    setShowLimitDialog(true);
  };

  const handleSaveLimit = () => {
    if (!selectedApp) return;

    const limit = parseInt(newLimit);
    if (isNaN(limit) || limit <= 0) {
      Alert.alert('Invalid Limit', 'Please enter a valid number of minutes');
      return;
    }

    const blockedApp: BlockedApp = {
      packageName: selectedApp.packageName,
      appName: selectedApp.appName,
      isBlocked: selectedApp.isBlocked,
      dailyLimit: limit,
    };

    addBlockedApp(blockedApp);
    setSnackbarMessage(`Daily limit set for ${selectedApp.appName}: ${limit} minutes`);
    setSnackbarVisible(true);
    setShowLimitDialog(false);
    setSelectedApp(null);
  };

  const handleRemoveLimit = (app: AppWithUsage) => {
    updateBlockedApp(app.packageName, { dailyLimit: undefined });
    setSnackbarMessage(`Daily limit removed for ${app.appName}`);
    setSnackbarVisible(true);
  };

  const getAppIcon = (packageName: string): string => {
    const app = POPULAR_APPS.find(app => app.packageName === packageName);
    return app?.icon || 'application';
  };

  const getUsageColor = (app: AppWithUsage): string => {
    if (app.isBlocked) return '#FF5722';
    if (app.isOverLimit) return '#FF9800';
    return '#4CAF50';
  };

  const totalBlockedApps = apps.filter(app => app.isBlocked).length;
  const totalAppsWithLimits = apps.filter(app => app.dailyLimit).length;
  const appsOverLimit = apps.filter(app => app.isOverLimit).length;

  return (
    <ScrollView
      style={styles.container}
      refreshControl={
        <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
      }
    >
      <View style={styles.header}>
        <Title style={styles.title}>App Management</Title>
        <Paragraph style={styles.subtitle}>
          Block distracting apps and set usage limits
        </Paragraph>
      </View>

      {/* Summary Cards */}
      <View style={styles.summaryRow}>
        <Card style={styles.summaryCard}>
          <Card.Content style={styles.summaryContent}>
            <Icon name="block-helper" size={24} color="#FF5722" />
            <Text style={styles.summaryNumber}>{totalBlockedApps}</Text>
            <Text style={styles.summaryLabel}>Blocked</Text>
          </Card.Content>
        </Card>
        
        <Card style={styles.summaryCard}>
          <Card.Content style={styles.summaryContent}>
            <Icon name="timer-outline" size={24} color="#FF9800" />
            <Text style={styles.summaryNumber}>{totalAppsWithLimits}</Text>
            <Text style={styles.summaryLabel}>With Limits</Text>
          </Card.Content>
        </Card>
        
        <Card style={styles.summaryCard}>
          <Card.Content style={styles.summaryContent}>
            <Icon name="alert-circle" size={24} color="#F44336" />
            <Text style={styles.summaryNumber}>{appsOverLimit}</Text>
            <Text style={styles.summaryLabel}>Over Limit</Text>
          </Card.Content>
        </Card>
      </View>

      {/* Apps List */}
      <Card style={styles.card}>
        <Card.Content>
          <Title style={styles.cardTitle}>Popular Apps</Title>
          
          {apps.map((app) => (
            <List.Item
              key={app.packageName}
              title={app.appName}
              description={
                <View style={styles.appDescription}>
                  <Text style={[styles.usageText, { color: getUsageColor(app) }]}>
                    Today: {app.todayUsage} min
                  </Text>
                  {app.dailyLimit && (
                    <Text style={styles.limitText}>
                      Limit: {app.dailyLimit} min
                    </Text>
                  )}
                  {app.isOverLimit && (
                    <Chip size="small" textStyle={styles.overLimitChip}>
                      Over Limit
                    </Chip>
                  )}
                </View>
              }
              left={(props) => (
                <Icon 
                  {...props} 
                  name={getAppIcon(app.packageName)} 
                  size={32} 
                  color={getUsageColor(app)}
                />
              )}
              right={() => (
                <View style={styles.appControls}>
                  <Switch
                    value={app.isBlocked}
                    onValueChange={() => handleToggleBlock(app)}
                    thumbColor={app.isBlocked ? '#FF5722' : '#4CAF50'}
                    trackColor={{ false: '#E0E0E0', true: '#FFCDD2' }}
                  />
                  <Button
                    mode="outlined"
                    compact
                    onPress={() => handleSetLimit(app)}
                    style={styles.limitButton}
                    labelStyle={styles.limitButtonLabel}
                  >
                    {app.dailyLimit ? 'Edit' : 'Limit'}
                  </Button>
                </View>
              )}
              style={[
                styles.appItem,
                app.isBlocked && styles.blockedAppItem,
                app.isOverLimit && styles.overLimitAppItem,
              ]}
            />
          ))}
        </Card.Content>
      </Card>

      {/* Quick Actions */}
      <Card style={styles.card}>
        <Card.Content>
          <Title style={styles.cardTitle}>Quick Actions</Title>
          
          <Button
            mode="contained"
            icon="block-helper"
            onPress={() => {
              Alert.alert(
                'Block All Social Media',
                'This will block Instagram, Facebook, Twitter, TikTok, and Snapchat',
                [
                  { text: 'Cancel', style: 'cancel' },
                  {
                    text: 'Block All',
                    style: 'destructive',
                    onPress: () => {
                      const socialApps = ['com.instagram.android', 'com.facebook.katana', 
                                        'com.twitter.android', 'com.zhiliaoapp.musically', 
                                        'com.snapchat.android'];
                      socialApps.forEach(packageName => {
                        const app = apps.find(a => a.packageName === packageName);
                        if (app && !app.isBlocked) {
                          handleToggleBlock(app);
                        }
                      });
                    }
                  }
                ]
              );
            }}
            style={styles.actionButton}
          >
            Block All Social Media
          </Button>
          
          <Button
            mode="outlined"
            icon="timer"
            onPress={() => {
              Alert.alert(
                'Set Default Limits',
                'Set 30 minutes daily limit for all entertainment apps?',
                [
                  { text: 'Cancel', style: 'cancel' },
                  {
                    text: 'Set Limits',
                    onPress: () => {
                      const entertainmentApps = ['com.instagram.android', 'com.zhiliaoapp.musically', 
                                               'com.google.android.youtube', 'com.netflix.mediaclient'];
                      entertainmentApps.forEach(packageName => {
                        const app = apps.find(a => a.packageName === packageName);
                        if (app) {
                          const blockedApp: BlockedApp = {
                            packageName: app.packageName,
                            appName: app.appName,
                            isBlocked: app.isBlocked,
                            dailyLimit: 30,
                          };
                          addBlockedApp(blockedApp);
                        }
                      });
                      setSnackbarMessage('30-minute limits set for entertainment apps');
                      setSnackbarVisible(true);
                    }
                  }
                ]
              );
            }}
            style={styles.actionButton}
          >
            Set Default Limits (30 min)
          </Button>
          
          <Button
            mode="text"
            icon="refresh"
            onPress={() => {
              Alert.alert(
                'Reset All Settings',
                'This will remove all blocks and limits. Are you sure?',
                [
                  { text: 'Cancel', style: 'cancel' },
                  {
                    text: 'Reset',
                    style: 'destructive',
                    onPress: () => {
                      apps.forEach(app => {
                        if (app.isBlocked || app.dailyLimit) {
                          removeBlockedApp(app.packageName);
                        }
                      });
                      setSnackbarMessage('All app restrictions removed');
                      setSnackbarVisible(true);
                    }
                  }
                ]
              );
            }}
            style={styles.actionButton}
          >
            Reset All Settings
          </Button>
        </Card.Content>
      </Card>

      {/* Permissions Info */}
      <Card style={[styles.card, styles.lastCard]}>
        <Card.Content>
          <Title style={styles.cardTitle}>Permissions Required</Title>
          <Paragraph style={styles.permissionText}>
            For app blocking to work, FOOM needs special permissions:
          </Paragraph>
          
          <List.Item
            title="Usage Access"
            description="Monitor app usage time"
            left={(props) => <Icon {...props} name="chart-timeline" />}
            right={(props) => (
              <Button
                mode="outlined"
                compact
                onPress={() => {
                  Alert.alert(
                    'Usage Access Permission',
                    'Go to Settings > Apps > Special Access > Usage Access and enable FOOM',
                    [{ text: 'OK' }]
                  );
                }}
              >
                Grant
              </Button>
            )}
          />
          
          <List.Item
            title="Display Over Other Apps"
            description="Show blocking overlay"
            left={(props) => <Icon {...props} name="layers" />}
            right={(props) => (
              <Button
                mode="outlined"
                compact
                onPress={() => {
                  Alert.alert(
                    'Display Over Other Apps',
                    'Go to Settings > Apps > FOOM > Advanced and enable "Display over other apps"',
                    [{ text: 'OK' }]
                  );
                }}
              >
                Grant
              </Button>
            )}
          />
          
          <List.Item
            title="Accessibility Service"
            description="Advanced app blocking"
            left={(props) => <Icon {...props} name="accessibility" />}
            right={(props) => (
              <Button
                mode="outlined"
                compact
                onPress={() => {
                  Alert.alert(
                    'Accessibility Service',
                    'Go to Settings > Accessibility > FOOM and enable the service',
                    [{ text: 'OK' }]
                  );
                }}
              >
                Grant
              </Button>
            )}
          />
        </Card.Content>
      </Card>

      {/* Limit Setting Dialog */}
      <Portal>
        <Dialog visible={showLimitDialog} onDismiss={() => setShowLimitDialog(false)}>
          <Dialog.Title>Set Daily Limit</Dialog.Title>
          <Dialog.Content>
            <Paragraph>
              Set a daily usage limit for {selectedApp?.appName}
            </Paragraph>
            <TextInput
              label="Daily limit (minutes)"
              value={newLimit}
              onChangeText={setNewLimit}
              keyboardType="numeric"
              mode="outlined"
              style={styles.dialogInput}
            />
            {selectedApp?.dailyLimit && (
              <Button
                mode="text"
                onPress={() => {
                  if (selectedApp) {
                    handleRemoveLimit(selectedApp);
                  }
                  setShowLimitDialog(false);
                }}
                style={styles.removeButton}
              >
                Remove Limit
              </Button>
            )}
          </Dialog.Content>
          <Dialog.Actions>
            <Button onPress={() => setShowLimitDialog(false)}>Cancel</Button>
            <Button mode="contained" onPress={handleSaveLimit}>
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
  summaryRow: {
    flexDirection: 'row',
    paddingHorizontal: 16,
    marginBottom: 16,
  },
  summaryCard: {
    flex: 1,
    marginHorizontal: 4,
    elevation: 2,
  },
  summaryContent: {
    alignItems: 'center',
    paddingVertical: 12,
  },
  summaryNumber: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#333',
    marginTop: 8,
  },
  summaryLabel: {
    fontSize: 12,
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
    marginBottom: 12,
  },
  appItem: {
    paddingVertical: 8,
    borderRadius: 8,
    marginBottom: 4,
  },
  blockedAppItem: {
    backgroundColor: '#FFEBEE',
  },
  overLimitAppItem: {
    backgroundColor: '#FFF3E0',
  },
  appDescription: {
    flexDirection: 'row',
    alignItems: 'center',
    flexWrap: 'wrap',
    marginTop: 4,
  },
  usageText: {
    fontSize: 12,
    fontWeight: '500',
    marginRight: 12,
  },
  limitText: {
    fontSize: 12,
    color: '#666',
    marginRight: 8,
  },
  overLimitChip: {
    color: '#FF5722',
    fontSize: 10,
  },
  appControls: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  limitButton: {
    marginLeft: 8,
    minWidth: 60,
  },
  limitButtonLabel: {
    fontSize: 12,
  },
  actionButton: {
    marginBottom: 12,
  },
  permissionText: {
    marginBottom: 16,
    color: '#666',
  },
  dialogInput: {
    marginTop: 16,
  },
  removeButton: {
    marginTop: 8,
  },
});

export default AppManagementScreen;