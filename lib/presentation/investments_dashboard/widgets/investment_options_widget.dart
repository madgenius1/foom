import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class InvestmentOptionsWidget extends StatelessWidget {
  const InvestmentOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final investmentOptions = [
      {
        'name': 'Fixed Deposits',
        'description': 'Guaranteed 7.5% annual return',
        'risk': 'Low',
        'minInvestment': '\$100',
        'icon': Icons.savings_outlined,
        'color': colorScheme.secondary,
      },
      {
        'name': 'Money Market Fund',
        'description': 'Flexible with 8.2% expected return',
        'risk': 'Medium',
        'minInvestment': '\$50',
        'icon': Icons.trending_up_outlined,
        'color': colorScheme.primary,
      },
      {
        'name': 'Micro Investments',
        'description': 'Diversified portfolio, 10.1% return',
        'risk': 'Medium',
        'minInvestment': '\$10',
        'icon': Icons.scatter_plot_outlined,
        'color': colorScheme.tertiary,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Investment Options',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        ...investmentOptions.map((option) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Card(
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.w),
                  leading: CircleAvatar(
                    backgroundColor:
                        (option['color'] as Color).withValues(alpha: 0.1),
                    child: Icon(
                      option['icon'] as IconData,
                      color: option['color'] as Color,
                    ),
                  ),
                  title: Text(
                    option['name'] as String,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4.h),
                      Text(
                        option['description'] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: _getRiskColor(
                                      option['risk'] as String, colorScheme)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${option['risk']} Risk',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: _getRiskColor(
                                    option['risk'] as String, colorScheme),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Min: ${option['minInvestment']}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onTap: () =>
                      _showInvestmentDetails(context, option['name'] as String),
                ),
              ),
            )),
      ],
    );
  }

  Color _getRiskColor(String risk, ColorScheme colorScheme) {
    switch (risk.toLowerCase()) {
      case 'low':
        return colorScheme.secondary;
      case 'medium':
        return colorScheme.tertiary;
      case 'high':
        return colorScheme.error;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  void _showInvestmentDetails(BuildContext context, String investmentName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$investmentName details coming soon'),
      ),
    );
  }
}
