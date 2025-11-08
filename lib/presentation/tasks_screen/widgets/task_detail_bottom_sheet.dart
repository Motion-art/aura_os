import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TaskDetailBottomSheet extends StatelessWidget {
  final Map<String, dynamic> task;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onComplete;

  const TaskDetailBottomSheet({
    super.key,
    required this.task,
    this.onEdit,
    this.onDelete,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final title = task['title'] as String? ?? 'Untitled Task';
    final description = task['description'] as String? ?? '';
    final priority = (task['priority'] as String?) ?? 'medium';
    final dueDate = task['dueDate'] as DateTime?;
    final source = (task['source'] as String?) ?? 'manual';
    final isCompleted = task['isCompleted'] as bool? ?? false;

    Color priorityColor;
    switch (priority.toLowerCase()) {
      case 'high':
        priorityColor = AppTheme.errorRed;
        break;
      case 'low':
        priorityColor = AppTheme.accentGreen;
        break;
      default:
        priorityColor = AppTheme.warningAmber;
    }

    String dueText;
    if (dueDate == null) {
      dueText = 'No due date';
    } else {
      dueText = '${dueDate.month}/${dueDate.day}/${dueDate.year}';
    }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 4.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Title row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (isCompleted)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 0.8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'check_circle',
                        size: 14,
                        color: AppTheme.accentGreen,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Completed',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.accentGreen,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          SizedBox(height: 1.5.h),

          // Priority / Due / Source row
          Row(
            children: [
              // Priority chip
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: priorityColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'priority_high',
                      size: 14,
                      color: priorityColor,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '${priority[0].toUpperCase()}${priority.substring(1)}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: priorityColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 3.w),

              // Due date
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    dueText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Source badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  source[0].toUpperCase() + source.substring(1),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Description
          if (description.isNotEmpty) ...[
            Text(
              'Details',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            SizedBox(height: 2.h),
          ],

          // Actions
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  if (onDelete != null) onDelete!();
                },
                icon: CustomIconWidget(
                  iconName: 'delete',
                  size: 16,
                  color: AppTheme.errorRed,
                ),
                label: const Text('Delete'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.errorRed,
                ),
              ),
              SizedBox(width: 3.w),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  if (onEdit != null) onEdit!();
                },
                icon: CustomIconWidget(
                  iconName: 'edit',
                  size: 16,
                  color: AppTheme.surfaceWhite,
                ),
                label: const Text('Edit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                ),
              ),
              const Spacer(),
              if (!isCompleted)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (onComplete != null) onComplete!();
                  },
                  child: const Text('Mark Complete'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
