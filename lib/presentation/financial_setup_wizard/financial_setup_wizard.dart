import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/charge_rate_step_widget.dart';
import './widgets/payment_method_step_widget.dart';
import './widgets/savings_goal_step_widget.dart';
import './widgets/step_indicator_widget.dart';

class FinancialSetupWizard extends StatefulWidget {
  const FinancialSetupWizard({Key? key}) : super(key: key);

  @override
  State<FinancialSetupWizard> createState() => _FinancialSetupWizardState();
}

class _FinancialSetupWizardState extends State<FinancialSetupWizard> {
  int currentStep = 1;
  final int totalSteps = 3;
  final PageController _pageController = PageController();

  // Data storage for each step
  Map<String, dynamic> savingsGoalData = {};
  Map<String, dynamic> chargeRateData = {};
  Map<String, dynamic> paymentMethodData = {};

  bool get canProceed {
    switch (currentStep) {
      case 1:
        return savingsGoalData.isNotEmpty &&
            savingsGoalData['amount'] != null &&
            savingsGoalData['amount'] > 0;
      case 2:
        return chargeRateData.isNotEmpty &&
            chargeRateData['rate'] != null &&
            chargeRateData['rate'] > 0;
      case 3:
        return paymentMethodData.isNotEmpty &&
            paymentMethodData['method'] != null;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (currentStep < totalSteps && canProceed) {
      setState(() {
        currentStep++;
      });
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (currentStep == totalSteps && canProceed) {
      _completeSetup();
    }
  }

  void _previousStep() {
    if (currentStep > 1) {
      setState(() {
        currentStep--;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipSetup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Skip Setup?',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'You can complete your financial setup later in your profile settings. You\'ll receive reminder notifications.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Continue Setup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/app-permissions-setup');
            },
            child: Text('Skip for Now'),
          ),
        ],
      ),
    );
  }

  void _completeSetup() {
    // Show completion animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check',
                color: Colors.white,
                size: 40,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Setup Complete!',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.secondary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Your financial goals are set. Let\'s start building those savings habits!',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
            _buildGoalSummary(),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                    context, '/app-permissions-setup');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
              child: Text(
                'Continue to App Setup',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSummary() {
    final currency = savingsGoalData['currency'] ?? 'KES';
    final amount = savingsGoalData['amount'] ?? 0.0;
    final isDailyGoal = savingsGoalData['isDailyGoal'] ?? true;
    final rate = chargeRateData['rate'] ?? 0.0;
    final paymentMethod = paymentMethodData['method'] ?? '';

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Goals Summary',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${isDailyGoal ? 'Daily' : 'Monthly'} Goal:',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              Text(
                '${currency == 'KES' ? 'KSh' : '\$'} ${amount.toStringAsFixed(0)}',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hourly Rate:',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              Text(
                'KSh ${rate.toStringAsFixed(0)}/hr',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Savings Account:',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              Text(
                _getPaymentMethodName(paymentMethod),
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodName(String methodId) {
    switch (methodId) {
      case 'mpesa':
        return 'M-Pesa';
      case 'airtel':
        return 'Airtel Money';
      case 'paypal':
        return 'PayPal';
      case 'bank':
        return 'Bank Account';
      case 'mmf':
        return 'Money Market Fund';
      default:
        return 'Not Selected';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: currentStep > 1
            ? IconButton(
                onPressed: _previousStep,
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
              )
            : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
              ),
        title: Text(
          'Financial Setup',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _skipSetup,
            child: Text(
              'Skip',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Step Indicator
          StepIndicatorWidget(
            currentStep: currentStep,
            totalSteps: totalSteps,
          ),

          // Step Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                SavingsGoalStepWidget(
                  onDataChanged: (data) {
                    setState(() {
                      savingsGoalData = data;
                    });
                  },
                  initialData: savingsGoalData,
                ),
                ChargeRateStepWidget(
                  onDataChanged: (data) {
                    setState(() {
                      chargeRateData = data;
                    });
                  },
                  initialData: chargeRateData,
                ),
                PaymentMethodStepWidget(
                  onDataChanged: (data) {
                    setState(() {
                      paymentMethodData = data;
                    });
                  },
                  initialData: paymentMethodData,
                ),
              ],
            ),
          ),

          // Navigation Buttons
          Container(
            padding: EdgeInsets.all(6.w),
            child: Row(
              children: [
                if (currentStep > 1)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        side: BorderSide(
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                      ),
                      child: Text(
                        'Back',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                if (currentStep > 1) SizedBox(width: 4.w),
                Expanded(
                  flex: currentStep == 1 ? 1 : 1,
                  child: ElevatedButton(
                    onPressed: canProceed ? _nextStep : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canProceed
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                    child: Text(
                      currentStep == totalSteps ? 'Complete Setup' : 'Continue',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
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
    _pageController.dispose();
    super.dispose();
  }
}