import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Widget displaying scrollable timeline of past wellness entries
class HistoricalTimelineWidget extends StatefulWidget {
  final List<Map<String, dynamic>> historicalData;
  final Function(Map<String, dynamic>) onEditEntry;

  const HistoricalTimelineWidget({
    super.key,
    required this.historicalData,
    required this.onEditEntry,
  });

  @override
  State<HistoricalTimelineWidget> createState() =>
      _HistoricalTimelineWidgetState();
}

class _HistoricalTimelineWidgetState extends State<HistoricalTimelineWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.historicalData.isEmpty) {
      return _buildEmptyState();
    }
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'history',
                  color: colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Recent Entries',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: colorScheme.outline),

          // Timeline entries
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.historicalData.length > 5
                ? 5
                : widget.historicalData.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: colorScheme.outline.withOpacity(0.5)),
            itemBuilder: (context, index) {
              final entry = widget.historicalData[index];
              return _buildTimelineEntry(entry, index);
            },
          ),

          if (widget.historicalData.length > 5) ...[
            Divider(height: 1, color: colorScheme.outline),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to full history view
                  },
                  child: Text(
                    'View All Entries (${widget.historicalData.length})',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineEntry(Map<String, dynamic> entry, int index) {
    final date = entry['date'] as String;
    final energyLevel = entry['energyLevel'] as double;
    final mood = entry['mood'] as double;
    final notes = entry['notes'] as String?;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dismissible(
      key: Key('entry_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        color: colorScheme.primary.withOpacity(0.1),
        child: CustomIconWidget(
          iconName: 'edit',
          color: colorScheme.primary,
          size: 24,
        ),
      ),
      confirmDismiss: (direction) async {
        widget.onEditEntry(entry);
        return false; // Don't actually dismiss, just trigger edit
      },
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getEnergyColor(energyLevel),
                    shape: BoxShape.circle,
                  ),
                ),
                if (index < widget.historicalData.length - 1)
                  Container(
                    width: 2,
                    height: 6.h,
                    color: colorScheme.outline.withOpacity(0.5),
                  ),
              ],
            ),
            SizedBox(width: 3.w),
            // Entry content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      CustomIconWidget(
                        iconName: 'more_horiz',
                        color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                        size: 20,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  // Optional summary
                  if (entry['summary'] != null &&
                      (entry['summary'] as String).isNotEmpty) ...[
                    Text(
                      entry['summary'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                  ],

                  // Metrics row
                  Row(
                    children: [
                      _buildMetricChip(
                        'Energy',
                        '${energyLevel.toInt()}%',
                        _getEnergyColor(energyLevel),
                      ),
                      SizedBox(width: 2.w),
                      _buildMetricChip(
                        'Mood',
                        _getMoodEmoji(mood),
                        colorScheme.primary,
                      ),
                    ],
                  ),
                  if (notes != null && notes.isNotEmpty) ...[
                    SizedBox(height: 1.h),
                    Text(
                      notes,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip(String label, String value, Color color) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 1.w),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'timeline',
            color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Entries Yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Start tracking your wellness journey by completing your first check-in.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getEnergyColor(double level) {
    final colorScheme = Theme.of(context).colorScheme;
    if (level >= 80) return colorScheme.secondary;
    if (level >= 60) return colorScheme.primary;
    if (level >= 40) return colorScheme.secondaryContainer;
    return colorScheme.error;
  }

  String _getMoodEmoji(double mood) {
    switch (mood.round()) {
      case 1:
        return '😢';
      case 2:
        return '😔';
      case 3:
        return '😐';
      case 4:
        return '😊';
      case 5:
        return '😄';
      default:
        return '😐';
    }
  }
}
