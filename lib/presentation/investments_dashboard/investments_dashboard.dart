import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './widgets/financial_goals_widget.dart';
import './widgets/investment_options_widget.dart';
import './widgets/performance_chart_widget.dart';
import './widgets/portfolio_summary_widget.dart';
import './widgets/quick_investment_actions_widget.dart';
import './widgets/recent_transactions_widget.dart';

class InvestmentsDashboard extends StatefulWidget {
  const InvestmentsDashboard({super.key});

  @override
  State<InvestmentsDashboard> createState() => _InvestmentsDashboardState();
}

class _InvestmentsDashboardState extends State<InvestmentsDashboard> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Investments',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.history,
              color: colorScheme.onSurface,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings_outlined,
              color: colorScheme.onSurface,
              size: 24,
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 100.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Portfolio summary
              const PortfolioSummaryWidget(),
              SizedBox(height: 16.h),

              // Performance chart
              const PerformanceChartWidget(),
              SizedBox(height: 16.h),

              // Financial goals
              const FinancialGoalsWidget(),
              SizedBox(height: 16.h),

              // Quick investment actions
              const QuickInvestmentActionsWidget(),
              SizedBox(height: 16.h),

              // Investment options
              const InvestmentOptionsWidget(),
              SizedBox(height: 16.h),

              // Recent transactions
              const RecentTransactionsWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
  }
}
