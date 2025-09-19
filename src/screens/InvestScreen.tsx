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
  Button,
  TextInput,
  List,
  Chip,
  Dialog,
  Portal,
  RadioButton,
  Snackbar,
  ProgressBar,
} from 'react-native-paper';
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';
import { useWalletStore, Investment } from '../store/walletStore';
import { 
  getMMFOptions, 
  formatCurrency, 
  tokensToKES, 
  validateInvestmentAmount,
  generateTransactionRef,
  calculateMMFReturns 
} from '../utils/helpers';
import { CONSTANTS } from '../utils/constants';

const InvestScreen: React.FC = () => {
  const {
    tokenBalance,
    investments,
    investTokens,
    withdrawInvestment,
    updateInvestmentValue,
    getTotalPortfolioValue,
  } = useWalletStore();

  const [refreshing, setRefreshing] = useState(false);
  const [showInvestDialog, setShowInvestDialog] = useState(false);
  const [showWithdrawDialog, setShowWithdrawDialog] = useState(false);
  const [selectedMMF, setSelectedMMF] = useState('');
  const [investAmount, setInvestAmount] = useState('');
  const [selectedInvestment, setSelectedInvestment] = useState<Investment | null>(null);
  const [loading, setLoading] = useState(false);
  const [snackbarVisible, setSnackbarVisible] = useState(false);
  const [snackbarMessage, setSnackbarMessage] = useState('');

  const mmfOptions = getMMFOptions();
  const totalPortfolioValue = getTotalPortfolioValue();

  useEffect(() => {
    // Simulate real-time investment value updates
    const interval = setInterval(() => {
      investments.forEach(investment => {
        const daysSinceInvestment = Math.floor((Date.now() - investment.investedAt) / (24 * 60 * 60 * 1000));
        const mmf = mmfOptions.find(option => option.id === investment.mmfName.toLowerCase().replace(/\s+/g, '_'));
        
        if (mmf && daysSinceInvestment > 0) {
          const newValue = calculateMMFReturns(investment.amount, mmf.rate, daysSinceInvestment);
          const returnRate = ((newValue - investment.amount) / investment.amount) * 100;
          
          updateInvestmentValue(investment.id, newValue, returnRate);
        }
      });
    }, 30000); // Update every 30 seconds

    return () => clearInterval(interval);
  }, [investments]);

  const onRefresh = async () => {
    setRefreshing(true);
    // Simulate fetching updated investment data
    await new Promise(resolve => setTimeout(resolve, 1000));
    setRefreshing(false);
  };

  const handleInvest = () => {
    if (!selectedMMF) {
      setSnackbarMessage('Please select a Money Market Fund');
      setSnackbarVisible(true);
      return;
    }

    const tokens = parseInt(investAmount);
    if (isNaN(tokens) || tokens <= 0) {
      setSnackbarMessage('Please enter a valid token amount');
      setSnackbarVisible(true);
      return;
    }

    const mmf = mmfOptions.find(option => option.id === selectedMMF);
    if (!mmf) return;

    const kesAmount = tokensToKES(tokens);
    const validationError = validateInvestmentAmount(tokens, tokenBalance, mmf.minInvestment);
    
    if (validationError) {
      setSnackbarMessage(validationError);
      setSnackbarVisible(true);
      return;
    }

    Alert.alert(
      'Confirm Investment',
      `Invest ${tokens} tokens (${formatCurrency(kesAmount)}) in ${mmf.name}?`,
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Invest',
          onPress: async () => {
            setLoading(true);
            try {
              investTokens(mmf.name, tokens, kesAmount);
              setSnackbarMessage(`Successfully invested in ${mmf.name}!`);
              setSnackbarVisible(true);
              setShowInvestDialog(false);
              setInvestAmount('');
              setSelectedMMF('');
            } catch (error) {
              setSnackbarMessage('Investment failed. Please try again.');
              setSnackbarVisible(true);
            } finally {
              setLoading(false);
            }
          }
        }
      ]
    );
  };

  const handleWithdraw = () => {
    if (!selectedInvestment) return;

    Alert.alert(
      'Confirm Withdrawal',
      `Withdraw from ${selectedInvestment.mmfName}?\n\nCurrent value: ${formatCurrency(selectedInvestment.currentValue)}\nReturn: ${selectedInvestment.returnRate >= 0 ? '+' : ''}${selectedInvestment.returnRate.toFixed(2)}%`,
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Withdraw',
          onPress: async () => {
            setLoading(true);
            try {
              withdrawInvestment(selectedInvestment.id);
              setSnackbarMessage(`Successfully withdrew from ${selectedInvestment.mmfName}!`);
              setSnackbarVisible(true);
              setShowWithdrawDialog(false);
              setSelectedInvestment(null);
            } catch (error) {
              setSnackbarMessage('Withdrawal failed. Please try again.');
              setSnackbarVisible(true);
            } finally {
              setLoading(false);
            }
          }
        }
      ]
    );
  };

  const getReturnColor = (returnRate: number): string => {
    if (returnRate > 0) return '#4CAF50';
    if (returnRate < 0) return '#FF5722';
    return '#666';
  };

  const calculatePortfolioAllocation = () => {
    return investments.map(investment => ({
      ...investment,
      percentage: totalPortfolioValue > 0 ? (investment.currentValue / totalPortfolioValue) * 100 : 0
    }));
  };

  const portfolioAllocation = calculatePortfolioAllocation();
  const totalGainLoss = investments.reduce((total, inv) => total + (inv.currentValue - inv.amount), 0);
  const totalReturnRate = investments.length > 0 
    ? investments.reduce((sum, inv) => sum + inv.returnRate, 0) / investments.length 
    : 0;

  return (
    <ScrollView
      style={styles.container}
      refreshControl={
        <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
      }
    >
      <View style={styles.header}>
        <Title style={styles.title}>Investments</Title>
        <Paragraph style={styles.subtitle}>
          Grow your tokens through Money Market Funds
        </Paragraph>
      </View>

      {/* Portfolio Summary */}
      <Card style={styles.card}>
        <Card.Content>
          <View style={styles.portfolioHeader}>
            <Icon name="chart-line" size={32} color="#4CAF50" />
            <View style={styles.portfolioInfo}>
              <Text style={styles.portfolioValue}>{formatCurrency(totalPortfolioValue)}</Text>
              <Text style={styles.portfolioLabel}>Portfolio Value</Text>
            </View>
          </View>
          
          <View style={styles.summaryRow}>
            <View style={styles.summaryItem}>
              <Text style={[styles.summaryValue, { color: getReturnColor(totalGainLoss) }]}>
                {totalGainLoss >= 0 ? '+' : ''}{formatCurrency(totalGainLoss)}
              </Text>
              <Text style={styles.summaryLabel}>Total Gain/Loss</Text>
            </View>
            
            <View style={styles.summaryItem}>
              <Text style={[styles.summaryValue, { color: getReturnColor(totalReturnRate) }]}>
                {totalReturnRate >= 0 ? '+' : ''}{totalReturnRate.toFixed(2)}%
              </Text>
              <Text style={styles.summaryLabel}>Avg. Return</Text>
            </View>
            
            <View style={styles.summaryItem}>
              <Text style={styles.summaryValue}>{investments.length}</Text>
              <Text style={styles.summaryLabel}>Investments</Text>
            </View>
          </View>
        </Card.Content>
      </Card>

      {/* Available Tokens */}
      <Card style={styles.card}>
        <Card.Content>
          <View style={styles.tokensHeader}>
            <Icon name="coin" size={24} color="#FFD700" />
            <Title style={styles.cardTitle}>Available Tokens</Title>
          </View>
          
          <Text style={styles.tokenBalance}>{tokenBalance}</Text>
          <Text style={styles.tokenValue}>≈ {formatCurrency(tokensToKES(tokenBalance))}</Text>
          
          <Button
            mode="contained"
            icon="trending-up"
            onPress={() => setShowInvestDialog(true)}
            style={styles.investButton}
            disabled={tokenBalance < 100} // Minimum 100 tokens to invest
          >
            Invest Tokens
          </Button>
        </Card.Content>
      </Card>

      {/* Current Investments */}
      {investments.length > 0 && (
        <Card style={styles.card}>
          <Card.Content>
            <Title style={styles.cardTitle}>Your Investments</Title>
            
            {portfolioAllocation.map((investment) => (
              <Card key={investment.id} style={styles.investmentCard}>
                <Card.Content>
                  <View style={styles.investmentHeader}>
                    <View style={styles.investmentInfo}>
                      <Text style={styles.investmentName}>{investment.mmfName}</Text>
                      <Text style={styles.investmentDate}>
                        {new Date(investment.investedAt).toLocaleDateString()}
                      </Text>
                    </View>
                    
                    <View style={styles.investmentValues}>
                      <Text style={styles.investmentValue}>
                        {formatCurrency(investment.currentValue)}
                      </Text>
                      <Chip
                        textStyle={{
                          color: getReturnColor(investment.returnRate),
                          fontSize: 12,
                        }}
                      >
                        {investment.returnRate >= 0 ? '+' : ''}{investment.returnRate.toFixed(2)}%
                      </Chip>
                    </View>
                  </View>
                  
                  <ProgressBar
                    progress={investment.percentage / 100}
                    color="#4CAF50"
                    style={styles.allocationBar}
                  />
                  
                  <View style={styles.investmentDetails}>
                    <Text style={styles.allocationText}>
                      {investment.percentage.toFixed(1)}% of portfolio
                    </Text>
                    <Text style={styles.originalAmount}>
                      Original: {formatCurrency(investment.amount)}
                    </Text>
                  </View>
                  
                  <Button
                    mode="outlined"
                    onPress={() => {
                      setSelectedInvestment(investment);
                      setShowWithdrawDialog(true);
                    }}
                    style={styles.withdrawButton}
                  >
                    Withdraw
                  </Button>
                </Card.Content>
              </Card>
            ))}
          </Card.Content>
        </Card>
      )}

      {/* MMF Options */}
      <Card style={styles.card}>
        <Card.Content>
          <Title style={styles.cardTitle}>Available Money Market Funds</Title>
          
          {mmfOptions.map((mmf) => (
            <List.Item
              key={mmf.id}
              title={mmf.name}
              description={
                <View style={styles.mmfDescription}>
                  <Text style={styles.mmfRate}>{mmf.rate}% annual return</Text>
                  <Text style={styles.mmfRisk}>{mmf.riskLevel} risk</Text>
                  <Text style={styles.mmfMin}>Min: {formatCurrency(mmf.minInvestment)}</Text>
                </View>
              }
              left={(props) => (
                <Icon {...props} name="trending-up" size={32} color="#4CAF50" />
              )}
              right={(props) => (
                <Button
                  mode="outlined"
                  compact
                  onPress={() => {
                    setSelectedMMF(mmf.id);
                    setShowInvestDialog(true);
                  }}
                >
                  Invest
                </Button>
              )}
              style={styles.mmfItem}
            />
          ))}
        </Card.Content>
      </Card>

      {/* Investment Tips */}
      <Card style={[styles.card, styles.lastCard]}>
        <Card.Content>
          <Title style={styles.cardTitle}>💡 Investment Tips</Title>
          
          <List.Item
            title="Diversify Your Portfolio"
            description="Don't put all tokens in one MMF"
            left={(props) => <Icon {...props} name="chart-pie" />}
          />
          
          <List.Item
            title="Long-term Growth"
            description="MMFs work best for long-term investments"
            left={(props) => <Icon {...props} name="calendar-clock" />}
          />
          
          <List.Item
            title="Earn More Tokens"
            description="Reduce screen time to earn investment tokens"
            left={(props) => <Icon {...props} name="cellphone-off" />}
          />
        </Card.Content>
      </Card>

      {/* Investment Dialog */}
      <Portal>
        <Dialog visible={showInvestDialog} onDismiss={() => setShowInvestDialog(false)}>
          <Dialog.Title>Invest Tokens</Dialog.Title>
          <Dialog.Content>
            <Paragraph>Choose MMF and token amount to invest</Paragraph>
            
            <Text style={styles.dialogLabel}>Money Market Fund:</Text>
            <RadioButton.Group
              onValueChange={setSelectedMMF}
              value={selectedMMF}
            >
              {mmfOptions.map((mmf) => (
                <View key={mmf.id} style={styles.radioOption}>
                  <RadioButton value={mmf.id} />
                  <View style={styles.radioInfo}>
                    <Text style={styles.radioTitle}>{mmf.name}</Text>
                    <Text style={styles.radioSubtitle}>{mmf.rate}% • {mmf.riskLevel}</Text>
                  </View>
                </View>
              ))}
            </RadioButton.Group>
            
            <TextInput
              label={`Token Amount (Available: ${tokenBalance})`}
              value={investAmount}
              onChangeText={setInvestAmount}
              keyboardType="numeric"
              mode="outlined"
              style={styles.dialogInput}
            />
            
            {investAmount && (
              <Text style={styles.conversionText}>
                ≈ {formatCurrency(tokensToKES(parseInt(investAmount) || 0))}
              </Text>
            )}
          </Dialog.Content>
          <Dialog.Actions>
            <Button onPress={() => setShowInvestDialog(false)}>Cancel</Button>
            <Button mode="contained" onPress={handleInvest} loading={loading}>
              Invest
            </Button>
          </Dialog.Actions>
        </Dialog>
      </Portal>

      {/* Withdrawal Dialog */}
      <Portal>
        <Dialog visible={showWithdrawDialog} onDismiss={() => setShowWithdrawDialog(false)}>
          <Dialog.Title>Withdraw Investment</Dialog.Title>
          <Dialog.Content>
            {selectedInvestment && (
              <View>
                <Paragraph>Withdraw from {selectedInvestment.mmfName}?</Paragraph>
                
                <View style={styles.withdrawalInfo}>
                  <Text style={styles.withdrawalLabel}>Original Investment:</Text>
                  <Text style={styles.withdrawalValue}>
                    {formatCurrency(selectedInvestment.amount)}
                  </Text>
                </View>
                
                <View style={styles.withdrawalInfo}>
                  <Text style={styles.withdrawalLabel}>Current Value:</Text>
                  <Text style={[
                    styles.withdrawalValue,
                    { color: getReturnColor(selectedInvestment.returnRate) }
                  ]}>
                    {formatCurrency(selectedInvestment.currentValue)}
                  </Text>
                </View>
                
                <View style={styles.withdrawalInfo}>
                  <Text style={styles.withdrawalLabel}>Return:</Text>
                  <Text style={[
                    styles.withdrawalValue,
                    { color: getReturnColor(selectedInvestment.returnRate) }
                  ]}>
                    {selectedInvestment.returnRate >= 0 ? '+' : ''}
                    {selectedInvestment.returnRate.toFixed(2)}%
                  </Text>
                </View>
              </View>
            )}
          </Dialog.Content>
          <Dialog.Actions>
            <Button onPress={() => setShowWithdrawDialog(false)}>Cancel</Button>
            <Button mode="contained" onPress={handleWithdraw} loading={loading}>
              Withdraw
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
}}