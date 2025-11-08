import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Widget for daily check-in prompts and questionnaire
class DailyCheckinWidget extends StatefulWidget {
  final bool hasCheckedInToday;
  final VoidCallback onCheckinTap;

  const DailyCheckinWidget({
    super.key,
    required this.hasCheckedInToday,
    required this.onCheckinTap,
  });

  @override
  State<DailyCheckinWidget> createState() => _DailyCheckinWidgetState();
}

class _DailyCheckinWidgetState extends State<DailyCheckinWidget> {
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _checkinQuestions = [
    {
      'question': 'How productive did you feel today?',
      'type': 'scale',
      'icon': 'trending_up',
    },
    {
      'question': 'Did you take adequate breaks?',
      'type': 'boolean',
      'icon': 'coffee',
    },
    {
      'question': 'How was your work-life balance?',
      'type': 'scale',
      'icon': 'balance',
    },
    {
      'question': 'Any challenges you faced today?',
      'type': 'text',
      'icon': 'help_outline',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.light
                ? theme.shadowColor.withOpacity(0.08)
                : theme.shadowColor.withOpacity(0.18),
            blurRadius: theme.brightness == Brightness.light ? 4 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header section
          GestureDetector(
            onTap: () {
              if (!widget.hasCheckedInToday) {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              } else {
                widget.onCheckinTap();
              }
            },
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: widget.hasCheckedInToday
                          ? colorScheme.secondary.withOpacity(0.1)
                          : colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: widget.hasCheckedInToday
                          ? 'check_circle'
                          : 'psychology',
                      color: widget.hasCheckedInToday
                          ? colorScheme.secondary
                          : colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.hasCheckedInToday
                              ? 'Daily Check-in Complete'
                              : 'Daily Wellness Check-in',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          widget.hasCheckedInToday
                              ? 'Great job! You\'ve completed today\'s check-in.'
                              : 'Take a moment to reflect on your day and wellbeing.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!widget.hasCheckedInToday)
                    CustomIconWidget(
                      iconName: _isExpanded ? 'expand_less' : 'expand_more',
                      color: colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                ],
              ),
            ),
          ),

          // Expanded questionnaire section
          if (_isExpanded && !widget.hasCheckedInToday) ...[
            Divider(height: 1, color: colorScheme.outline),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Reflection',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Questions preview
                  ...(_checkinQuestions.take(2).map((question) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: question['icon'] as String,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              question['question'] as String,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList()),

                  Text(
                    '+${_checkinQuestions.length - 2} more questions',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Start check-in button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onCheckinTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: EdgeInsets.symmetric(vertical: 3.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'play_arrow',
                            color: colorScheme.onPrimary,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Start Check-in',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Completed state action
          if (widget.hasCheckedInToday) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onCheckinTap,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                        side: BorderSide(color: colorScheme.outline),
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'View Details',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
