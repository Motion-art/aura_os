import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/daily_checkin_widget.dart';
import './widgets/date_navigation_widget.dart';
import './widgets/energy_progress_widget.dart';
import './widgets/historical_timeline_widget.dart';
import './widgets/mood_slider_widget.dart';
import './widgets/wellness_chart_widget.dart';

/// Energy & Focus Dashboard screen for comprehensive wellness tracking
class EnergyFocusDashboard extends StatefulWidget {
  const EnergyFocusDashboard({super.key});

  @override
  State<EnergyFocusDashboard> createState() => _EnergyFocusDashboardState();
}

class _EnergyFocusDashboardState extends State<EnergyFocusDashboard>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  double _currentEnergyLevel = 75.0;
  double _currentMood = 4.0;
  bool _hasCheckedInToday = false;
  bool _isRefreshing = false;

  // Mock data for charts and historical entries
  final List<Map<String, dynamic>> _weeklyEnergyData = [
    {'label': 'Mon', 'value': 65},
    {'label': 'Tue', 'value': 78},
    {'label': 'Wed', 'value': 82},
    {'label': 'Thu', 'value': 71},
    {'label': 'Fri', 'value': 88},
    {'label': 'Sat', 'value': 92},
    {'label': 'Sun', 'value': 75},
  ];

  final List<Map<String, dynamic>> _monthlyFocusData = [
    {'label': 'Week 1', 'value': 72},
    {'label': 'Week 2', 'value': 85},
    {'label': 'Week 3', 'value': 79},
    {'label': 'Week 4', 'value': 91},
  ];

  final List<Map<String, dynamic>> _historicalEntries = [
    {
      'date': 'Oct 19, 2025',
      'energyLevel': 85.0,
      'mood': 4.0,
      'notes':
          'Great productive day! Completed all major tasks and felt energized throughout.',
    },
    {
      'date': 'Oct 18, 2025',
      'energyLevel': 72.0,
      'mood': 3.0,
      'notes':
          'Moderate energy levels. Had some challenges with focus in the afternoon.',
    },
    {
      'date': 'Oct 17, 2025',
      'energyLevel': 91.0,
      'mood': 5.0,
      'notes': 'Excellent day! Perfect work-life balance and high motivation.',
    },
    {
      'date': 'Oct 16, 2025',
      'energyLevel': 68.0,
      'mood': 3.0,
      'notes':
          'Lower energy due to poor sleep. Need to improve sleep schedule.',
    },
    {
      'date': 'Oct 15, 2025',
      'energyLevel': 79.0,
      'mood': 4.0,
      'notes':
          'Good recovery day. Took adequate breaks and practiced mindfulness.',
    },
  ];
  String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  double _deriveMood(
    double energy,
    double focus,
    double stress,
    double motivation,
  ) {
    // Combine metrics into a 1-5 mood scale. Higher stress reduces mood.
    final adjustedStress = (100 - stress).clamp(0.0, 100.0);
    final avg = (energy + focus + adjustedStress + motivation) / 4.0; // 0-100
    // Map 0-100 into 1-5
    final mood = (avg / 100.0) * 4.0 + 1.0;
    return mood.clamp(1.0, 5.0);
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

  @override
  void dispose() {
    _scrollController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _loadTodayData() {
    // Simulate loading today's data
    setState(() {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final selectedDay = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );

      if (selectedDay == today) {
        _currentEnergyLevel = 75.0;
        _currentMood = 4.0;
        _hasCheckedInToday = false;
      } else {
        // Load historical data for selected date
        final entry = _historicalEntries.firstWhere(
          (entry) => entry['date'].toString().contains('${_selectedDate.day}'),
          orElse: () => {'energyLevel': 70.0, 'mood': 3.0},
        );
        _currentEnergyLevel = entry['energyLevel'] as double;
        _currentMood = entry['mood'] as double;
        _hasCheckedInToday = true;
      }
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    _loadTodayData();

    setState(() {
      _isRefreshing = false;
    });
  }

  void _updateEnergyLevel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildEnergyUpdateModal(),
    );
  }

  void _onMoodChanged(double mood) {
    setState(() {
      _currentMood = mood;
      // Update historical entries when mood changes (light-weight entry)
      final now = DateTime.now();
      final summ =
          'Mood ${_getMoodEmoji(mood)} • Energy ${_currentEnergyLevel.toInt()}%';
      _historicalEntries.insert(0, {
        'date': _formatDate(now),
        'energyLevel': _currentEnergyLevel,
        'mood': mood,
        'notes': 'Mood updated',
        'summary': summ,
      });
    });
  }

  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    _loadTodayData();
  }

  void _onTodayPressed() {
    setState(() {
      _selectedDate = DateTime.now();
    });
    _loadTodayData();
  }

  void _openDetailedLogging() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildDetailedLoggingModal(),
    );
  }

  void _openCheckinModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCheckinModal(),
    );
  }

  void _editHistoricalEntry(Map<String, dynamic> entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildEditEntryModal(entry),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: colorScheme.primary,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Date navigation bar (now scrollable)
                DateNavigationWidget(
                  selectedDate: _selectedDate,
                  onDateChanged: _onDateChanged,
                  onTodayPressed: _onTodayPressed,
                ),
                SizedBox(height: 3.h),
                // Energy progress indicator
                EnergyProgressWidget(
                  energyLevel: _currentEnergyLevel,
                  onTap: _updateEnergyLevel,
                ),
                SizedBox(height: 4.h),
                // Mood slider
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: MoodSliderWidget(
                    currentMood: _currentMood,
                    onMoodChanged: _onMoodChanged,
                  ),
                ),
                SizedBox(height: 4.h),
                // Weekly energy chart
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: WellnessChartWidget(
                    chartType: 'line',
                    chartData: _weeklyEnergyData,
                    title: 'Weekly Energy Trends',
                  ),
                ),
                SizedBox(height: 4.h),
                // Monthly focus chart
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: WellnessChartWidget(
                    chartType: 'bar',
                    chartData: _monthlyFocusData,
                    title: 'Monthly Focus Duration',
                  ),
                ),
                SizedBox(height: 4.h),
                // Daily check-in card
                DailyCheckinWidget(
                  hasCheckedInToday: _hasCheckedInToday,
                  onCheckinTap: _openCheckinModal,
                ),
                SizedBox(height: 4.h),
                // Historical timeline
                HistoricalTimelineWidget(
                  historicalData: _historicalEntries,
                  onEditEntry: _editHistoricalEntry,
                ),
                SizedBox(height: 10.h), // Bottom padding for FAB
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openDetailedLogging,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: CustomIconWidget(
          iconName: 'add',
          color: colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          'Log Entry',
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar.productivity(
        currentIndex: 3, // Energy & Focus Dashboard index
        context: context,
      ),
    );
  }

  Widget _buildEnergyUpdateModal() {
    double tempEnergyLevel = _currentEnergyLevel;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 4.h),
          Slider(
            value: tempEnergyLevel,
            min: 0,
            max: 100,
            divisions: 20,
            onChanged: (value) {
              setState(() {
                tempEnergyLevel = value;
              });
            },
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentEnergyLevel = tempEnergyLevel;
                      // Add a historical entry when energy is updated
                      final now = DateTime.now();
                      final mood = _deriveMood(
                        tempEnergyLevel,
                        75.0,
                        30.0,
                        _currentMood,
                      );
                      final summary =
                          'Energy ${tempEnergyLevel.toInt()}% • ${_getMoodEmoji(mood)}';
                      _historicalEntries.insert(0, {
                        'date': _formatDate(now),
                        'energyLevel': tempEnergyLevel,
                        'mood': mood,
                        'notes': 'Energy level updated',
                        'summary': summary,
                      });
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Energy level updated'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('Update'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedLoggingModal() {
    double tempEnergy = _currentEnergyLevel;
    double tempFocus = 75.0;
    double tempStress = 30.0;
    double tempMotivation = 80.0;
    final notesController = TextEditingController();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detailed Wellness Log',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Energy slider
                  StatefulBuilder(
                    builder: (context, setModalState) {
                      return _buildMetricSlider('Energy Level', tempEnergy, (
                        value,
                      ) {
                        setModalState(() {
                          tempEnergy = value;
                        });
                      });
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Focus slider
                  StatefulBuilder(
                    builder: (context, setModalState) {
                      return _buildMetricSlider('Focus Duration', tempFocus, (
                        value,
                      ) {
                        setModalState(() {
                          tempFocus = value;
                        });
                      });
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Stress slider
                  StatefulBuilder(
                    builder: (context, setModalState) {
                      return _buildMetricSlider('Stress Level', tempStress, (
                        value,
                      ) {
                        setModalState(() {
                          tempStress = value;
                        });
                      });
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Motivation slider
                  StatefulBuilder(
                    builder: (context, setModalState) {
                      return _buildMetricSlider('Motivation', tempMotivation, (
                        value,
                      ) {
                        setModalState(() {
                          tempMotivation = value;
                        });
                      });
                    },
                  ),

                  SizedBox(height: 4.h),

                  // Notes section
                  Text(
                    'Notes (Optional)',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  // collect notes through a controller so we can store them in the entry
                  StatefulBuilder(
                    builder: (ctx, setModalState) {
                      return Column(
                        children: [
                          TextField(
                            controller: _notesController,
                            maxLines: 4,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  'How was your day? Any insights or challenges?',
                              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: colorScheme.surface,
                            ),
                          ),

                          SizedBox(height: 4.h),

                          // Action buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _currentEnergyLevel = tempEnergy;
                                      _hasCheckedInToday = true;
                                    });
                                    // Add the new entry to historical entries with formatted date, derived mood and a summary
                                    final now = DateTime.now();
                                    final mood = _deriveMood(
                                      tempEnergy,
                                      tempFocus,
                                      tempStress,
                                      tempMotivation,
                                    );
                                    final notesText = _notesController.text
                                        .trim();
                                    // If the user provided notes, use the first line (truncated) as the summary; otherwise use metric summary
                                    String summary;
                                    if (notesText.isNotEmpty) {
                                      final firstLine = notesText
                                          .split('\n')
                                          .first;
                                      summary = firstLine.length > 80
                                          ? '${firstLine.substring(0, 80)}...'
                                          : firstLine;
                                    } else {
                                      summary =
                                          'Energy ${tempEnergy.toInt()}% • ${_getMoodEmoji(mood)} • Focus ${tempFocus.toInt()}%';
                                    }
                                    _historicalEntries.insert(0, {
                                      'date': _formatDate(now),
                                      'energyLevel': tempEnergy,
                                      'mood': mood,
                                      'notes': notesText.isNotEmpty
                                          ? notesText
                                          : null,
                                      'summary': summary,
                                    });
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Entry logged successfully',
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  child: const Text('Save Entry'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckinModal() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Wellness Check-in',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  Text(
                    'Take a moment to reflect on your day and wellbeing.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Sample check-in questions
                  _buildCheckinQuestion(
                    'How productive did you feel today?',
                    'trending_up',
                  ),

                  SizedBox(height: 3.h),

                  _buildCheckinQuestion(
                    'Did you take adequate breaks?',
                    'coffee',
                  ),

                  SizedBox(height: 3.h),

                  _buildCheckinQuestion(
                    'How was your work-life balance?',
                    'balance',
                  ),

                  SizedBox(height: 4.h),

                  // Complete check-in button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _hasCheckedInToday = true;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 3.h),
                      ),
                      child: const Text('Complete Check-in'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditEntryModal(Map<String, dynamic> entry) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Entry - ${entry['date']}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Energy Level: ${(entry['energyLevel'] as double).toInt()}%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Mood: ${_getMoodLabel(entry['mood'] as double)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  if (entry['notes'] != null) ...[
                    Text(
                      'Notes:',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      entry['notes'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Open edit form with the selected entry
                            _openEditForm(entry);
                          },
                          child: const Text('Edit'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openEditForm(Map<String, dynamic> entry) {
    // Open an edit modal to tweak energy and notes. We'll derive mood on save.
    double tempEnergy =
        (entry['energyLevel'] as double?) ?? _currentEnergyLevel;
    double tempFocus = (entry['focus'] as double?) ?? 75.0;
    double tempStress = (entry['stress'] as double?) ?? 30.0;
    double tempMotivation = (entry['motivation'] as double?) ?? 80.0;
    final notesController = TextEditingController(
      text: entry['notes'] as String? ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        return Container(
          height: 70.h,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Entry - ${entry['date']}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),

                Text(
                  'Energy',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Slider(
                  value: tempEnergy,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  activeColor: colorScheme.primary,
                  onChanged: (v) => tempEnergy = v,
                ),

                SizedBox(height: 1.h),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Edit notes',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // compute new mood and summary
                          final mood = _deriveMood(
                            tempEnergy,
                            tempFocus,
                            tempStress,
                            tempMotivation,
                          );
                          final summary =
                              'Energy ${tempEnergy.toInt()}% • ${_getMoodEmoji(mood)}';

                          final idx = _historicalEntries.indexWhere(
                            (e) => e['date'] == entry['date'],
                          );
                          if (idx != -1) {
                            setState(() {
                              _historicalEntries[idx]['energyLevel'] =
                                  tempEnergy;
                              _historicalEntries[idx]['mood'] = mood;
                              _historicalEntries[idx]['notes'] = notesController
                                  .text
                                  .trim();
                              _historicalEntries[idx]['summary'] = summary;
                              _historicalEntries[idx]['modifiedAt'] =
                                  DateTime.now();
                            });
                          }
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Entry updated'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricSlider(
    String label,
    double value,
    ValueChanged<double> onChanged,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              '${value.toInt()}%',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: colorScheme.primary,
            inactiveTrackColor: colorScheme.outline,
            thumbColor: colorScheme.primary,
            overlayColor: colorScheme.primary.withValues(alpha: 0.1),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            divisions: 20,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckinQuestion(String question, String iconName) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: colorScheme.primary,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              question,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMoodLabel(double mood) {
    switch (mood.round()) {
      case 1:
        return 'Very Low 😢';
      case 2:
        return 'Low 😔';
      case 3:
        return 'Neutral 😐';
      case 4:
        return 'Good 😊';
      case 5:
        return 'Excellent 😄';
      default:
        return 'Neutral 😐';
    }
  }
}
