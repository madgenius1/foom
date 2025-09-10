import 'package:flutter/material.dart';
import '../presentation/analytics_dashboard/analytics_dashboard.dart';
import '../presentation/app_permissions_setup/app_permissions_setup.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/financial_setup_wizard/financial_setup_wizard.dart';
import '../presentation/app_management/app_management.dart';
import '../presentation/app_blocking_interface/app_blocking_interface.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/investments_dashboard/investments_dashboard.dart';
import '../presentation/main_app_wrapper/main_app_wrapper.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String mainApp = '/main-app';
  static const String homeDashboard = '/home-dashboard';
  static const String profileScreen = '/profile-screen';
  static const String investmentsDashboard = '/investments-dashboard';
  static const String analyticsDashboard = '/analytics-dashboard';
  static const String appPermissionsSetup = '/app-permissions-setup';
  static const String login = '/login-screen';
  static const String financialSetupWizard = '/financial-setup-wizard';
  static const String appManagement = '/app-management';
  static const String appBlockingInterface = '/app-blocking-interface';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    mainApp: (context) => const MainAppWrapper(),
    homeDashboard: (context) => const HomeDashboard(),
    profileScreen: (context) => const ProfileScreen(),
    investmentsDashboard: (context) => const InvestmentsDashboard(),
    analyticsDashboard: (context) => const AnalyticsDashboard(),
    appPermissionsSetup: (context) => const AppPermissionsSetup(),
    login: (context) => const LoginScreen(),
    financialSetupWizard: (context) => const FinancialSetupWizard(),
    appManagement: (context) => AppManagement(),
    appBlockingInterface: (context) => const AppBlockingInterface(),
    // TODO: Add your other routes here
  };
}
