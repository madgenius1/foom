import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../routes/app_routes.dart';

class SettingsSectionWidget extends StatelessWidget {
  const SettingsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Card(
          child: Column(
            children: [
              _buildSettingsItem(
                context: context,
                icon: Icons.person_outline,
                title: 'Account Details',
                subtitle: 'Manage your personal information',
                onTap: () => _showAccountDetails(context),
                theme: theme,
              ),
              _buildDivider(theme),
              _buildSettingsItem(
                context: context,
                icon: Icons.savings_outlined,
                title: 'Savings Configuration',
                subtitle: 'Set daily targets and hourly rates',
                onTap: () => _showSavingsConfig(context),
                theme: theme,
              ),
              _buildDivider(theme),
              _buildSettingsItem(
                context: context,
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage notification preferences',
                onTap: () => _showNotificationSettings(context),
                theme: theme,
              ),
              _buildDivider(theme),
              _buildSettingsItem(
                context: context,
                icon: Icons.security_outlined,
                title: 'Security',
                subtitle: 'Blocking strictness and emergency contacts',
                onTap: () => _showSecuritySettings(context),
                theme: theme,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
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
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.primary,
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

  void _showAccountDetails(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account details feature coming soon')),
    );
  }

  void _showSavingsConfig(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.financialSetupWizard);
  }

  void _showNotificationSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Notification settings feature coming soon')),
    );
  }

  void _showSecuritySettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Security settings feature coming soon')),
    );
  }
}
