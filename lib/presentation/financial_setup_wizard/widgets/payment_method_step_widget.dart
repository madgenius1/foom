import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentMethodStepWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;
  final Map<String, dynamic> initialData;

  const PaymentMethodStepWidget({
    Key? key,
    required this.onDataChanged,
    required this.initialData,
  }) : super(key: key);

  @override
  State<PaymentMethodStepWidget> createState() =>
      _PaymentMethodStepWidgetState();
}

class _PaymentMethodStepWidgetState extends State<PaymentMethodStepWidget> {
  String? selectedPaymentMethod;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'mpesa',
      'name': 'M-Pesa',
      'description': 'Safaricom M-Pesa mobile money',
      'icon': 'phone_android',
      'color': Color(0xFF00A651),
      'inputType': 'phone',
      'placeholder': 'Enter M-Pesa phone number',
    },
    {
      'id': 'airtel',
      'name': 'Airtel Money',
      'description': 'Airtel Money mobile wallet',
      'icon': 'phone_android',
      'color': Color(0xFFE60012),
      'inputType': 'phone',
      'placeholder': 'Enter Airtel Money phone number',
    },
    {
      'id': 'paypal',
      'name': 'PayPal',
      'description': 'PayPal digital wallet',
      'icon': 'account_balance_wallet',
      'color': Color(0xFF0070BA),
      'inputType': 'email',
      'placeholder': 'Enter PayPal email address',
    },
    {
      'id': 'bank',
      'name': 'Bank Account',
      'description': 'Traditional bank savings account',
      'icon': 'account_balance',
      'color': Color(0xFF1B365D),
      'inputType': 'account',
      'placeholder': 'Enter bank account number',
    },
    {
      'id': 'mmf',
      'name': 'Money Market Fund',
      'description': 'High-yield investment account',
      'icon': 'trending_up',
      'color': Color(0xFF2E8B57),
      'inputType': 'account',
      'placeholder': 'Enter MMF account number',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    if (widget.initialData.isNotEmpty) {
      selectedPaymentMethod = widget.initialData['method'];
      _phoneController.text = widget.initialData['phone'] ?? '';
      _emailController.text = widget.initialData['email'] ?? '';
      _accountController.text = widget.initialData['account'] ?? '';
    }
    _notifyDataChange();
  }

  void _notifyDataChange() {
    widget.onDataChanged({
      'method': selectedPaymentMethod,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'account': _accountController.text,
    });
  }

  void _selectPaymentMethod(String methodId) {
    setState(() {
      selectedPaymentMethod = methodId;
    });
    _notifyDataChange();
  }

  Widget _buildInputField(Map<String, dynamic> method) {
    TextEditingController controller;
    String inputType = method['inputType'];

    switch (inputType) {
      case 'phone':
        controller = _phoneController;
        break;
      case 'email':
        controller = _emailController;
        break;
      case 'account':
        controller = _accountController;
        break;
      default:
        controller = _phoneController;
    }

    return Container(
      margin: EdgeInsets.only(top: 2.h),
      child: TextField(
        controller: controller,
        keyboardType: inputType == 'phone'
            ? TextInputType.phone
            : inputType == 'email'
                ? TextInputType.emailAddress
                : TextInputType.text,
        onChanged: (value) => _notifyDataChange(),
        style: AppTheme.lightTheme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: method['placeholder'],
          prefixIcon: Icon(
            inputType == 'phone'
                ? Icons.phone
                : inputType == 'email'
                    ? Icons.email
                    : Icons.account_balance,
            color: method['color'],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppTheme.lightTheme.dividerColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: method['color'],
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.h,
          ),
        ),
      ),
    );
  }

  void _simulateMpesaSetup() {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your M-Pesa phone number'),
          backgroundColor: AppTheme.errorLight,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'phone_android',
              color: Color(0xFF00A651),
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              'M-Pesa STK Push',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your M-Pesa PIN to authorize FOOM savings account linking',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            TextField(
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 4,
              ),
              decoration: InputDecoration(
                hintText: '••••',
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 2.h),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSetupSuccess('M-Pesa');
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showSetupSuccess(String methodName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.secondaryLight,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              'Setup Complete!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.secondaryLight,
              ),
            ),
          ],
        ),
        content: Text(
          '$methodName has been successfully linked to your FOOM account. Your savings will be automatically transferred here.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Great!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Link Your Savings Account',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Choose where your savings will be automatically transferred',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 4.h),

          // Payment Methods List
          Column(
            children: paymentMethods.map((method) {
              final isSelected = selectedPaymentMethod == method['id'];
              return Container(
                margin: EdgeInsets.only(bottom: 3.h),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _selectPaymentMethod(method['id']),
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (method['color'] as Color)
                                  .withValues(alpha: 0.1)
                              : AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? method['color']
                                : AppTheme.lightTheme.dividerColor,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                color: (method['color'] as Color)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomIconWidget(
                                iconName: method['icon'],
                                color: method['color'],
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    method['name'],
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? method['color']
                                          : AppTheme
                                              .lightTheme.colorScheme.onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    method['description'],
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 6.w,
                              height: 6.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? method['color']
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? method['color']
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
                          ],
                        ),
                      ),
                    ),

                    // Input field for selected method
                    if (isSelected) ...[
                      _buildInputField(method),
                      SizedBox(height: 2.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (method['id'] == 'mpesa') {
                              _simulateMpesaSetup();
                            } else {
                              _showSetupSuccess(method['name']);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: method['color'],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Setup ${method['name']}',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 2.h),

          // Security Notice
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'security',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Your payment information is encrypted and secure. FOOM never stores your PIN or sensitive data.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
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
    _phoneController.dispose();
    _emailController.dispose();
    _accountController.dispose();
    super.dispose();
  }
}