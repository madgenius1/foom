import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../routes/app_routes.dart';

class DataPrivacyWidget extends StatelessWidget {
  const DataPrivacyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data & Support',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Card(
          child: Column(
            children: [
              _buildDataItem(
                context: context,
                icon: Icons.download_outlined,
                title: 'Export Data',
                subtitle: 'Download your savings data',
                onTap: () => _exportData(context),
                theme: theme,
              ),
              _buildDivider(theme),
              _buildDataItem(
                context: context,
                icon: Icons.analytics_outlined,
                title: 'Usage Analytics',
                subtitle: 'View detailed usage statistics',
                onTap: () => _showAnalytics(context),
                theme: theme,
              ),
              _buildDivider(theme),
              _buildDataItem(
                context: context,
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'FAQ, contact support, app info',
                onTap: () => _showSupport(context),
                theme: theme,
              ),
              _buildDivider(theme),
              _buildDataItem(
                context: context,
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: 'Review our privacy practices',
                onTap: () => _showPrivacyPolicy(context),
                theme: theme,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.secondary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      height: 1,
      color: theme.dividerColor,
      indent: 16.w,
      endIndent: 16.w,
    );
  }

  void _exportData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data export feature coming soon')),
    );
  }

  void _showAnalytics(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.analyticsDashboard);
  }

  void _showSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Support features coming soon')),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy policy feature coming soon')),
    );
  }
}
