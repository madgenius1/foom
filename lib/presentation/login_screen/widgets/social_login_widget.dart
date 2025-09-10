import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginWidget extends StatefulWidget {
  final VoidCallback? onGoogleLogin;
  final VoidCallback? onAppleLogin;
  final VoidCallback? onFacebookLogin;

  const SocialLoginWidget({
    Key? key,
    this.onGoogleLogin,
    this.onAppleLogin,
    this.onFacebookLogin,
  }) : super(key: key);

  @override
  State<SocialLoginWidget> createState() => _SocialLoginWidgetState();
}

class _SocialLoginWidgetState extends State<SocialLoginWidget> {
  String? _loadingProvider;

  Future<void> _handleSocialLogin(
      String provider, VoidCallback? callback) async {
    setState(() => _loadingProvider = provider);

    try {
      await Future.delayed(const Duration(seconds: 2));
      callback?.call();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$provider login failed. Please try again.'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loadingProvider = null);
      }
    }
  }

  Widget _buildSocialButton({
    required String provider,
    required String iconName,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback? onTap,
  }) {
    final isLoading = _loadingProvider == provider;

    return Container(
      width: double.infinity,
      height: 6.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _handleSocialLogin(provider, onTap),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 2,
          shadowColor: AppTheme.lightTheme.colorScheme.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
        ),
        child: isLoading
            ? SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: iconName,
                    size: 5.w,
                    color: textColor,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Continue with $provider',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Or continue with',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                thickness: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        _buildSocialButton(
          provider: 'Google',
          iconName: 'g_translate',
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          textColor: AppTheme.lightTheme.colorScheme.onSurface,
          onTap: widget.onGoogleLogin,
        ),
        _buildSocialButton(
          provider: 'Apple',
          iconName: 'apple',
          backgroundColor: const Color(0xFF000000),
          textColor: Colors.white,
          onTap: widget.onAppleLogin,
        ),
        _buildSocialButton(
          provider: 'Facebook',
          iconName: 'facebook',
          backgroundColor: const Color(0xFF1877F2),
          textColor: Colors.white,
          onTap: widget.onFacebookLogin,
        ),
      ],
    );
  }
}
