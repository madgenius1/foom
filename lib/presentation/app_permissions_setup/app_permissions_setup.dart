import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_selection_widget.dart';
import './widgets/permission_card_widget.dart';
import './widgets/privacy_assurance_widget.dart';
import './widgets/progress_indicator_widget.dart';

class AppPermissionsSetup extends StatefulWidget {
  const AppPermissionsSetup({Key? key}) : super(key: key);

  @override
  State<AppPermissionsSetup> createState() => _AppPermissionsSetupState();
}

class _AppPermissionsSetupState extends State<AppPermissionsSetup>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Permission states
  bool _usageAccessGranted = false;
  bool _overlayPermissionGranted = false;
  bool _deviceAppsAccessGranted = false;
  bool _notificationPermissionGranted = false;

  // App selection
  List<String> _selectedApps = [];

  // Mock data for available apps
  final List<Map<String, dynamic>> _availableApps = [
    {
      'id': 'instagram',
      'name': 'Instagram',
      'icon':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Instagram_icon.png/2048px-Instagram_icon.png',
      'category': 'Social Media',
    },
    {
      'id': 'tiktok',
      'name': 'TikTok',
      'icon':
          'https://sf-tb-sg.ibytedtos.com/obj/eden-sg/uhtyvueh7nulogpoguhm/tiktok-icon_144x144.png',
      'category': 'Entertainment',
    },
    {
      'id': 'whatsapp',
      'name': 'WhatsApp',
      'icon':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/WhatsApp.svg/2044px-WhatsApp.svg.png',
      'category': 'Messaging',
    },
    {
      'id': 'facebook',
      'name': 'Facebook',
      'icon':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Facebook_Logo_%282019%29.png/1024px-Facebook_Logo_%282019%29.png',
      'category': 'Social Media',
    },
    {
      'id': 'youtube',
      'name': 'YouTube',
      'icon':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/YouTube_full-color_icon_%282017%29.svg/2560px-YouTube_full-color_icon_%282017%29.svg.png',
      'category': 'Entertainment',
    },
    {
      'id': 'twitter',
      'name': 'Twitter',
      'icon':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Logo_of_Twitter.svg/512px-Logo_of_Twitter.svg.png',
      'category': 'Social Media',
    },
    {
      'id': 'candy_crush',
      'name': 'Candy Crush Saga',
      'icon':
          'https://upload.wikimedia.org/wikipedia/en/thumb/7/78/Candy_Crush_Saga_logo.svg/1200px-Candy_Crush_Saga_logo.svg.png',
      'category': 'Gaming',
    },
    {
      'id': 'pubg',
      'name': 'PUBG Mobile',
      'icon':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/be/PUBG_Mobile_logo.jpg/1200px-PUBG_Mobile_logo.jpg',
      'category': 'Gaming',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();

    // Initialize with some pre-selected popular apps
    _selectedApps = ['instagram', 'tiktok', 'facebook'];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double get _completionPercentage {
    int grantedPermissions = 0;
    int totalPermissions = 4;

    if (_usageAccessGranted) grantedPermissions++;
    if (_overlayPermissionGranted) grantedPermissions++;
    if (_deviceAppsAccessGranted) grantedPermissions++;
    if (_notificationPermissionGranted) grantedPermissions++;

    return (grantedPermissions / totalPermissions) * 100;
  }

  bool get _canContinue {
    // Essential permissions required to continue
    return _usageAccessGranted &&
        _overlayPermissionGranted &&
        _deviceAppsAccessGranted;
  }

  void _requestUsageAccess() {
    HapticFeedback.lightImpact();
    // Simulate permission request
    _showPermissionDialog(
      'Usage Access Permission',
      'FOOM needs to monitor your app usage to track screen time and enforce blocking. This data stays on your device and is never shared.',
      () {
        setState(() {
          _usageAccessGranted = true;
        });
        _showSuccessSnackBar('Usage access granted successfully!');
      },
    );
  }

  void _requestOverlayPermission() {
    HapticFeedback.lightImpact();
    _showPermissionDialog(
      'Display Over Other Apps',
      'This permission allows FOOM to show blocking screens when you try to access restricted apps. It\'s essential for the app blocking feature.',
      () {
        setState(() {
          _overlayPermissionGranted = true;
        });
        _showSuccessSnackBar('Overlay permission granted successfully!');
      },
    );
  }

  void _requestDeviceAppsAccess() {
    HapticFeedback.lightImpact();
    _showPermissionDialog(
      'Device Apps Access',
      'FOOM needs to access your installed apps list to identify which apps you want to control and block.',
      () {
        setState(() {
          _deviceAppsAccessGranted = true;
        });
        _showSuccessSnackBar('Device apps access granted successfully!');
      },
    );
  }

  void _requestNotificationPermission() {
    HapticFeedback.lightImpact();
    _showPermissionDialog(
      'Notification Permission',
      'Get notified about your savings progress, app blocking events, and daily financial goals.',
      () {
        setState(() {
          _notificationPermissionGranted = true;
        });
        _showSuccessSnackBar('Notification permission granted successfully!');
      },
    );
  }

  void _showPermissionDialog(
      String title, String description, VoidCallback onGrant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            description,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onGrant();
              },
              child: const Text('Grant Permission'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                message,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _continueToNextStep() {
    HapticFeedback.mediumImpact();
    if (_canContinue) {
      Navigator.pushNamed(context, '/financial-setup-wizard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: AppTheme.lightTheme.colorScheme.onError,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Please grant essential permissions to continue',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onError,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _skipOptionalPermissions() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Skip Optional Permissions?',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'You can skip notification permissions, but you\'ll miss important updates about your savings progress and app blocking events.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _continueToNextStep();
              },
              child: const Text('Continue Anyway'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'App Permissions',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _canContinue ? null : _skipOptionalPermissions,
            child: Text(
              'Skip',
              style: TextStyle(
                color: _canContinue
                    ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.5)
                    : AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grant Essential Permissions',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'FOOM needs these permissions to help you save money by blocking distracting apps. Your privacy is our priority.',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // Progress Indicator
              ProgressIndicatorWidget(
                currentStep: 2,
                totalSteps: 4,
                completionPercentage: _completionPercentage,
              ),

              // Privacy Assurance
              const PrivacyAssuranceWidget(),

              SizedBox(height: 2.h),

              // Permission Cards
              PermissionCardWidget(
                iconName: 'bar_chart',
                title: 'Usage Access Permission',
                description:
                    'Monitor app usage time to track your screen time and calculate savings. This data never leaves your device.',
                isGranted: _usageAccessGranted,
                isRequired: true,
                onTap: _usageAccessGranted ? null : _requestUsageAccess,
                trailing: _usageAccessGranted
                    ? null
                    : ElevatedButton(
                        onPressed: _requestUsageAccess,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                        ),
                        child: const Text('Grant'),
                      ),
              ),

              PermissionCardWidget(
                iconName: 'layers',
                title: 'Display Over Other Apps',
                description:
                    'Show blocking screens when you try to access restricted apps. Essential for the money-saving feature.',
                isGranted: _overlayPermissionGranted,
                isRequired: true,
                onTap: _overlayPermissionGranted
                    ? null
                    : _requestOverlayPermission,
                trailing: _overlayPermissionGranted
                    ? null
                    : ElevatedButton(
                        onPressed: _requestOverlayPermission,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                        ),
                        child: const Text('Grant'),
                      ),
              ),

              PermissionCardWidget(
                iconName: 'apps',
                title: 'Device Apps Access',
                description:
                    'Access your installed apps list to identify which apps you want to control and save money on.',
                isGranted: _deviceAppsAccessGranted,
                isRequired: true,
                onTap:
                    _deviceAppsAccessGranted ? null : _requestDeviceAppsAccess,
                trailing: _deviceAppsAccessGranted
                    ? null
                    : ElevatedButton(
                        onPressed: _requestDeviceAppsAccess,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                        ),
                        child: const Text('Grant'),
                      ),
              ),

              PermissionCardWidget(
                iconName: 'notifications',
                title: 'Notification Permission',
                description:
                    'Get notified about your savings progress, app blocking events, and daily financial goals.',
                isGranted: _notificationPermissionGranted,
                isRequired: false,
                onTap: _notificationPermissionGranted
                    ? null
                    : _requestNotificationPermission,
                trailing: _notificationPermissionGranted
                    ? null
                    : OutlinedButton(
                        onPressed: _requestNotificationPermission,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                        ),
                        child: const Text('Grant'),
                      ),
              ),

              SizedBox(height: 2.h),

              // App Selection Section
              AppSelectionWidget(
                availableApps: _availableApps,
                selectedApps: _selectedApps,
                onSelectionChanged: (selectedApps) {
                  setState(() {
                    _selectedApps = selectedApps;
                  });
                },
              ),

              SizedBox(height: 4.h),

              // Continue Button
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canContinue ? _continueToNextStep : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: _canContinue
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue to Financial Setup',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: _canContinue
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'arrow_forward',
                        color: _canContinue
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // Help Text
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'help_outline',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Need help? These permissions are safe and help FOOM turn your screen time into savings.',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
