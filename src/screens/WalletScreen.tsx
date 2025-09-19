import React, { useState, useEffect } from 'react';
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
    Text,
    List,
    Divider,
    Chip,
    Surface,
    Button,
} from 'react-native-paper';
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';
import { useWalletStore } from '../store/walletStore';
import { formatCurrency, formatDateTime, getTimeAgo } from '../utils/helpers';

const WalletScreen: React.FC = () => {
    const {
        tokenBalance,
        totalEarned,
        totalInvested,
        transactions,
        investments,
        getRecentTransactions,
        getTotalPortfolioValue,
    } = useWalletStore();

    const [refreshing, setRefreshing] = useState(false);
    const [showAllTransactions, setShowAllTransactions] = useState(false);

    const recentTransactions = getRecentTransactions(showAllTransactions ? 50 : 10);
    const portfolioValue = getTotalPortfolioValue();

    const onRefresh = async () => {
        setRefreshing(true);
        // In a real app, sync with Firebase here
        setTimeout(() => setRefreshing(false), 1000);
    };

    const getTransactionIcon = (type: string) => {
        switch (type) {
            case 'earned':
                return 'plus-circle';
            case 'invested':
                return 'trending-up';
            case 'withdrawn':
                return 'minus-circle';
            default:
                return 'circle';
        }
    };

    const getTransactionColor = (amount: number) => {
        return amount > 0 ? '#4CAF50' : '#FF5722';
    };

    return (
        <ScrollView
            style={styles.container}
            refreshControl={
                <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
            }
        >
            <View style={styles.header}>
                <Title style={styles.headerTitle}>My Wallet</Title>
                <Paragraph style={styles.subtitle}>
                    Track your tokens and investments
                </Paragraph>
            </View>

            {/* Token Balance Card */}
            <Card style={styles.balanceCard}>
                <Card.Content>
                    <View style={styles.balanceHeader}>
                        <Icon name="wallet" size={32} color="#6200EE" />
                        <Text style={styles.balanceLabel}>Available Balance</Text>
                    </View>
                    <Text style={styles.balanceAmount}>{tokenBalance}</Text>
                    <Text style={styles.balanceSubtext}>FOOM Tokens</Text>

                    <View style={styles.statsRow}>
                        <View style={styles.statItem}>
                            <Text style={styles.statValue}>{totalEarned}</Text>
                            <Text style={styles.statLabel}>Total Earned</Text>
                        </View>
                        <View style={styles.statItem}>
                            <Text style={styles.statValue}>{formatCurrency(totalInvested)}</Text>
                            <Text style={styles.statLabel}>Total Invested</Text>
                        </View>
                    </View>
                </Card.Content>
            </Card>

            {/* Portfolio Summary */}
            {investments.length > 0 && (
                <Card style={styles.card}>
                    <Card.Content>
                        <View style={styles.cardHeader}>
                            <Icon name="chart-line" size={24} color="#FF9800" />
                            <Title style={styles.cardTitle}>Portfolio Summary</Title>
                        </View>
                        <Text style={styles.portfolioValue}>
                            {formatCurrency(portfolioValue)}
                        </Text>
                        <Paragraph>Current portfolio value</Paragraph>

                        <View style={styles.investmentsList}>
                            {investments.slice(0, 3).map((investment) => (
                                <View key={investment.id} style={styles.investmentItem}>
                                    <View style={styles.investmentInfo}>
                                        <Text style={styles.investmentName}>{investment.mmfName}</Text>
                                        <Text style={styles.investmentAmount}>
                                            {formatCurrency(investment.currentValue)}
                                        </Text>
                                    </View>
                                    <Chip
                                        textStyle={{
                                            color: investment.returnRate >= 0 ? '#4CAF50' : '#FF5722',
                                            fontSize: 12,
                                        }}
                                    >
                                        {investment.returnRate >= 0 ? '+' : ''}{investment.returnRate.toFixed(1)}%
                                    </Chip>
                                </View>
                            ))}
                        </View>
                    </Card.Content>
                </Card>
            )}

            {/* Recent Transactions */}
            <Card style={styles.card}>
                <Card.Content>
                    <View style={styles.cardHeader}>
                        <Icon name="history" size={24} color="#9C27B0" />
                        <Title style={styles.cardTitle}>Recent Transactions</Title>
                    </View>

                    {recentTransactions.length === 0 ? (
                        <View style={styles.emptyState}>
                            <Icon name="inbox-outline" size={64} color="#E0E0E0" />
                            <Text style={styles.emptyStateText}>No transactions yet</Text>
                            <Paragraph style={styles.emptyStateSubtext}>
                                Start earning tokens by reducing your screen time!
                            </Paragraph>
                        </View>
                    ) : (
                        <>
                            {recentTransactions.map((transaction, index) => (
                                <View key={transaction.id}>
                                    <View style={styles.transactionItem}>
                                        <View style={styles.transactionIcon}>
                                            <Icon
                                                name={getTransactionIcon(transaction.type)}
                                                size={20}
                                                color={getTransactionColor(transaction.amount)}
                                            />
                                        </View>
                                        <View style={styles.transactionDetails}>
                                            <Text style={styles.transactionDescription}>
                                                {transaction.description}
                                            </Text>
                                            <Text style={styles.transactionDate}>
                                                {getTimeAgo(transaction.timestamp)}
                                            </Text>
                                            {transaction.relatedScreenTime && (
                                                <Text style={styles.screenTimeInfo}>
                                                    {Math.round(transaction.relatedScreenTime)} min saved
                                                </Text>
                                            )}
                                        </View>
                                        <View style={styles.transactionAmount}>
                                            <Text
                                                style={[
                                                    styles.amountText,
                                                    { color: getTransactionColor(transaction.amount) },
                                                ]}
                                            >
                                                {transaction.amount > 0 ? '+' : ''}{transaction.amount}
                                            </Text>
                                            <Text style={styles.amountSubtext}>tokens</Text>
                                        </View>
                                    </View>
                                    {index < recentTransactions.length - 1 && <Divider />}
                                </View>
                            ))}

                            {!showAllTransactions && transactions.length > 10 && (
                                <Button
                                    mode="text"
                                    onPress={() => setShowAllTransactions(true)}
                                    style={styles.showMoreButton}
                                >
                                    Show All Transactions
                                </Button>
                            )}
                        </>
                    )}
                </Card.Content>
            </Card>

            {/* Quick Actions */}
            <Card style={[styles.card, styles.lastCard]}>
                <Card.Content>
                    <Title style={styles.cardTitle}>Quick Actions</Title>
                    <View style={styles.actionButtons}>
                        <Button
                            mode="contained"
                            icon="trending-up"
                            onPress={() => {/* Navigate to invest */ }}
                            style={styles.actionButton}
                        >
                            Invest Tokens
                        </Button>
                        <Button
                            mode="outlined"
                            icon="chart-box"
                            onPress={() => {/* Navigate to portfolio */ }}
                            style={styles.actionButton}
                        >
                            View Portfolio
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
    headerTitle: {
        fontSize: 28,
        fontWeight: 'bold',
        color: '#333',
    },
    subtitle: {
        fontSize: 16,
        color: '#666',
        marginTop: 4,
    },
    balanceCard: {
        marginHorizontal: 16,
        marginBottom: 16,
        elevation: 8,
        backgroundColor: '#6200EE',
    },
    balanceHeader: {
        flexDirection: 'row',
        alignItems: 'center',
        marginBottom: 16,
    },
    balanceLabel: {
        fontSize: 16,
        color: '#FFFFFF',
        marginLeft: 12,
    },
    balanceAmount: {
        fontSize: 40,
        fontWeight: 'bold',
        color: '#FFFFFF',
        marginBottom: 4,
    },
    balanceSubtext: {
        fontSize: 16,
        color: '#E1BEE7',
        marginBottom: 24,
    },
    statsRow: {
        flexDirection: 'row',
        justifyContent: 'space-around',
    },
    statItem: {
        alignItems: 'center',
    },
    statValue: {
        fontSize: 20,
        fontWeight: 'bold',
        color: '#FFFFFF',
    },
    statLabel: {
        fontSize: 12,
        color: '#E1BEE7',
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
        marginBottom: 16,
    },
    cardTitle: {
        marginLeft: 8,
        fontSize: 18,
    },
    portfolioValue: {
        fontSize: 28,
        fontWeight: 'bold',
        color: '#FF9800',
        marginBottom: 8,
    },
    investmentsList: {
        marginTop: 16,
    },
    investmentItem: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingVertical: 8,
    },
    investmentInfo: {
        flex: 1,
    },
    investmentName: {
        fontSize: 14,
        fontWeight: '500',
    },
    investmentAmount: {
        fontSize: 12,
        color: '#666',
        marginTop: 2,
    },
    emptyState: {
        alignItems: 'center',
        paddingVertical: 32,
    },
    emptyStateText: {
        fontSize: 18,
        fontWeight: '500',
        color: '#666',
        marginTop: 16,
    },
    emptyStateSubtext: {
        textAlign: 'center',
        color: '#999',
        marginTop: 8,
    },
    transactionItem: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingVertical: 12,
    },
    transactionIcon: {
        width: 40,
        height: 40,
        borderRadius: 20,
        backgroundColor: '#F5F5F5',
        justifyContent: 'center',
        alignItems: 'center',
        marginRight: 12,
    },
    transactionDetails: {
        flex: 1,
    },
    transactionDescription: {
        fontSize: 14,
        fontWeight: '500',
        color: '#333',
    },
    transactionDate: {
        fontSize: 12,
        color: '#666',
        marginTop: 2,
    },
    screenTimeInfo: {
        fontSize: 11,
        color: '#4CAF50',
        marginTop: 2,
        fontStyle: 'italic',
    },
    transactionAmount: {
        alignItems: 'flex-end',
    },
    amountText: {
        fontSize: 16,
        fontWeight: 'bold',
    },
    amountSubtext: {
        fontSize: 11,
        color: '#666',
        marginTop: 2,
    },
    showMoreButton: {
        marginTop: 8,
    },
    actionButtons: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        marginTop: 16,
    },
    actionButton: {
        flex: 0.48,
    },
});

export default WalletScreen;