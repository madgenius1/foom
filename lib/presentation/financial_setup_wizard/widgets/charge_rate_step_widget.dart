import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChargeRateStepWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;
  final Map<String, dynamic> initialData;

  const ChargeRateStepWidget({
    Key? key,
    required this.onDataChanged,
    required this.initialData,
  }) : super(key: key);

  @override
  State<ChargeRateStepWidget> createState() => _ChargeRateStepWidgetState();
}

class _ChargeRateStepWidgetState extends State<ChargeRateStepWidget> {
  double selectedRate = 20.0;
  bool isCustomRate = false;
  final TextEditingController _customRateController = TextEditingController();

  final List<double> presetRates = [10.0, 20.0, 50.0];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    if (widget.initialData.isNotEmpty) {
      selectedRate = widget.initialData['rate'] ?? 20.0;
      isCustomRate = widget.initialData['isCustom'] ?? false;
      if (isCustomRate) {
        _customRateController.text = selectedRate.toStringAsFixed(0);
      }
    }
    _notifyDataChange();
  }

  void _notifyDataChange() {
    widget.onDataChanged({
      'rate': selectedRate,
      'isCustom': isCustomRate,
    });
  }

  void _selectPresetRate(double rate) {
    setState(() {
      selectedRate = rate;
      isCustomRate = false;
      _customRateController.clear();
    });
    _notifyDataChange();
  }

  void _selectCustomRate() {
    setState(() {
      isCustomRate = true;
      if (_customRateController.text.isEmpty) {
        _customRateController.text = selectedRate.toStringAsFixed(0);
      }
    });
    _notifyDataChange();
  }

  void _updateCustomRate(String value) {
    final rate = double.tryParse(value) ?? 0.0;
    setState(() {
      selectedRate = rate;
    });
    _notifyDataChange();
  }

  double _calculateDailyCost() {
    // Assuming average 4 hours of social media usage
    return selectedRate * 4;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set Your Hourly Charge Rate',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'This is how much you\'ll pay per hour to unlock blocked apps',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 4.h),

          // Preset Rate Options
          Text(
            'Choose a preset rate',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),

          Column(
            children: presetRates.map((rate) {
              final isSelected = !isCustomRate && selectedRate == rate;
              return Container(
                margin: EdgeInsets.only(bottom: 2.h),
                child: GestureDetector(
                  onTap: () => _selectPresetRate(rate),
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.dividerColor,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.lightTheme.dividerColor,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 3.w,
                                )
                              : null,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'KSh ${rate.toStringAsFixed(0)} per hour',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppTheme.lightTheme.primaryColor
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                _getRateDescription(rate),
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomIconWidget(
                          iconName: 'access_time',
                          color: isSelected
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 2.h),

          // Custom Rate Option
          GestureDetector(
            onTap: _selectCustomRate,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: isCustomRate
                    ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCustomRate
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.dividerColor,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCustomRate
                          ? AppTheme.lightTheme.primaryColor
                          : Colors.transparent,
                      border: Border.all(
                        color: isCustomRate
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.dividerColor,
                        width: 2,
                      ),
                    ),
                    child: isCustomRate
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 3.w,
                          )
                        : null,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Custom Rate',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isCustomRate
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        isCustomRate
                            ? Container(
                                width: 30.w,
                                child: TextField(
                                  controller: _customRateController,
                                  keyboardType: TextInputType.number,
                                  onChanged: _updateCustomRate,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.lightTheme.primaryColor,
                                  ),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: AppTheme.lightTheme.primaryColor,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 3.w,
                                      vertical: 1.h,
                                    ),
                                    prefixText: 'KSh ',
                                    suffixText: '/hr',
                                    isDense: true,
                                  ),
                                ),
                              )
                            : Text(
                                'Set your own hourly rate',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                      ],
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'edit',
                    color: isCustomRate
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Cost Preview
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'calculate',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Estimated Daily Cost',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  'KSh ${_calculateDailyCost().toStringAsFixed(0)}',
                  style: AppTheme.lightTheme.textTheme.displaySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Based on 4 hours average daily usage',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getRateDescription(double rate) {
    if (rate == 10.0) {
      return 'Light discipline - good for beginners';
    } else if (rate == 20.0) {
      return 'Moderate discipline - balanced approach';
    } else if (rate == 50.0) {
      return 'Strong discipline - serious commitment';
    }
    return 'Custom rate';
  }

  @override
  void dispose() {
    _customRateController.dispose();
    super.dispose();
  }
}