import React, { useEffect, useState } from 'react';
import {
  View,
  ScrollView,
  StyleSheet,
  RefreshControl,
} from 'react-native';
import {
  Card,
  Title,
  Paragraph,
  Button,
  Text,
  ProgressBar,
  Chip,
  Surface,
} from 'react-native-paper';
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';
import { useAuth } from '../auth/AuthContext';
import { useScreenTimeStore } from '../store/screenTimeStore';
import { useWalletStore } from '../store/walletStore';
import { screenTimeService } from '../services/screenTime';
import { formatTime, formatCurrency } from '../utils/helpers';

const DashboardScreen: React.FC = () => {
  const { userProfile } = useAuth();
  const {
    getTodayScreenTime,
    getWeeklyScreenTime,
    updateCurrentUsage,
  } = useScreenTimeStore();
  const {
    tokenBalance,
    getTotalPortfolioValue,
    getRecentTransactions,
  } = useWalletStore();
  
  const [refreshing, setRefreshing] = useState(false);
  const [todayScreenTime, setTodayScreenTime] = useState(0);
  const [weeklyAverage, setWeeklyAverage] = useState(0);

  const loadScreenTimeData = async () => {
    try {
      const usage = await screenTimeService.getTodayUsage();
      updateCurrentUsage(usage);
      
      const todayData = getTodayScreenTime();
      const weeklyData = getWeeklyScreenTime();
      
      if (todayData) {
        setTodayScreenTime(todayData.totalTime);
      }
      
      if (weeklyData.length > 0) {
        const avgTime = weeklyData.reduce((sum, day) => sum + day.totalTime, 0) / weeklyData.length;
        setWeeklyAverage(avgTime);
      }
    } catch (error) {
      console.error('Error loading screen time data:', error);
    }
  };

  useEffect(() => {
    loadScreenTimeData();
  }, []);

  const onRefresh = async () => {
    setRefreshing(true);
    await loadScreenTimeData();
    setRefreshing(false);
  };

  const todayScreenTimeHours = todayScreenTime / (1000 * 60 * 60);
  const weeklyAverageHours = weeklyAverage / (1000 * 60 * 60);
  const tokensEarnedToday = Math.max(0, (8 - todayScreenTimeHours) * 10); // 10 tokens per hour under 8 hours
  const portfolioValue = getTotalPortfolioValue();
  const recentTransactions = getRecentTransactions(3);

  return (
    <ScrollView
      style={styles.container}
      refreshControl={
        <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
      }
    >
      <View style={styles.header}>
        <Title style={styles.welcomeText}>
          Welcome back, {userProfile?.displayName || 'User'}!
        </Title>
        <Paragraph style={styles.subtitle}>
          Let's see how you're doing today
        </Paragraph>
      </View>

      {/* Token Balance Card */}
      <Card style={styles.card}>
        <Card.Content>
          <View style={styles.cardHeader}>
            <Icon name="coin" size={24} color="#FFD700" />
            <Title style={styles.cardTitle}>FOOM Tokens</Title>
          </View>
          <Text style={styles.balanceText}>{tokenBalance}</Text>
          <Paragraph>Available for investment</Paragraph>
        </Card.Content>
      </Card>

      {/* Screen Time Card */}
      <Card style={styles.card}>
        <Card.Content>
          <View style={styles.cardHeader}>
            <Icon name="cellphone-cog" size={24} color="#6200EE" />
            <Title style={styles.cardTitle}>Today's Screen Time</Title>
          </View>
          <Text style={styles.screenTimeText}>
            {formatTime(todayScreenTime)}
          </Text>
          <View style={styles.progressContainer}>
            <ProgressBar 
              progress={Math.min(todayScreenTimeHours / 8, 1)} 
              color={todayScreenTimeHours > 8 ? '#FF5722' : '#4CAF50'}
              style={styles.progressBar}
            />
            <Text style={styles.progressText}>
              Goal: Under 8 hours daily
            </Text>
          </View>
          <View style={styles.chipContainer}>
            <Chip 
              icon="trending-down" 
              textStyle={{ color: weeklyAverageHours > todayScreenTimeHours ? '#4CAF50' : '#FF5722' }}
            >
              {weeklyAverageHours > todayScreenTimeHours ? 'Improving' : 'Needs work'}
            </Chip>
          </View>
        </Card.Content>
      </Card>

      {/* Earnings Card */}
      <Card style={styles.card}>
        <Card.Content>
          <View style={styles.cardHeader}>
            <Icon name="cash-multiple" size={24} color="#4CAF50" />
            <Title style={styles.cardTitle}>Today's Rewards</Title>
          </View>
          <Text style={styles.earningsText}>
            +{Math.round(tokensEarnedToday)} tokens
          </Text>
          <Paragraph>
            Earned by staying under your screen time goal
          </Paragraph>
        </Card.Content>
      </Card>

      {/* Portfolio Summary */}
      <Card style={styles.card}>
        <Card.Content>
          <View style={styles.cardHeader}>
            <Icon name="chart-line" size={24} color="#FF9800" />
            <Title style={styles.cardTitle}>Portfolio Value</Title>
          </View>
          <Text style={styles.portfolioText}>
            {formatCurrency(portfolioValue)}
          </Text>
          <Paragraph>Total investments and savings</Paragraph>
          <Button 
            mode="outlined" 
            onPress={() => {/* Navigate to invest */}}
            style={styles.actionButton}
          >
            Invest Tokens
          </Button>
        </Card.Content>
      </Card>

      {/* Recent Activity */}
      {recentTransactions.length > 0 && (
        <Card style={styles.card}>
          <Card.Content>
            <View style={styles.cardHeader}>
              <Icon name="history" size={24} color="#9C27B0" />
              <Title style={styles.cardTitle}>Recent Activity</Title>
            </View>
            {recentTransactions.map((transaction) => (
              <Surface key={transaction.id} style={styles.transactionItem}>
                <View style={styles.transactionContent}>
                  <Icon 
                    name={
                      transaction.type === 'earned' ? 'plus-circle' : 
                      transaction.type === 'invested' ? 'trending-up' : 'minus-circle'
                    } 
                    size={20} 
                    color={transaction.amount > 0 ? '#4CAF50' : '#FF5722'} 
                  />
                  <View style={styles.transactionDetails}>
                    <Text style={styles.transactionDescription}>
                      {transaction.description}
                    </Text>
                    <Text style={styles.transactionDate}>
                      {new Date(transaction.timestamp).toLocaleDateString()}
                    </Text>
                  </View>
                  <Text style={[
                    styles.transactionAmount,
                    { color: transaction.amount > 0 ? '#4CAF50' : '#FF5722' }
                  ]}>
                    {transaction.amount > 0 ? '+' : ''}{transaction.amount}
                  </Text>
                </View>
              </Surface>
            ))}
          </Card.Content>
        </Card>
      )}

      {/* Quick Actions */}
      <Card style={[styles.card, styles.lastCard]}>
        <Card.Content>
          <Title style={styles.cardTitle}>Quick Actions</Title>
          <View style={styles.actionButtons}>
            <Button 
              mode="contained" 
              icon="cellphone-cog"
              onPress={() => {/* Navigate to app management */}}
              style={styles.quickActionButton}
            >
              Manage Apps
            </Button>
            <Button 
              mode="contained" 
              icon="chart-line"
              onPress={() => {/* Navigate to investments */}}
              style={styles.quickActionButton}
            >
              View Investments
            </Button>
          </View>
        </Card.Content>
      </Card>
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
  welcomeText: {
    fontSize: 24,
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
  cardHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  cardTitle: {
    marginLeft: 8,
    fontSize: 18,
  },
  balanceText: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#6200EE',
    marginVertical: 8,
  },
  screenTimeText: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#FF5722',
    marginVertical: 8,
  },
  progressContainer: {
    marginTop: 12,
  },
  progressBar: {
    height: 8,
    borderRadius: 4,
  },
  progressText: {
    fontSize: 12,
    color: '#666',
    marginTop: 4,
  },
  chipContainer: {
    marginTop: 12,
  },
  earningsText: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#4CAF50',
    marginVertical: 8,
  },
  portfolioText: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#FF9800',
    marginVertical: 8,
  },
  actionButton: {
    marginTop: 12,
  },
  transactionItem: {
    padding: 12,
    marginVertical: 4,
    borderRadius: 8,
  },
  transactionContent: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  transactionDetails: {
    flex: 1,
    marginLeft: 12,
  },
  transactionDescription: {
    fontSize: 14,
    fontWeight: '500',
  },
  transactionDate: {
    fontSize: 12,
    color: '#666',
    marginTop: 2,
  },
  transactionAmount: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  actionButtons: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 12,
  },
  quickActionButton: {
    flex: 0.48,
  },
});

export default DashboardScreen;