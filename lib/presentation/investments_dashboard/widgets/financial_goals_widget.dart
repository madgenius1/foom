import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class FinancialGoalsWidget extends StatelessWidget {
  const FinancialGoalsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final goals = [
      {
        'title': 'Emergency Fund',
        'target': 5000.0,
        'current': 2847.35,
        'color': colorScheme.secondary,
        'icon': Icons.security_outlined,
      },
      {
        'title': 'New Laptop',
        'target': 1200.0,
        'current': 680.50,
        'color': colorScheme.tertiary,
        'icon': Icons.laptop_mac_outlined,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Financial Goals',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        ...goals.map((goal) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor:
                                (goal['color'] as Color).withValues(alpha: 0.1),
                            child: Icon(
                              goal['icon'] as IconData,
                              color: goal['color'] as Color,
                              size: 18,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  goal['title'] as String,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  '\$${(goal['current'] as double).toStringAsFixed(2)} of \$${(goal['target'] as double).toStringAsFixed(0)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${((goal['current'] as double) / (goal['target'] as double) * 100).round()}%',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: goal['color'] as Color,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      LinearProgressIndicator(
                        value: (goal['current'] as double) /
                            (goal['target'] as double),
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            goal['color'] as Color),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
