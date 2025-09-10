import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TimeHeatmapWidget extends StatelessWidget {
  final List<Map<String, dynamic>> heatmapData;
  final String selectedPeriod;

  const TimeHeatmapWidget({
    Key? key,
    required this.heatmapData,
    required this.selectedPeriod,
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
          Text(
            'Blocking Patterns',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            selectedPeriod == 'Daily'
                ? 'Peak blocking hours throughout the day'
                : selectedPeriod == 'Weekly'
                    ? 'Most blocked days of the week'
                    : 'Monthly blocking intensity',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.textSecondaryLight,
            ),
          ),
          SizedBox(height: 3.h),
          _buildHeatmapGrid(),
          SizedBox(height: 3.h),
          _buildIntensityLegend(),
        ],
      ),
    );
  }

  Widget _buildHeatmapGrid() {
    if (selectedPeriod == 'Daily') {
      return _buildDailyHeatmap();
    } else if (selectedPeriod == 'Weekly') {
      return _buildWeeklyHeatmap();
    } else {
      return _buildMonthlyHeatmap();
    }
  }

  Widget _buildDailyHeatmap() {
    final hours = List.generate(24, (index) => index);
    final maxIntensity = heatmapData.isNotEmpty
        ? heatmapData
            .map((e) => e['intensity'] as double)
            .reduce((a, b) => a > b ? a : b)
        : 1.0;

    return Column(
      children: [
        // Hour labels
        Row(
          children: [
            SizedBox(width: 8.w),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['6AM', '12PM', '6PM', '12AM'].map((time) {
                  return Text(
                    time,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppTheme.textSecondaryLight,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        // Heatmap grid
        Row(
          children: [
            Column(
              children:
                  ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
                return Container(
                  width: 8.w,
                  height: 4.h,
                  alignment: Alignment.center,
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                );
              }).toList(),
            ),
            Expanded(
              child: Column(
                children: List.generate(7, (dayIndex) {
                  return Row(
                    children: List.generate(24, (hourIndex) {
                      final dataPoint = heatmapData.firstWhere(
                        (data) =>
                            data['day'] == dayIndex &&
                            data['hour'] == hourIndex,
                        orElse: () => {'intensity': 0.0},
                      );
                      final intensity =
                          (dataPoint['intensity'] as double) / maxIntensity;

                      return Expanded(
                        child: Container(
                          height: 4.h,
                          margin: EdgeInsets.all(0.2.w),
                          decoration: BoxDecoration(
                            color: _getIntensityColor(intensity),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeeklyHeatmap() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxIntensity = heatmapData.isNotEmpty
        ? heatmapData
            .map((e) => e['intensity'] as double)
            .reduce((a, b) => a > b ? a : b)
        : 1.0;

    return Column(
      children: days.asMap().entries.map((entry) {
        final dayIndex = entry.key;
        final dayName = entry.value;
        final dataPoint = heatmapData.firstWhere(
          (data) => data['day'] == dayIndex,
          orElse: () => {'intensity': 0.0, 'blocks': 0},
        );
        final intensity = (dataPoint['intensity'] as double) / maxIntensity;

        return Container(
          margin: EdgeInsets.only(bottom: 1.h),
          child: Row(
            children: [
              SizedBox(
                width: 15.w,
                child: Text(
                  dayName,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: _getIntensityColor(intensity),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity * intensity,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Center(
                        child: Text(
                          '${dataPoint['blocks']} blocks',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: intensity > 0.5
                                ? AppTheme.onPrimaryLight
                                : AppTheme.textPrimaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMonthlyHeatmap() {
    final weeks = List.generate(5, (index) => index + 1);
    final maxIntensity = heatmapData.isNotEmpty
        ? heatmapData
            .map((e) => e['intensity'] as double)
            .reduce((a, b) => a > b ? a : b)
        : 1.0;

    return Column(
      children: weeks.map((week) {
        final dataPoint = heatmapData.firstWhere(
          (data) => data['week'] == week,
          orElse: () => {'intensity': 0.0, 'savings': 0},
        );
        final intensity = (dataPoint['intensity'] as double) / maxIntensity;

        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          child: Row(
            children: [
              SizedBox(
                width: 20.w,
                child: Text(
                  'Week $week',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: AppTheme.dividerLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: intensity,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getIntensityColor(intensity),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'KES ${dataPoint['savings']}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: intensity > 0.5
                                ? AppTheme.onPrimaryLight
                                : AppTheme.textPrimaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIntensityLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Less',
          style: TextStyle(
            fontSize: 10.sp,
            color: AppTheme.textSecondaryLight,
          ),
        ),
        Row(
          children: List.generate(5, (index) {
            final intensity = (index + 1) / 5;
            return Container(
              width: 4.w,
              height: 4.w,
              margin: EdgeInsets.symmetric(horizontal: 0.5.w),
              decoration: BoxDecoration(
                color: _getIntensityColor(intensity),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
        Text(
          'More',
          style: TextStyle(
            fontSize: 10.sp,
            color: AppTheme.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Color _getIntensityColor(double intensity) {
    if (intensity <= 0.2) {
      return AppTheme.dividerLight;
    } else if (intensity <= 0.4) {
      return AppTheme.primaryLight.withValues(alpha: 0.3);
    } else if (intensity <= 0.6) {
      return AppTheme.primaryLight.withValues(alpha: 0.5);
    } else if (intensity <= 0.8) {
      return AppTheme.primaryLight.withValues(alpha: 0.7);
    } else {
      return AppTheme.primaryLight;
    }
  }
}
