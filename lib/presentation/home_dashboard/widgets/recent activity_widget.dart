import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

import '../../../core/app_export.dart';

/// Widget displaying recent activity timeline with swipe-to-dismiss functionality
class RecentActivityWidget extends StatefulWidget {
  final bool isCompact;
  final int maxItems;
  
  const RecentActivityWidget({
    super.key, 
    this.isCompact = false,
    this.maxItems = 5,
  });

  @override
  State<RecentActivityWidget> createState() => _RecentActivityWidgetState();
}

class _RecentActivityWidgetState extends State<RecentActivityWidget> {
  final List<Map<String, dynamic>> _activities = [
    {
      "id": 1,
      "type": "task_completed",
      "title": "Completed: Review quarterly reports",
      "subtitle": "Task completed 2 hours ago",
      "icon": "check_circle",
      "color": "success",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      "id": 2,
      "type": "note_created",
      "title": "Created: Meeting notes - Product Strategy",
      "subtitle": "Note saved 4 hours ago",
      "icon": "note_add",
      "color": "primary",
      "timestamp": DateTime.now().subtract(const Duration(hours: 4)),
    },
    {
      "id": 3,
      "type": "energy_logged",
      "title": "Energy check-in: High focus level",
      "subtitle": "Logged yesterday at 3:00 PM",
      "icon": "bolt",
      "color": "tertiary",
      "timestamp": DateTime.now().subtract(const Duration(days: 1, hours: 5)),
    },
    {
      "id": 4,
      "type": "peer_interaction",
      "title": "Sarah completed your accountability job",
      "subtitle": "Peer interaction 2 days ago",
      "icon": "groups",
      "color": "secondary",
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      "id": 5,
      "type": "task_created",
      "title": "Added: Prepare presentation slides",
      "subtitle": "Task created 3 days ago",
      "icon": "add_task",
      "color": "primary",
      "timestamp": DateTime.now().subtract(const Duration(days: 3)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full activity log
                },
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: widget.isCompact ? 0 : 4.w),
          itemCount: widget.isCompact ? 
            math.min(_activities.length, widget.maxItems) : 
            _activities.length,
          separatorBuilder: (context, index) => SizedBox(height: widget.isCompact ? 0.5.h : 1.h),
          itemBuilder: (context, index) {
            final activity = _activities[index];
            return _buildActivityItem(activity, index, isCompact: widget.isCompact);
          },
        ),
      ],
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity, int index, {bool isCompact = false}) {
    final color = _getActivityColor(activity["color"] as String);

    return Dismissible(
      key: Key('activity_${activity["id"]}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: 'delete',
          color: AppTheme.lightTheme.colorScheme.error,
          size: 24,
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          _activities.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Activity dismissed'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  _activities.insert(index, activity);
                });
              },
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(isCompact ? 2.w : 3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
          border: isCompact ? null : Border.all(
            color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isCompact ? 1.5.w : 2.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: CustomIconWidget(
                iconName: activity["icon"] as String,
                color: color,
                size: isCompact ? 16 : 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity["title"] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    activity["subtitle"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Color _getActivityColor(String colorType) {
    switch (colorType) {
      case 'success':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'primary':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'secondary':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'tertiary':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }
}
