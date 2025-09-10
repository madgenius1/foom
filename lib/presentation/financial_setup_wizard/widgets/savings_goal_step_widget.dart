import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SavingsGoalStepWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;
  final Map<String, dynamic> initialData;

  const SavingsGoalStepWidget({
    Key? key,
    required this.onDataChanged,
    required this.initialData,
  }) : super(key: key);

  @override
  State<SavingsGoalStepWidget> createState() => _SavingsGoalStepWidgetState();
}

class _SavingsGoalStepWidgetState extends State<SavingsGoalStepWidget> {
  bool isDailyGoal = true;
  String selectedCurrency = 'KES';
  double goalAmount = 100.0;
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    if (widget.initialData.isNotEmpty) {
      isDailyGoal = widget.initialData['isDailyGoal'] ?? true;
      selectedCurrency = widget.initialData['currency'] ?? 'KES';
      goalAmount = widget.initialData['amount'] ?? 100.0;
      _amountController.text = goalAmount.toStringAsFixed(0);
    } else {
      _amountController.text = goalAmount.toStringAsFixed(0);
    }
    _notifyDataChange();
  }

  void _notifyDataChange() {
    widget.onDataChanged({
      'isDailyGoal': isDailyGoal,
      'currency': selectedCurrency,
      'amount': goalAmount,
    });
  }

  void _updateAmount(String value) {
    final amount = double.tryParse(value) ?? 0.0;
    setState(() {
      goalAmount = amount;
    });
    _notifyDataChange();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set Your Savings Goal',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Choose how much you want to save and how often',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 4.h),

          // Goal Type Toggle
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.dividerColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isDailyGoal = true;
                      });
                      _notifyDataChange();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      decoration: BoxDecoration(
                        color: isDailyGoal
                            ? AppTheme.lightTheme.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Daily Goal',
                        textAlign: TextAlign.center,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: isDailyGoal
                              ? Colors.white
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isDailyGoal = false;
                      });
                      _notifyDataChange();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      decoration: BoxDecoration(
                        color: !isDailyGoal
                            ? AppTheme.lightTheme.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Monthly Goal',
                        textAlign: TextAlign.center,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: !isDailyGoal
                              ? Colors.white
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // Currency Selection
          Text(
            'Currency',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCurrency = 'KES';
                    });
                    _notifyDataChange();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: selectedCurrency == 'KES'
                          ? AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selectedCurrency == 'KES'
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'KES (Kenyan Shilling)',
                      textAlign: TextAlign.center,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: selectedCurrency == 'KES'
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCurrency = 'USD';
                    });
                    _notifyDataChange();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: selectedCurrency == 'USD'
                          ? AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selectedCurrency == 'USD'
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'USD (US Dollar)',
                      textAlign: TextAlign.center,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: selectedCurrency == 'USD'
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Amount Input
          Text(
            'Target Amount',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.dividerColor,
                width: 1,
              ),
            ),
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              onChanged: _updateAmount,
              style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.primaryColor,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 3.h),
                prefixText: selectedCurrency == 'KES' ? 'KSh ' : '\$ ',
                prefixStyle:
                    AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Goal Visualization
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.secondaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    AppTheme.secondaryLight.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'savings',
                      color: AppTheme.secondaryLight,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Your ${isDailyGoal ? 'Daily' : 'Monthly'} Goal',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.secondaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  '${selectedCurrency == 'KES' ? 'KSh' : '\$'} ${goalAmount.toStringAsFixed(0)}',
                  style: AppTheme.lightTheme.textTheme.displaySmall?.copyWith(
                    color: AppTheme.secondaryLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  isDailyGoal
                      ? 'Save this amount every day'
                      : 'Save this amount every month',
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

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}