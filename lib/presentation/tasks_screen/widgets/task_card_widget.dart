import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TaskCardWidget extends StatelessWidget {
  final Map<String, dynamic> task;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;
  final bool isSelected;

  const TaskCardWidget({
    super.key,
    required this.task,
    this.onTap,
    this.onComplete,
    this.onEdit,
    this.onDelete,
    this.onShare,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCompleted = task['isCompleted'] as bool? ?? false;
    final priority = task['priority'] as String? ?? 'medium';
    final source = task['source'] as String? ?? 'manual';
    final dueDate = task['dueDate'] as DateTime?;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.8.h),
      child: Slidable(
        key: ValueKey(task['id']),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onComplete?.call(),
              backgroundColor: AppTheme.accentGreen,
              foregroundColor: AppTheme.surfaceWhite,
              icon: Icons.check,
              label: 'Complete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onEdit?.call(),
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: AppTheme.surfaceWhite,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onShare?.call(),
              backgroundColor: AppTheme.secondarySlate,
              foregroundColor: AppTheme.surfaceWhite,
              icon: Icons.share,
              label: 'Share',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onDelete?.call(),
              backgroundColor: AppTheme.errorRed,
              foregroundColor: AppTheme.surfaceWhite,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primaryContainer
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : _getPriorityColor(priority),
                width: isSelected ? 2 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Priority indicator (small vertical line)
                      Container(
                        width: 3,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: _getPriorityColor(priority),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(width: 3.w),

                      // Task content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title and source badge row
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    task['title'] as String? ?? 'Untitled Task',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          decoration: isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                          color: isCompleted
                                              ? colorScheme.onSurfaceVariant
                                              : colorScheme.onSurface,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                _buildSourceBadge(source, colorScheme),
                              ],
                            ),

                            // Description
                            if (task['description'] != null &&
                                (task['description'] as String).isNotEmpty) ...[
                              SizedBox(height: 1.h),
                              Text(
                                task['description'] as String,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  decoration: isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],

                            SizedBox(height: 1.2.h),

                            // Due date and status row
                            Row(
                              children: [
                                if (dueDate != null) ...[
                                  CustomIconWidget(
                                    iconName: 'schedule',
                                    size: 16,
                                    color: _getDueDateColor(
                                      dueDate,
                                      colorScheme,
                                    ),
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    _formatDueDate(dueDate),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: _getDueDateColor(
                                        dueDate,
                                        colorScheme,
                                      ),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                ] else
                                  const Spacer(),

                                // Completion status
                                if (isCompleted)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                      vertical: 0.5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.accentGreen.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'check_circle',
                                          size: 14,
                                          color: AppTheme.accentGreen,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          'Completed',
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                                color: AppTheme.accentGreen,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Selection indicator
                      if (isSelected) ...[
                        SizedBox(width: 2.w),
                        CustomIconWidget(
                          iconName: 'check_circle',
                          size: 24,
                          color: colorScheme.primary,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSourceBadge(String source, ColorScheme colorScheme) {
    Color badgeColor;
    String badgeText;
    IconData badgeIcon;

    switch (source.toLowerCase()) {
      case 'google_calendar':
        badgeColor = const Color(0xFF4285F4);
        badgeText = 'Calendar';
        badgeIcon = Icons.calendar_today;
        break;
      case 'trello':
        badgeColor = const Color(0xFF0079BF);
        badgeText = 'Trello';
        badgeIcon = Icons.dashboard;
        break;
      case 'manual':
      default:
        badgeColor = AppTheme.secondarySlate;
        badgeText = 'Manual';
        badgeIcon = Icons.edit;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, size: 12, color: badgeColor),
          SizedBox(width: 1.w),
          Text(
            badgeText,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.errorRed;
      case 'medium':
        return AppTheme.warningAmber;
      case 'low':
        return AppTheme.accentGreen;
      default:
        return AppTheme.secondarySlate;
    }
  }

  Color _getDueDateColor(DateTime dueDate, ColorScheme colorScheme) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (taskDate.isBefore(today)) {
      return AppTheme.errorRed; // Overdue
    } else if (taskDate.isAtSameMomentAs(today)) {
      return AppTheme.warningAmber; // Due today
    } else {
      return colorScheme.onSurfaceVariant; // Future date
    }
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final taskDate = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (taskDate.isAtSameMomentAs(today)) {
      return 'Due Today';
    } else if (taskDate.isAtSameMomentAs(tomorrow)) {
      return 'Due Tomorrow';
    } else if (taskDate.isBefore(today)) {
      final difference = today.difference(taskDate).inDays;
      return 'Overdue by $difference day${difference > 1 ? 's' : ''}';
    } else {
      final difference = taskDate.difference(today).inDays;
      if (difference <= 7) {
        return 'Due in $difference day${difference > 1 ? 's' : ''}';
      } else {
        return '${dueDate.month}/${dueDate.day}/${dueDate.year}';
      }
    }
  }
}
