import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricAuthWidget extends StatefulWidget {
  final VoidCallback? onBiometricSuccess;
  final VoidCallback? onPinSuccess;

  const BiometricAuthWidget({
    Key? key,
    this.onBiometricSuccess,
    this.onPinSuccess,
  }) : super(key: key);

  @override
  State<BiometricAuthWidget> createState() => _BiometricAuthWidgetState();
}

class _BiometricAuthWidgetState extends State<BiometricAuthWidget> {
  bool _isLoading = false;
  bool _showPinEntry = false;
  String _pinCode = '';
  final int _pinLength = 4;

  Future<void> _authenticateWithBiometrics() async {
    setState(() => _isLoading = true);

    try {
      // Simulate biometric authentication
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() => _isLoading = false);
        widget.onBiometricSuccess?.call();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showPinEntry = true;
        });
      }
    }
  }

  void _onPinDigitPressed(String digit) {
    if (_pinCode.length < _pinLength) {
      setState(() {
        _pinCode += digit;
      });

      if (_pinCode.length == _pinLength) {
        _validatePin();
      }
    }
  }

  void _validatePin() {
    // Mock PIN validation (1234)
    if (_pinCode == '1234') {
      widget.onPinSuccess?.call();
    } else {
      setState(() {
        _pinCode = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid PIN. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _clearPin() {
    setState(() {
      _pinCode = '';
    });
  }

  Widget _buildBiometricButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          Text(
            'Quick Access',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAuthOption(
                icon: defaultTargetPlatform == TargetPlatform.iOS
                    ? 'face'
                    : 'fingerprint',
                label: defaultTargetPlatform == TargetPlatform.iOS
                    ? 'Face ID'
                    : 'Fingerprint',
                onTap: _isLoading ? null : _authenticateWithBiometrics,
              ),
              _buildAuthOption(
                icon: 'pin',
                label: 'PIN',
                onTap: () => setState(() => _showPinEntry = true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAuthOption({
    required String icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20.w,
        height: 20.w,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isLoading && icon != 'pin'
                ? SizedBox(
                    width: 6.w,
                    height: 6.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  )
                : CustomIconWidget(
                    iconName: icon,
                    size: 6.w,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontSize: 10.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinEntry() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enter PIN',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _showPinEntry = false),
                child: CustomIconWidget(
                  iconName: 'close',
                  size: 5.w,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pinLength, (index) {
              return Container(
                width: 12.w,
                height: 12.w,
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                decoration: BoxDecoration(
                  color: index < _pinCode.length
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: index < _pinCode.length
                    ? Center(
                        child: CustomIconWidget(
                          iconName: 'circle',
                          size: 3.w,
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      )
                    : null,
              );
            }),
          ),
          SizedBox(height: 3.h),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            childAspectRatio: 1.2,
            mainAxisSpacing: 2.h,
            crossAxisSpacing: 4.w,
            children: [
              ...List.generate(9, (index) {
                final digit = (index + 1).toString();
                return _buildPinButton(digit);
              }),
              const SizedBox(),
              _buildPinButton('0'),
              GestureDetector(
                onTap: _clearPin,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'backspace',
                      size: 5.w,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPinButton(String digit) {
    return GestureDetector(
      onTap: () => _onPinDigitPressed(digit),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            digit,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _showPinEntry ? _buildPinEntry() : _buildBiometricButton();
  }
}
