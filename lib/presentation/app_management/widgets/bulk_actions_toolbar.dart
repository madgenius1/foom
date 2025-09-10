import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BulkActionsToolbar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onSelectAll;
  final VoidCallback onDeselectAll;
  final VoidCallback onBlockSelected;
  final VoidCallback onUnblockSelected;
  final VoidCallback onRemoveSelected;
  final VoidCallback onCancel;

  const BulkActionsToolbar({
    Key? key,
    required this.selectedCount,
    required this.onSelectAll,
    required this.onDeselectAll,
    required this.onBlockSelected,
    required this.onUnblockSelected,
    required this.onRemoveSelected,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: selectedCount > 0 ? 12.h : 0,
      child: selectedCount > 0
          ? Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                border: Border(
                  top: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '$selectedCount app${selectedCount > 1 ? 's' : ''} selected',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: onCancel,
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: 'select_all',
                          label: 'All',
                          onPressed: onSelectAll,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: _buildActionButton(
                          icon: 'block',
                          label: 'Block',
                          onPressed: onBlockSelected,
                          isPrimary: true,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: _buildActionButton(
                          icon: 'check_circle_outline',
                          label: 'Unblock',
                          onPressed: onUnblockSelected,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: _buildActionButton(
                          icon: 'delete',
                          label: 'Remove',
                          onPressed: onRemoveSelected,
                          isDestructive: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = false,
    bool isDestructive = false,
  }) {
    Color backgroundColor;
    Color textColor;
    Color iconColor;

    if (isPrimary) {
      backgroundColor = AppTheme.lightTheme.colorScheme.primary;
      textColor = AppTheme.lightTheme.colorScheme.onPrimary;
      iconColor = AppTheme.lightTheme.colorScheme.onPrimary;
    } else if (isDestructive) {
      backgroundColor =
          AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1);
      textColor = AppTheme.lightTheme.colorScheme.error;
      iconColor = AppTheme.lightTheme.colorScheme.error;
    } else {
      backgroundColor = AppTheme.lightTheme.colorScheme.surface;
      textColor = AppTheme.lightTheme.colorScheme.onSurface;
      iconColor = AppTheme.lightTheme.colorScheme.onSurface;
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: isPrimary ? 2 : 0,
        padding: EdgeInsets.symmetric(vertical: 1.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: !isPrimary
              ? BorderSide(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                )
              : BorderSide.none,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: iconColor,
            size: 16,
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
