import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class QuickInvestmentActionsWidget extends StatelessWidget {
  const QuickInvestmentActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final actions = [
      {
        'title': 'Invest Now',
        'description': 'Add to portfolio',
        'icon': Icons.add_circle_outline,
        'color': colorScheme.secondary,
        'onTap': () => _handleInvestment(context),
      },
      {
        'title': 'Withdraw',
        'description': 'Access your funds',
        'icon': Icons.remove_circle_outline,
        'color': colorScheme.tertiary,
        'onTap': () => _handleWithdrawal(context),
      },
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: actions.map((action) {
                final isLast = action == actions.last;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: isLast ? 0 : 8.w),
                    child: InkWell(
                      onTap: action['onTap'] as VoidCallback,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: (action['color'] as Color)
                              .withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: (action['color'] as Color)
                                .withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              action['icon'] as IconData,
                              color: action['color'] as Color,
                              size: 32,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              action['title'] as String,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: action['color'] as Color,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              action['description'] as String,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _handleInvestment(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Investment flow coming soon'),
      ),
    );
  }

  void _handleWithdrawal(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Withdrawal flow coming soon'),
      ),
    );
  }
}
