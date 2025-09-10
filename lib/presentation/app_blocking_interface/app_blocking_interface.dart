import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/blocked_app_header_widget.dart';
import './widgets/motivational_message_widget.dart';
import './widgets/payment_options_widget.dart';
import './widgets/shared_minutes_widget.dart';
import './widgets/time_selection_widget.dart';
import './widgets/token_purchase_widget.dart';

class AppBlockingInterface extends StatefulWidget {
  const AppBlockingInterface({Key? key}) : super(key: key);

  @override
  State<AppBlockingInterface> createState() => _AppBlockingInterfaceState();
}

class _AppBlockingInterfaceState extends State<AppBlockingInterface>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // Mock data for the blocked app
  final Map<String, dynamic> blockedApp = {
    "name": "Instagram",
    "icon":
        "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Instagram_icon.png/2048px-Instagram_icon.png",
    "packageName": "com.instagram.android",
  };

  // User data
  int remainingMinutes = 3;
  int totalMinutes = 60;
  double totalSavings = 247.50;
  int streakCount = 12;
  String currency = "KES";
  double hourlyRate = 50.0;

  // Selection states
  int? selectedTime;
  Map<String, dynamic>? selectedToken;
  String? selectedPaymentId;
  bool isLoading = false;
  bool showTokenPurchase = false;

  // Time options in minutes
  final List<int> timeOptions = [1, 5, 10, 15];

  // Token purchase options
  final List<Map<String, dynamic>> tokenOptions = [
    {
      "minutes": 15,
      "price": 12.50,
      "popular": false,
    },
    {
      "minutes": 30,
      "price": 25.00,
      "popular": true,
    },
    {
      "minutes": 45,
      "price": 37.50,
      "popular": false,
    },
    {
      "minutes": 60,
      "price": 50.00,
      "popular": false,
    },
  ];

  // Payment methods
  final List<Map<String, dynamic>> paymentMethods = [
    {
      "id": "mpesa",
      "name": "M-Pesa",
      "description": "Pay with your M-Pesa account",
      "logo":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/M-PESA_LOGO-01.svg/2048px-M-PESA_LOGO-01.svg.png",
      "isPopular": true,
    },
    {
      "id": "airtel",
      "name": "Airtel Money",
      "description": "Pay with Airtel Money",
      "logo": "https://www.airtel.in/assets/static/airtel-money-logo.png",
      "isPopular": false,
    },
    {
      "id": "paypal",
      "name": "PayPal",
      "description": "Pay with your PayPal account",
      "logo":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/PayPal.svg/2048px-PayPal.svg.png",
      "isPopular": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkMinutesAvailability();

    // Provide haptic feedback on modal appearance
    HapticFeedback.mediumImpact();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _slideController.forward();
    _fadeController.forward();
  }

  void _checkMinutesAvailability() {
    if (remainingMinutes <= 0) {
      setState(() {
        showTokenPurchase = true;
      });
    }
  }

  void _onTimeSelected(int time) {
    if (remainingMinutes >= time) {
      setState(() {
        selectedTime = time;
      });
      HapticFeedback.selectionClick();
    } else {
      setState(() {
        showTokenPurchase = true;
      });
      SystemSound.play(SystemSoundType.alert);
    }
  }

  void _onTokenSelected(Map<String, dynamic> token) {
    setState(() {
      selectedToken = token;
      selectedPaymentId =
          paymentMethods.first['id']; // Default to first payment method
    });
    HapticFeedback.selectionClick();
  }

  void _onPaymentSelected(Map<String, dynamic> method) {
    setState(() {
      selectedPaymentId = method['id'];
    });
    HapticFeedback.selectionClick();
  }

  Future<void> _processUnlock() async {
    if (selectedTime != null && remainingMinutes >= selectedTime!) {
      await _unlockWithMinutes();
    } else if (selectedToken != null && selectedPaymentId != null) {
      await _unlockWithPurchase();
    }
  }

  Future<void> _unlockWithMinutes() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Simulate processing time
      await Future.delayed(const Duration(seconds: 2));

      // Deduct minutes
      setState(() {
        remainingMinutes -= selectedTime!;
      });

      SystemSound.play(SystemSoundType.click);

      // Show success and navigate
      _showSuccessMessage("App unlocked for ${selectedTime!} minutes!");
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      SystemSound.play(SystemSoundType.alert);
      _showErrorMessage("Failed to unlock app. Please try again.");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _unlockWithPurchase() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Simulate payment processing
      await _processPayment();

      // Add purchased minutes
      final purchasedMinutes = selectedToken!['minutes'] as int;
      final price = selectedToken!['price'] as double;

      setState(() {
        remainingMinutes += purchasedMinutes;
        totalSavings += price;
        streakCount += 1;
      });

      SystemSound.play(SystemSoundType.click);

      // Show success message
      _showSuccessMessage(
          "Payment successful! ${purchasedMinutes} minutes added and $currency ${price.toStringAsFixed(2)} saved to your account!");

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      SystemSound.play(SystemSoundType.alert);
      _showErrorMessage("Payment failed. Please try again.");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _processPayment() async {
    // Simulate different payment methods
    switch (selectedPaymentId) {
      case 'mpesa':
        await _processMpesaPayment();
        break;
      case 'airtel':
        await _processAirtelPayment();
        break;
      case 'paypal':
        await _processPayPalPayment();
        break;
      default:
        throw Exception('Unknown payment method');
    }
  }

  Future<void> _processMpesaPayment() async {
    // Simulate M-Pesa STK push
    await Future.delayed(const Duration(milliseconds: 500));

    // Show M-Pesa popup simulation
    if (mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _buildMpesaDialog(),
      );
    }
  }

  Future<void> _processAirtelPayment() async {
    // Simulate Airtel Money processing
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> _processPayPalPayment() async {
    // Simulate PayPal processing
    await Future.delayed(const Duration(seconds: 3));
  }

  Widget _buildMpesaDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomImageWidget(
              imageUrl:
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/M-PESA_LOGO-01.svg/2048px-M-PESA_LOGO-01.svg.png",
              width: 20.w,
              height: 8.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 3.h),
            Text(
              'M-Pesa Payment Request',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Please enter your M-Pesa PIN on your phone to complete the payment of $currency ${selectedToken!['price'].toStringAsFixed(2)}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                SizedBox(
                  width: 6.w,
                  height: 6.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  'Waiting for confirmation...',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                message,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.w),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'error',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                message,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.w),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _onCancel() {
    HapticFeedback.lightImpact();
    Navigator.of(context).pop();
  }

  bool _canUnlock() {
    if (remainingMinutes > 0 &&
        selectedTime != null &&
        selectedTime! <= remainingMinutes) {
      return true;
    }
    if (showTokenPurchase &&
        selectedToken != null &&
        selectedPaymentId != null) {
      return true;
    }
    return false;
  }

  String _getUnlockButtonText() {
    if (remainingMinutes > 0 && selectedTime != null) {
      final cost = (selectedTime! / 60) * hourlyRate;
      return 'Unlock for $currency ${cost.toStringAsFixed(2)}';
    }
    if (selectedToken != null) {
      return 'Purchase & Unlock';
    }
    return 'Unlock App';
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.7),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: GestureDetector(
          onTap: _onCancel,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: GestureDetector(
                onTap: () {}, // Prevent modal dismissal when tapping inside
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    width: 90.w,
                    constraints: BoxConstraints(
                      maxHeight: 85.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(6.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.w),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header with blocked app info
                            BlockedAppHeaderWidget(
                              appName: blockedApp['name'] as String,
                              appIconUrl: blockedApp['icon'] as String,
                            ),

                            // Shared minutes display
                            SharedMinutesWidget(
                              remainingMinutes: remainingMinutes,
                              totalMinutes: totalMinutes,
                            ),

                            // Time selection (if minutes available)
                            if (remainingMinutes > 0 && !showTokenPurchase)
                              TimeSelectionWidget(
                                timeOptions: timeOptions,
                                selectedTime: selectedTime,
                                onTimeSelected: _onTimeSelected,
                                hourlyRate: hourlyRate,
                                currency: currency,
                              ),

                            // Token purchase section (if no minutes or forced)
                            if (showTokenPurchase || remainingMinutes <= 0) ...[
                              TokenPurchaseWidget(
                                tokenOptions: tokenOptions,
                                onTokenSelected: _onTokenSelected,
                                isLoading: isLoading,
                                currency: currency,
                              ),

                              // Payment methods
                              if (selectedToken != null)
                                PaymentOptionsWidget(
                                  paymentMethods: paymentMethods,
                                  onPaymentSelected: _onPaymentSelected,
                                  isLoading: isLoading,
                                  selectedPaymentId: selectedPaymentId,
                                ),
                            ],

                            // Motivational message
                            MotivationalMessageWidget(
                              totalSavings: totalSavings,
                              streakCount: streakCount,
                              currency: currency,
                            ),

                            // Action buttons
                            ActionButtonsWidget(
                              onUnlock: _canUnlock() ? _processUnlock : null,
                              onCancel: _onCancel,
                              isLoading: isLoading,
                              canUnlock: _canUnlock(),
                              unlockButtonText: _getUnlockButtonText(),
                            ),

                            SizedBox(height: 2.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}