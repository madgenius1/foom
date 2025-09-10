import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class FeaturedAppsWidget extends StatelessWidget {
  const FeaturedAppsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final featuredApps = [
      {'name': 'Instagram', 'status': 'Blocked', 'icon': Icons.camera_alt},
      {'name': 'TikTok', 'status': 'Active', 'icon': Icons.music_note},
      {'name': 'Twitter', 'status': 'Blocked', 'icon': Icons.alternate_email},
      {
        'name': 'YouTube',
        'status': 'Active',
        'icon': Icons.play_circle_outline
      },
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Featured Apps',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 100.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: featuredApps.length,
                separatorBuilder: (context, index) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final app = featuredApps[index];
                  final isBlocked = app['status'] == 'Blocked';

                  return Container(
                    width: 80.w,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: isBlocked
                          ? colorScheme.tertiary.withValues(alpha: 0.1)
                          : colorScheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isBlocked
                            ? colorScheme.tertiary.withValues(alpha: 0.3)
                            : colorScheme.secondary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          app['icon'] as IconData,
                          size: 32,
                          color: isBlocked
                              ? colorScheme.tertiary
                              : colorScheme.secondary,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          app['name'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          app['status'] as String,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isBlocked
                                ? colorScheme.tertiary
                                : colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
