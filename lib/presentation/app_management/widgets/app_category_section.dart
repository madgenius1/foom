import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppCategorySection extends StatefulWidget {
  final String categoryTitle;
  final List<Map<String, dynamic>> apps;
  final Function(String appId, bool isBlocked) onToggleApp;
  final Function(String appId) onCustomRate;
  final Function(String appId) onBlockSchedule;
  final Function(String appId) onRemoveApp;

  const AppCategorySection({
    Key? key,
    required this.categoryTitle,
    required this.apps,
    required this.onToggleApp,
    required this.onCustomRate,
    required this.onBlockSchedule,
    required this.onRemoveApp,
  }) : super(key: key);

  @override
  State<AppCategorySection> createState() => _AppCategorySectionState();
}

class _AppCategorySectionState extends State<AppCategorySection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12),
              bottom: _isExpanded ? Radius.zero : Radius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.categoryTitle,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    '${widget.apps.length} apps',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            Divider(
              height: 1,
              color: AppTheme.lightTheme.dividerColor,
            ),
            ...widget.apps.map((app) => _buildAppItem(app)).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildAppItem(Map<String, dynamic> app) {
    final bool isBlocked = app['isBlocked'] ?? false;
    final String lastBlocked = app['lastBlocked'] ?? '';

    return Dismissible(
      key: Key(app['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        color: AppTheme.lightTheme.colorScheme.error,
        child: CustomIconWidget(
          iconName: 'delete',
          color: AppTheme.lightTheme.colorScheme.onError,
          size: 24,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Remove App'),
              content: Text('Remove ${app['name']} from controlled apps?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Remove'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        widget.onRemoveApp(app['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${app['name']} removed from controlled apps'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                // Undo functionality would be implemented here
              },
            ),
          ),
        );
      },
      child: InkWell(
        onLongPress: () => _showContextMenu(context, app),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.dividerColor,
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: CustomImageWidget(
                    imageUrl: app['icon'],
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app['name'],
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    if (lastBlocked.isNotEmpty) ...[
                      SizedBox(height: 0.5.h),
                      Text(
                        'Last blocked: $lastBlocked',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Switch(
                value: isBlocked,
                onChanged: (value) {
                  widget.onToggleApp(app['id'], value);
                },
                activeColor: AppTheme.lightTheme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, Map<String, dynamic> app) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'attach_money',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Custom Rate'),
                subtitle: Text('Set hourly charge for this app'),
                onTap: () {
                  Navigator.pop(context);
                  widget.onCustomRate(app['id']);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Block Schedule'),
                subtitle: Text('Set time-based restrictions'),
                onTap: () {
                  Navigator.pop(context);
                  widget.onBlockSchedule(app['id']);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 24,
                ),
                title: Text('Remove from List'),
                subtitle: Text('Stop controlling this app'),
                onTap: () {
                  Navigator.pop(context);
                  widget.onRemoveApp(app['id']);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
