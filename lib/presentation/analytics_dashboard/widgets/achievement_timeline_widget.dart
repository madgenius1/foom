import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementTimelineWidget extends StatelessWidget {
  final List<Map<String, dynamic>> achievements;

  const AchievementTimelineWidget({
    Key? key,
    required this.achievements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Achievements',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.successLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${achievements.where((a) => a['unlocked'] == true).length}/${achievements.length}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.successLight,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Column(
            children: achievements.map((achievement) {
              final isUnlocked = achievement['unlocked'] as bool;
              final isNext = achievement['isNext'] as bool? ?? false;

              return Container(
                margin: EdgeInsets.only(bottom: 3.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline indicator
                    Column(
                      children: [
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: isUnlocked
                                ? AppTheme.successLight
                                : isNext
                                    ? AppTheme.warningLight
                                    : AppTheme.dividerLight,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isUnlocked
                                  ? AppTheme.successLight
                                  : isNext
                                      ? AppTheme.warningLight
                                      : AppTheme.dividerLight,
                              width: 2,
                            ),
                          ),
                          child: isUnlocked
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color: AppTheme.onPrimaryLight,
                                  size: 16,
                                )
                              : isNext
                                  ? CustomIconWidget(
                                      iconName: 'schedule',
                                      color: AppTheme.onPrimaryLight,
                                      size: 16,
                                    )
                                  : CustomIconWidget(
                                      iconName: 'lock',
                                      color: AppTheme.textDisabledLight,
                                      size: 16,
                                    ),
                        ),
                        if (achievement != achievements.last)
                          Container(
                            width: 2,
                            height: 4.h,
                            color: isUnlocked
                                ? AppTheme.successLight.withValues(alpha: 0.3)
                                : AppTheme.dividerLight,
                          ),
                      ],
                    ),
                    SizedBox(width: 4.w),
                    // Achievement content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: isUnlocked
                                      ? AppTheme.successLight
                                          .withValues(alpha: 0.1)
                                      : isNext
                                          ? AppTheme.warningLight
                                              .withValues(alpha: 0.1)
                                          : AppTheme.dividerLight
                                              .withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: CustomIconWidget(
                                  iconName: achievement['icon'] as String,
                                  color: isUnlocked
                                      ? AppTheme.successLight
                                      : isNext
                                          ? AppTheme.warningLight
                                          : AppTheme.textDisabledLight,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      achievement['title'] as String,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: isUnlocked
                                            ? AppTheme.textPrimaryLight
                                            : AppTheme.textSecondaryLight,
                                      ),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text(
                                      achievement['description'] as String,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppTheme.textSecondaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (isUnlocked && achievement['date'] != null) ...[
                            SizedBox(height: 1.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: AppTheme.successLight
                                    .withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'event',
                                    color: AppTheme.successLight,
                                    size: 14,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'Unlocked on ${achievement['date']}',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.successLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (isNext && achievement['progress'] != null) ...[
                            SizedBox(height: 1.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Progress',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: AppTheme.textSecondaryLight,
                                      ),
                                    ),
                                    Text(
                                      '${achievement['progress']}%',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.warningLight,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 0.5.h),
                                Container(
                                  width: double.infinity,
                                  height: 1.h,
                                  decoration: BoxDecoration(
                                    color: AppTheme.dividerLight,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: FractionallySizedBox(
                                    widthFactor:
                                        (achievement['progress'] as int) / 100,
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.warningLight,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (achievement['reward'] != null) ...[
                            SizedBox(height: 1.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight
                                    .withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppTheme.primaryLight
                                      .withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'card_giftcard',
                                    color: AppTheme.primaryLight,
                                    size: 14,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'Reward: ${achievement['reward']}',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.primaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
