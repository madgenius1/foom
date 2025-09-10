import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GoalProgressWidget extends StatelessWidget {
  final double currentSavings;
  final double targetSavings;
  final String period;
  final double projectedMonthly;

  const GoalProgressWidget({
    Key? key,
    required this.currentSavings,
    required this.targetSavings,
    required this.period,
    required this.projectedMonthly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progressPercentage = targetSavings > 0
        ? (currentSavings / targetSavings).clamp(0.0, 1.0)
        : 0.0;
    final remainingAmount =
        (targetSavings - currentSavings).clamp(0.0, double.infinity);

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
                'Goal Progress',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: progressPercentage >= 1.0
                      ? AppTheme.successLight.withValues(alpha: 0.1)
                      : AppTheme.warningLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(progressPercentage * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: progressPercentage >= 1.0
                        ? AppTheme.successLight
                        : AppTheme.warningLight,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          // Progress bar
          Container(
            width: double.infinity,
            height: 2.h,
            decoration: BoxDecoration(
              color: AppTheme.dividerLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: progressPercentage,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: progressPercentage >= 1.0
                            ? [
                                AppTheme.successLight,
                                AppTheme.successLight.withValues(alpha: 0.8)
                              ]
                            : [
                                AppTheme.primaryLight,
                                AppTheme.primaryLight.withValues(alpha: 0.8)
                              ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                if (progressPercentage >= 1.0)
                  Positioned(
                    right: 2.w,
                    top: 0,
                    bottom: 0,
                    child: CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.onPrimaryLight,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          // Progress details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Savings',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'KES ${currentSavings.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.successLight,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$period Target',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'KES ${targetSavings.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (remainingAmount > 0) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.warningLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.warningLight.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'trending_up',
                    color: AppTheme.warningLight,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'KES ${remainingAmount.toStringAsFixed(0)} to go',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.warningLight,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Keep blocking apps to reach your goal!',
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
            ),
          ],
          if (progressPercentage >= 1.0) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.successLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.successLight.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'celebration',
                    color: AppTheme.successLight,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Goal Achieved!',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.successLight,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Congratulations on reaching your savings target!',
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
            ),
          ],
          SizedBox(height: 3.h),
          // Projected monthly savings
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Projected Monthly',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'KES ${projectedMonthly.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryLight,
                      ),
                    ),
                  ],
                ),
                CustomIconWidget(
                  iconName: 'insights',
                  color: AppTheme.primaryLight,
                  size: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
