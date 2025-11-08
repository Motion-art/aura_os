import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final int? count;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final IconData? icon;
  final Color? color;

  const FilterChipWidget({
    super.key,
    required this.label,
    this.count,
    this.isSelected = false,
    this.onTap,
    this.onRemove,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: 2.w),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? colorScheme.primary).withValues(alpha: 0.1)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (color ?? colorScheme.primary)
                : colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color:
                        (color ?? colorScheme.primary).withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              CustomIconWidget(
                iconName: _getIconName(icon!),
                size: 16,
                color: isSelected
                    ? (color ?? colorScheme.primary)
                    : colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 1.w),
            ],
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? (color ?? colorScheme.primary)
                    : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (count != null && count! > 0) ...[
              SizedBox(width: 1.w),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.2.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (color ?? colorScheme.primary)
                      : colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? colorScheme.surface
                        : colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
            if (isSelected && onRemove != null) ...[
              SizedBox(width: 1.w),
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: EdgeInsets.all(0.5.w),
                  decoration: BoxDecoration(
                    color:
                        (color ?? colorScheme.primary).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'close',
                    size: 12,
                    color: color ?? colorScheme.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getIconName(IconData iconData) {
    // Map common IconData to string names for CustomIconWidget
    if (iconData == Icons.priority_high) return 'priority_high';
    if (iconData == Icons.schedule) return 'schedule';
    if (iconData == Icons.source) return 'source';
    if (iconData == Icons.calendar_today) return 'calendar_today';
    if (iconData == Icons.dashboard) return 'dashboard';
    if (iconData == Icons.edit) return 'edit';
    if (iconData == Icons.filter_list) return 'filter_list';
    return 'label'; // Default fallback
  }
}

class FilterChipData {
  final String id;
  final String label;
  final IconData? icon;
  final Color? color;
  final String type;
  final dynamic value;

  const FilterChipData({
    required this.id,
    required this.label,
    this.icon,
    this.color,
    required this.type,
    this.value,
  });

  static List<FilterChipData> get priorityFilters => [
        const FilterChipData(
          id: 'priority_high',
          label: 'High Priority',
          icon: Icons.priority_high,
          color: AppTheme.errorRed,
          type: 'priority',
          value: 'high',
        ),
        const FilterChipData(
          id: 'priority_medium',
          label: 'Medium Priority',
          icon: Icons.priority_high,
          color: AppTheme.warningAmber,
          type: 'priority',
          value: 'medium',
        ),
        const FilterChipData(
          id: 'priority_low',
          label: 'Low Priority',
          icon: Icons.priority_high,
          color: AppTheme.accentGreen,
          type: 'priority',
          value: 'low',
        ),
      ];

  static List<FilterChipData> get dueDateFilters => [
        const FilterChipData(
          id: 'due_overdue',
          label: 'Overdue',
          icon: Icons.schedule,
          color: AppTheme.errorRed,
          type: 'dueDate',
          value: 'overdue',
        ),
        const FilterChipData(
          id: 'due_today',
          label: 'Due Today',
          icon: Icons.schedule,
          color: AppTheme.warningAmber,
          type: 'dueDate',
          value: 'today',
        ),
        const FilterChipData(
          id: 'due_week',
          label: 'This Week',
          icon: Icons.schedule,
          color: AppTheme.primaryBlue,
          type: 'dueDate',
          value: 'week',
        ),
      ];

  static List<FilterChipData> get sourceFilters => [
        const FilterChipData(
          id: 'source_calendar',
          label: 'Google Calendar',
          icon: Icons.calendar_today,
          color: Color(0xFF4285F4),
          type: 'source',
          value: 'google_calendar',
        ),
        const FilterChipData(
          id: 'source_trello',
          label: 'Trello',
          icon: Icons.dashboard,
          color: Color(0xFF0079BF),
          type: 'source',
          value: 'trello',
        ),
        const FilterChipData(
          id: 'source_manual',
          label: 'Manual',
          icon: Icons.edit,
          color: AppTheme.secondarySlate,
          type: 'source',
          value: 'manual',
        ),
      ];

  static List<FilterChipData> get allFilters => [
        ...priorityFilters,
        ...dueDateFilters,
        ...sourceFilters,
      ];
}
