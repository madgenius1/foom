import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class RecentTransactionsWidget extends StatelessWidget {
  const RecentTransactionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final transactions = [
      {
        'type': 'deposit',
        'title': 'App Block Reward',
        'subtitle': 'From social media blocking',
        'amount': '+\$12.45',
        'time': '2 hours ago',
        'icon': Icons.block_outlined,
      },
      {
        'type': 'investment',
        'title': 'Money Market Fund',
        'subtitle': 'Auto-investment',
        'amount': '+\$25.00',
        'time': '1 day ago',
        'icon': Icons.trending_up,
      },
      {
        'type': 'deposit',
        'title': 'Shopping Block',
        'subtitle': 'From e-commerce app block',
        'amount': '+\$8.30',
        'time': '2 days ago',
        'icon': Icons.shopping_cart_outlined,
      },
      {
        'type': 'withdrawal',
        'title': 'Emergency Fund',
        'subtitle': 'Partial withdrawal',
        'amount': '-\$50.00',
        'time': '1 week ago',
        'icon': Icons.account_balance_wallet_outlined,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () => _showAllTransactions(context),
              child: Text(
                'See All',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Card(
          child: Column(
            children: transactions.take(3).map((transaction) {
              final isLast = transaction == transactions.take(3).last;
              return Column(
                children: [
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    leading: CircleAvatar(
                      backgroundColor: _getTransactionColor(
                              transaction['type'] as String, colorScheme)
                          .withValues(alpha: 0.1),
                      child: Icon(
                        transaction['icon'] as IconData,
                        color: _getTransactionColor(
                            transaction['type'] as String, colorScheme),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      transaction['title'] as String,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      transaction['subtitle'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          transaction['amount'] as String,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: (transaction['amount'] as String)
                                    .startsWith('+')
                                ? colorScheme.secondary
                                : colorScheme.error,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          transaction['time'] as String,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Color _getTransactionColor(String type, ColorScheme colorScheme) {
    switch (type) {
      case 'deposit':
        return colorScheme.secondary;
      case 'investment':
        return colorScheme.primary;
      case 'withdrawal':
        return colorScheme.error;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  void _showAllTransactions(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All transactions view coming soon'),
      ),
    );
  }
}
