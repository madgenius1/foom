import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class AchievementsWidget extends StatelessWidget {
  const AchievementsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final achievements = [
      {
        'title': 'First Block',
        'description': 'Blocked your first app',
        'icon': Icons.block_outlined,
        'earned': true,
      },
      {
        'title': '7-Day Streak',
        'description': 'Maintained streak for a week',
        'icon': Icons.local_fire_department_outlined,
        'earned': true,
      },
      {
        'title': '\$50 Saved',
        'description': 'Saved your first \$50',
        'icon': Icons.savings_outlined,
        'earned': false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Achievements',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Total Saved: \$147.65',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: achievements.map((achievement) {
                final isEarned = achievement['earned'] as bool;

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: isEarned
                              ? colorScheme.secondary.withValues(alpha: 0.1)
                              : colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          achievement['icon'] as IconData,
                          color: isEarned
                              ? colorScheme.secondary
                              : colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              achievement['title'] as String,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: isEarned
                                    ? colorScheme.onSurface
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              achievement['description'] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isEarned)
                        Icon(
                          Icons.check_circle,
                          color: colorScheme.secondary,
                          size: 20,
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
