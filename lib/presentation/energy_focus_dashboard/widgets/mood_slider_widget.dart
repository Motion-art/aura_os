import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Widget for mood logging with emoji indicators and haptic feedback
class MoodSliderWidget extends StatefulWidget {
  final double currentMood;
  final ValueChanged<double> onMoodChanged;

  const MoodSliderWidget({
    super.key,
    required this.currentMood,
    required this.onMoodChanged,
  });

  @override
  State<MoodSliderWidget> createState() => _MoodSliderWidgetState();
}

class _MoodSliderWidgetState extends State<MoodSliderWidget> {
  late double _currentValue;

  final List<Map<String, dynamic>> _moodEmojis = [
    {'emoji': '😢', 'label': 'Very Low', 'value': 1.0},
    {'emoji': '😔', 'label': 'Low', 'value': 2.0},
    {'emoji': '😐', 'label': 'Neutral', 'value': 3.0},
    {'emoji': '😊', 'label': 'Good', 'value': 4.0},
    {'emoji': '😄', 'label': 'Excellent', 'value': 5.0},
  ];

  @override
  void initState() {
    super.initState();
    _currentValue = widget.currentMood;
  }

  @override
  void didUpdateWidget(MoodSliderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentMood != widget.currentMood) {
      _currentValue = widget.currentMood;
    }
  }

  void _onSliderChanged(double value) {
    setState(() {
      _currentValue = value;
    });

    // Haptic feedback on value change
    HapticFeedback.selectionClick();

    widget.onMoodChanged(value);
  }

  String _getCurrentEmoji() {
    final moodData = _moodEmojis.firstWhere(
      (mood) => (mood['value'] as double) == _currentValue.round(),
      orElse: () => _moodEmojis[2], // Default to neutral
    );
    return moodData['emoji'] as String;
  }

  String _getCurrentLabel() {
    final moodData = _moodEmojis.firstWhere(
      (mood) => (mood['value'] as double) == _currentValue.round(),
      orElse: () => _moodEmojis[2], // Default to neutral
    );
    return moodData['label'] as String;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'mood',
                color: colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'How are you feeling?',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Current mood display
          Center(
            child: Column(
              children: [
                Text(_getCurrentEmoji(), style: TextStyle(fontSize: 48)),
                SizedBox(height: 1.h),
                Text(
                  _getCurrentLabel(),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Mood slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: colorScheme.primary,
              inactiveTrackColor: colorScheme.outline,
              thumbColor: colorScheme.primary,
              overlayColor: colorScheme.primary.withOpacity(0.1),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              trackHeight: 4,
            ),
            child: Slider(
              value: _currentValue,
              min: 1.0,
              max: 5.0,
              divisions: 4,
              onChanged: _onSliderChanged,
            ),
          ),

          // Emoji indicators
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _moodEmojis.map((mood) {
                final isSelected =
                    (mood['value'] as double) == _currentValue.round();
                return GestureDetector(
                  onTap: () => _onSliderChanged(mood['value'] as double),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? colorScheme.primary.withOpacity(0.1)
                          : Colors.transparent,
                    ),
                    child: Text(
                      mood['emoji'] as String,
                      style: TextStyle(fontSize: isSelected ? 24 : 20),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
