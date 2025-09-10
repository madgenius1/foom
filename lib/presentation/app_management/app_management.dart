import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_category_section.dart';
import './widgets/app_search_bar.dart';
import './widgets/bulk_actions_toolbar.dart';
import './widgets/custom_rate_bottom_sheet.dart';
import './widgets/empty_state_widget.dart';

class AppManagement extends StatefulWidget {
  @override
  State<AppManagement> createState() => _AppManagementState();
}

class _AppManagementState extends State<AppManagement>
    with TickerProviderStateMixin {
  String _searchQuery = '';
  bool _isSelectionMode = false;
  Set<String> _selectedApps = {};
  late TabController _tabController;

  // Mock data for installed apps categorized
  final List<Map<String, dynamic>> _socialMediaApps = [
    {
      "id": "instagram",
      "name": "Instagram",
      "icon":
          "https://images.unsplash.com/photo-1611262588024-d12430b98920?w=100&h=100&fit=crop",
      "isBlocked": true,
      "lastBlocked": "2 hours ago",
      "customRate": 10.0,
    },
    {
      "id": "tiktok",
      "name": "TikTok",
      "icon":
          "https://images.unsplash.com/photo-1611605698335-8b1569810432?w=100&h=100&fit=crop",
      "isBlocked": true,
      "lastBlocked": "1 hour ago",
      "customRate": 15.0,
    },
    {
      "id": "whatsapp",
      "name": "WhatsApp",
      "icon":
          "https://images.unsplash.com/photo-1611746872915-64382b5c76da?w=100&h=100&fit=crop",
      "isBlocked": false,
      "lastBlocked": "Yesterday",
      "customRate": 5.0,
    },
    {
      "id": "facebook",
      "name": "Facebook",
      "icon":
          "https://images.unsplash.com/photo-1611944212129-29977ae1398c?w=100&h=100&fit=crop",
      "isBlocked": true,
      "lastBlocked": "3 hours ago",
      "customRate": 8.0,
    },
  ];

  final List<Map<String, dynamic>> _gameApps = [
    {
      "id": "candy_crush",
      "name": "Candy Crush Saga",
      "icon":
          "https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=100&h=100&fit=crop",
      "isBlocked": true,
      "lastBlocked": "30 minutes ago",
      "customRate": 20.0,
    },
    {
      "id": "pubg",
      "name": "PUBG Mobile",
      "icon":
          "https://images.unsplash.com/photo-1542751371-adc38448a05e?w=100&h=100&fit=crop",
      "isBlocked": false,
      "lastBlocked": "2 days ago",
      "customRate": 25.0,
    },
    {
      "id": "clash_royale",
      "name": "Clash Royale",
      "icon":
          "https://images.unsplash.com/photo-1556438064-2d7646166914?w=100&h=100&fit=crop",
      "isBlocked": true,
      "lastBlocked": "1 hour ago",
      "customRate": 12.0,
    },
  ];

  final List<Map<String, dynamic>> _entertainmentApps = [
    {
      "id": "youtube",
      "name": "YouTube",
      "icon":
          "https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=100&h=100&fit=crop",
      "isBlocked": false,
      "lastBlocked": "4 hours ago",
      "customRate": 7.0,
    },
    {
      "id": "netflix",
      "name": "Netflix",
      "icon":
          "https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?w=100&h=100&fit=crop",
      "isBlocked": true,
      "lastBlocked": "Yesterday",
      "customRate": 15.0,
    },
    {
      "id": "spotify",
      "name": "Spotify",
      "icon":
          "https://images.unsplash.com/photo-1614680376573-df3480f0c6ff?w=100&h=100&fit=crop",
      "isBlocked": false,
      "lastBlocked": "Never",
      "customRate": 3.0,
    },
  ];

  final List<Map<String, dynamic>> _productivityApps = [
    {
      "id": "chrome",
      "name": "Chrome",
      "icon":
          "https://images.unsplash.com/photo-1573804633927-bfcbcd909acd?w=100&h=100&fit=crop",
      "isBlocked": false,
      "lastBlocked": "Never",
      "customRate": 2.0,
    },
    {
      "id": "gmail",
      "name": "Gmail",
      "icon":
          "https://images.unsplash.com/photo-1596526131083-e8c633c948d2?w=100&h=100&fit=crop",
      "isBlocked": false,
      "lastBlocked": "Never",
      "customRate": 1.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _allApps {
    return [
      ..._socialMediaApps,
      ..._gameApps,
      ..._entertainmentApps,
      ..._productivityApps,
    ];
  }

  List<Map<String, dynamic>> _getFilteredApps(List<Map<String, dynamic>> apps) {
    if (_searchQuery.isEmpty) return apps;
    return apps
        .where((app) => (app['name'] as String)
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onToggleApp(String appId, bool isBlocked) {
    setState(() {
      // Find and update the app in the appropriate list
      for (var appList in [
        _socialMediaApps,
        _gameApps,
        _entertainmentApps,
        _productivityApps
      ]) {
        final appIndex = appList.indexWhere((app) => app['id'] == appId);
        if (appIndex != -1) {
          appList[appIndex]['isBlocked'] = isBlocked;
          if (isBlocked) {
            appList[appIndex]['lastBlocked'] = 'Just now';
          }
          break;
        }
      }
    });

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isBlocked ? 'App blocking enabled' : 'App blocking disabled',
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onCustomRate(String appId) {
    final app = _allApps.firstWhere((app) => app['id'] == appId);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CustomRateBottomSheet(
          app: app,
          onRateSet: _onRateSet,
        ),
      ),
    );
  }

  void _onRateSet(String appId, double rate) {
    setState(() {
      // Find and update the app rate
      for (var appList in [
        _socialMediaApps,
        _gameApps,
        _entertainmentApps,
        _productivityApps
      ]) {
        final appIndex = appList.indexWhere((app) => app['id'] == appId);
        if (appIndex != -1) {
          appList[appIndex]['customRate'] = rate;
          break;
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Custom rate set to KES ${rate.toStringAsFixed(0)} per hour'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onBlockSchedule(String appId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Block Schedule'),
        content: Text(
            'Block schedule feature will be available in the next update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onRemoveApp(String appId) {
    setState(() {
      // Remove app from all lists
      _socialMediaApps.removeWhere((app) => app['id'] == appId);
      _gameApps.removeWhere((app) => app['id'] == appId);
      _entertainmentApps.removeWhere((app) => app['id'] == appId);
      _productivityApps.removeWhere((app) => app['id'] == appId);
      _selectedApps.remove(appId);
    });
  }

  void _onAddNewApps() {
    Navigator.pushNamed(context, '/app-permissions-setup');
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedApps.clear();
      }
    });
  }

  void _onSelectAll() {
    setState(() {
      _selectedApps = _allApps.map((app) => app['id'] as String).toSet();
    });
  }

  void _onDeselectAll() {
    setState(() {
      _selectedApps.clear();
    });
  }

  void _onBlockSelected() {
    for (String appId in _selectedApps) {
      _onToggleApp(appId, true);
    }
    _toggleSelectionMode();
  }

  void _onUnblockSelected() {
    for (String appId in _selectedApps) {
      _onToggleApp(appId, false);
    }
    _toggleSelectionMode();
  }

  void _onRemoveSelected() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Apps'),
        content: Text(
            'Remove ${_selectedApps.length} selected apps from controlled list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              for (String appId in _selectedApps) {
                _onRemoveApp(appId);
              }
              _toggleSelectionMode();
              Navigator.pop(context);
            },
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasApps = _allApps.isNotEmpty;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'App Management',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        actions: [
          if (hasApps) ...[
            IconButton(
              onPressed: _toggleSelectionMode,
              icon: CustomIconWidget(
                iconName: _isSelectionMode ? 'close' : 'checklist',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ],
        ],
        bottom: hasApps
            ? TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'All'),
                  Tab(text: 'Social'),
                  Tab(text: 'Games'),
                  Tab(text: 'Entertainment'),
                ],
                labelColor: AppTheme.lightTheme.colorScheme.primary,
                unselectedLabelColor:
                    AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                indicatorColor: AppTheme.lightTheme.colorScheme.primary,
              )
            : null,
      ),
      body: hasApps
          ? Column(
              children: [
                AppSearchBar(
                  onSearchChanged: _onSearchChanged,
                  hintText: 'Search apps...',
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAllAppsTab(),
                      _buildCategoryTab(
                          _getFilteredApps(_socialMediaApps), 'Social Media'),
                      _buildCategoryTab(_getFilteredApps(_gameApps), 'Games'),
                      _buildCategoryTab(_getFilteredApps(_entertainmentApps),
                          'Entertainment'),
                    ],
                  ),
                ),
                BulkActionsToolbar(
                  selectedCount: _selectedApps.length,
                  onSelectAll: _onSelectAll,
                  onDeselectAll: _onDeselectAll,
                  onBlockSelected: _onBlockSelected,
                  onUnblockSelected: _onUnblockSelected,
                  onRemoveSelected: _onRemoveSelected,
                  onCancel: _toggleSelectionMode,
                ),
              ],
            )
          : EmptyStateWidget(
              onAddApps: _onAddNewApps,
            ),
      floatingActionButton: hasApps
          ? FloatingActionButton.extended(
              onPressed: _onAddNewApps,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onSecondary,
                size: 20,
              ),
              label: Text(
                'Add Apps',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            )
          : null,
    );
  }

  Widget _buildAllAppsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (_getFilteredApps(_socialMediaApps).isNotEmpty)
            AppCategorySection(
              categoryTitle: 'Social Media',
              apps: _getFilteredApps(_socialMediaApps),
              onToggleApp: _onToggleApp,
              onCustomRate: _onCustomRate,
              onBlockSchedule: _onBlockSchedule,
              onRemoveApp: _onRemoveApp,
            ),
          if (_getFilteredApps(_gameApps).isNotEmpty)
            AppCategorySection(
              categoryTitle: 'Games',
              apps: _getFilteredApps(_gameApps),
              onToggleApp: _onToggleApp,
              onCustomRate: _onCustomRate,
              onBlockSchedule: _onBlockSchedule,
              onRemoveApp: _onRemoveApp,
            ),
          if (_getFilteredApps(_entertainmentApps).isNotEmpty)
            AppCategorySection(
              categoryTitle: 'Entertainment',
              apps: _getFilteredApps(_entertainmentApps),
              onToggleApp: _onToggleApp,
              onCustomRate: _onCustomRate,
              onBlockSchedule: _onBlockSchedule,
              onRemoveApp: _onRemoveApp,
            ),
          if (_getFilteredApps(_productivityApps).isNotEmpty)
            AppCategorySection(
              categoryTitle: 'Productivity',
              apps: _getFilteredApps(_productivityApps),
              onToggleApp: _onToggleApp,
              onCustomRate: _onCustomRate,
              onBlockSchedule: _onBlockSchedule,
              onRemoveApp: _onRemoveApp,
            ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(
      List<Map<String, dynamic>> apps, String categoryName) {
    if (apps.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 15.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'No $categoryName apps found',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search terms'
                  : 'Add some $categoryName apps to get started',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          AppCategorySection(
            categoryTitle: categoryName,
            apps: apps,
            onToggleApp: _onToggleApp,
            onCustomRate: _onCustomRate,
            onBlockSchedule: _onBlockSchedule,
            onRemoveApp: _onRemoveApp,
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
