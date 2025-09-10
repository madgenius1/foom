import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_timeline_widget.dart';
import './widgets/app_category_breakdown_widget.dart';
import './widgets/goal_progress_widget.dart';
import './widgets/metrics_header_widget.dart';
import './widgets/motivational_insights_widget.dart';
import './widgets/screen_time_savings_chart_widget.dart';
import './widgets/time_heatmap_widget.dart';
import './widgets/time_period_selector_widget.dart';

class AnalyticsDashboard extends StatefulWidget {
  const AnalyticsDashboard({Key? key}) : super(key: key);

  @override
  State<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard> {
  String selectedPeriod = 'Daily';
  bool isLoading = false;

  // Mock data for analytics
  final List<Map<String, dynamic>> dailyChartData = [
    {'label': 'Mon', 'screenTime': 4.5, 'savings': 180.0},
    {'label': 'Tue', 'screenTime': 3.2, 'savings': 240.0},
    {'label': 'Wed', 'screenTime': 5.1, 'savings': 150.0},
    {'label': 'Thu', 'screenTime': 2.8, 'savings': 320.0},
    {'label': 'Fri', 'screenTime': 6.2, 'savings': 120.0},
    {'label': 'Sat', 'screenTime': 7.5, 'savings': 80.0},
    {'label': 'Sun', 'screenTime': 4.0, 'savings': 200.0},
  ];

  final List<Map<String, dynamic>> weeklyChartData = [
    {'label': 'W1', 'screenTime': 28.5, 'savings': 1200.0},
    {'label': 'W2', 'screenTime': 32.1, 'savings': 980.0},
    {'label': 'W3', 'screenTime': 25.8, 'savings': 1450.0},
    {'label': 'W4', 'screenTime': 30.2, 'savings': 1100.0},
  ];

  final List<Map<String, dynamic>> monthlyChartData = [
    {'label': 'Jan', 'screenTime': 120.5, 'savings': 4800.0},
    {'label': 'Feb', 'screenTime': 98.2, 'savings': 5200.0},
    {'label': 'Mar', 'screenTime': 110.8, 'savings': 4600.0},
    {'label': 'Apr', 'screenTime': 95.1, 'savings': 5500.0},
    {'label': 'May', 'screenTime': 88.7, 'savings': 5800.0},
    {'label': 'Jun', 'screenTime': 102.3, 'savings': 5100.0},
  ];

  final List<Map<String, dynamic>> appBreakdownData = [
    {'name': 'Instagram', 'icon': 'photo_camera', 'usage': 2.5, 'savings': 125},
    {'name': 'TikTok', 'icon': 'video_library', 'usage': 3.2, 'savings': 160},
    {'name': 'WhatsApp', 'icon': 'chat', 'usage': 1.8, 'savings': 90},
    {'name': 'Twitter', 'icon': 'alternate_email', 'usage': 1.5, 'savings': 75},
    {'name': 'YouTube', 'icon': 'play_circle', 'usage': 2.8, 'savings': 140},
  ];

  final List<Map<String, dynamic>> dailyHeatmapData = [
    {'day': 0, 'hour': 8, 'intensity': 0.8},
    {'day': 0, 'hour': 12, 'intensity': 0.6},
    {'day': 0, 'hour': 18, 'intensity': 0.9},
    {'day': 1, 'hour': 9, 'intensity': 0.7},
    {'day': 1, 'hour': 13, 'intensity': 0.5},
    {'day': 1, 'hour': 19, 'intensity': 0.8},
    {'day': 2, 'hour': 10, 'intensity': 0.6},
    {'day': 2, 'hour': 14, 'intensity': 0.7},
    {'day': 2, 'hour': 20, 'intensity': 0.9},
    {'day': 3, 'hour': 11, 'intensity': 0.5},
    {'day': 3, 'hour': 15, 'intensity': 0.8},
    {'day': 3, 'hour': 21, 'intensity': 0.7},
    {'day': 4, 'hour': 12, 'intensity': 0.9},
    {'day': 4, 'hour': 16, 'intensity': 0.6},
    {'day': 4, 'hour': 22, 'intensity': 0.8},
    {'day': 5, 'hour': 13, 'intensity': 0.7},
    {'day': 5, 'hour': 17, 'intensity': 0.9},
    {'day': 5, 'hour': 23, 'intensity': 0.5},
    {'day': 6, 'hour': 14, 'intensity': 0.6},
    {'day': 6, 'hour': 18, 'intensity': 0.8},
  ];

  final List<Map<String, dynamic>> weeklyHeatmapData = [
    {'day': 0, 'intensity': 0.7, 'blocks': 12},
    {'day': 1, 'intensity': 0.8, 'blocks': 15},
    {'day': 2, 'intensity': 0.6, 'blocks': 10},
    {'day': 3, 'intensity': 0.9, 'blocks': 18},
    {'day': 4, 'intensity': 0.5, 'blocks': 8},
    {'day': 5, 'intensity': 0.8, 'blocks': 14},
    {'day': 6, 'intensity': 0.7, 'blocks': 11},
  ];

  final List<Map<String, dynamic>> monthlyHeatmapData = [
    {'week': 1, 'intensity': 0.8, 'savings': 1200},
    {'week': 2, 'intensity': 0.6, 'savings': 980},
    {'week': 3, 'intensity': 0.9, 'savings': 1450},
    {'week': 4, 'intensity': 0.7, 'savings': 1100},
    {'week': 5, 'intensity': 0.5, 'savings': 750},
  ];

  final List<Map<String, dynamic>> achievementsData = [
    {
      'title': 'First Block',
      'description': 'Successfully blocked your first app',
      'icon': 'block',
      'unlocked': true,
      'date': '15 Aug 2025',
      'reward': '10 free minutes',
    },
    {
      'title': 'Week Warrior',
      'description': 'Blocked apps for 7 consecutive days',
      'icon': 'calendar_today',
      'unlocked': true,
      'date': '22 Aug 2025',
      'reward': 'KES 50 bonus',
    },
    {
      'title': 'Savings Starter',
      'description': 'Saved your first KES 500',
      'icon': 'savings',
      'unlocked': true,
      'date': '28 Aug 2025',
      'reward': 'Premium features',
    },
    {
      'title': 'Focus Master',
      'description': 'Block apps for 30 consecutive days',
      'icon': 'psychology',
      'unlocked': false,
      'isNext': true,
      'progress': 75,
      'reward': 'KES 200 bonus',
    },
    {
      'title': 'Savings Champion',
      'description': 'Save KES 5,000 in total',
      'icon': 'emoji_events',
      'unlocked': false,
      'isNext': false,
      'reward': 'Investment consultation',
    },
  ];

  final List<Map<String, dynamic>> motivationalInsights = [
    {
      'title': 'Great Progress!',
      'description':
          'You\'ve reduced your screen time by 2.5 hours this week compared to last week. Keep it up!',
      'icon': 'trending_down',
      'trend': 'down',
      'trendValue': '2.5h',
      'actionText': 'Continue the streak',
    },
    {
      'title': 'Savings Milestone',
      'description':
          'You\'re just KES 200 away from reaching your monthly savings goal. One more productive day!',
      'icon': 'savings',
      'trend': 'up',
      'trendValue': 'KES 200',
      'actionText': 'Push to the goal',
    },
    {
      'title': 'Peak Focus Time',
      'description':
          'Your most productive hours are between 2-4 PM. Consider scheduling important tasks then.',
      'icon': 'schedule',
      'actionText': 'Optimize your schedule',
    },
    {
      'title': 'Weekend Challenge',
      'description':
          'Weekends show higher app usage. Try outdoor activities to maintain your progress.',
      'icon': 'nature',
      'trend': 'up',
      'trendValue': '1.2h',
      'actionText': 'Plan weekend activities',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Analytics Dashboard',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showExportOptions,
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.primaryLight,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: _showFilterOptions,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.primaryLight,
              size: 24,
            ),
          ),
        ],
      ),
      body: isLoading
          ? _buildLoadingState()
          : RefreshIndicator(
              onRefresh: _refreshData,
              color: AppTheme.primaryLight,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    MetricsHeaderWidget(
                      totalSavings: 'KES 3,250',
                      blockedSessions: 127,
                      avgScreenTimeReduction: '3.2 hours',
                    ),
                    TimePeriodSelectorWidget(
                      selectedPeriod: selectedPeriod,
                      onPeriodChanged: _onPeriodChanged,
                    ),
                    ScreenTimeSavingsChartWidget(
                      selectedPeriod: selectedPeriod,
                      chartData: _getChartDataForPeriod(),
                    ),
                    AppCategoryBreakdownWidget(
                      appData: appBreakdownData,
                    ),
                    TimeHeatmapWidget(
                      heatmapData: _getHeatmapDataForPeriod(),
                      selectedPeriod: selectedPeriod,
                    ),
                    GoalProgressWidget(
                      currentSavings: 3250.0,
                      targetSavings: 5000.0,
                      period: selectedPeriod,
                      projectedMonthly: 4200.0,
                    ),
                    AchievementTimelineWidget(
                      achievements: achievementsData,
                    ),
                    MotivationalInsightsWidget(
                      insights: motivationalInsights,
                    ),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.primaryLight,
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading analytics...',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedItemColor: AppTheme.primaryLight,
      unselectedItemColor: AppTheme.textSecondaryLight,
      currentIndex: 1, // Analytics tab is active
      onTap: _onBottomNavTap,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            color: AppTheme.textSecondaryLight,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'home',
            color: AppTheme.primaryLight,
            size: 24,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'analytics',
            color: AppTheme.primaryLight,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'analytics',
            color: AppTheme.primaryLight,
            size: 24,
          ),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'apps',
            color: AppTheme.textSecondaryLight,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'apps',
            color: AppTheme.primaryLight,
            size: 24,
          ),
          label: 'Apps',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: AppTheme.textSecondaryLight,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'person',
            color: AppTheme.primaryLight,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getChartDataForPeriod() {
    switch (selectedPeriod) {
      case 'Weekly':
        return weeklyChartData;
      case 'Monthly':
        return monthlyChartData;
      default:
        return dailyChartData;
    }
  }

  List<Map<String, dynamic>> _getHeatmapDataForPeriod() {
    switch (selectedPeriod) {
      case 'Weekly':
        return weeklyHeatmapData;
      case 'Monthly':
        return monthlyHeatmapData;
      default:
        return dailyHeatmapData;
    }
  }

  void _onPeriodChanged(String period) {
    setState(() {
      selectedPeriod = period;
    });
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/app-blocking-interface');
        break;
      case 1:
        // Already on Analytics Dashboard
        break;
      case 2:
        Navigator.pushNamed(context, '/app-management');
        break;
      case 3:
        // Navigate to profile (not implemented in this scope)
        break;
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Export Analytics',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
              SizedBox(height: 3.h),
              _buildExportOption('PDF Report', 'picture_as_pdf', () {
                Navigator.pop(context);
                _exportToPDF();
              }),
              _buildExportOption('CSV Data', 'table_chart', () {
                Navigator.pop(context);
                _exportToCSV();
              }),
              _buildExportOption('Share Progress', 'share', () {
                Navigator.pop(context);
                _shareProgress();
              }),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExportOption(String title, String icon, VoidCallback onTap) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: AppTheme.primaryLight,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppTheme.textPrimaryLight,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showFilterOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          title: Text(
            'Filter Options',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterOption('All Apps', true),
              _buildFilterOption('Social Media Only', false),
              _buildFilterOption('Gaming Apps Only', false),
              _buildFilterOption('Communication Apps', false),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppTheme.textSecondaryLight),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Apply filters
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterOption(String title, bool isSelected) {
    return CheckboxListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          color: AppTheme.textPrimaryLight,
        ),
      ),
      value: isSelected,
      onChanged: (value) {
        // Handle filter selection
      },
      activeColor: AppTheme.primaryLight,
    );
  }

  void _exportToPDF() {
    // Implement PDF export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF export feature coming soon!'),
        backgroundColor: AppTheme.primaryLight,
      ),
    );
  }

  void _exportToCSV() {
    // Implement CSV export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('CSV export feature coming soon!'),
        backgroundColor: AppTheme.primaryLight,
      ),
    );
  }

  void _shareProgress() {
    // Implement native share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share progress feature coming soon!'),
        backgroundColor: AppTheme.primaryLight,
      ),
    );
  }
}
