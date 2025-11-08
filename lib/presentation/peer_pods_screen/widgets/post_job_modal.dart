import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PostJobModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onPostJob;

  const PostJobModal({
    super.key,
    required this.onPostJob,
  });

  @override
  State<PostJobModal> createState() => _PostJobModalState();
}

class _PostJobModalState extends State<PostJobModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedDuration = '1 week';
  String _selectedAccountabilityType = 'Check-ins';

  final List<String> _durationOptions = [
    '1 day',
    '3 days',
    '1 week',
    '2 weeks',
    '1 month',
    '3 months',
    'Ongoing',
  ];

  final List<String> _accountabilityTypes = [
    'Check-ins',
    'Milestone tracking',
    'Habit formation',
    'Goal completion',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Post Job',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(
                  onPressed: _postJob,
                  child: Text(
                    'Post',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Job Details',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Job Title',
                        hintText: 'What do you need accountability for?',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a job title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 2.h),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText:
                            'Provide details about what you need help with',
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Duration',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colorScheme.outline,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedDuration,
                          isExpanded: true,
                          items: _durationOptions.map((duration) {
                            return DropdownMenuItem<String>(
                              value: duration,
                              child: Text(
                                duration,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedDuration = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Accountability Type',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...(_accountabilityTypes
                        .map((type) =>
                            _buildAccountabilityTypeOption(context, type))
                        .toList()),
                    SizedBox(height: 3.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'info',
                                color: AppTheme.primaryBlue,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'How it works',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: AppTheme.primaryBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Your job will be visible to your network. When someone accepts, they\'ll help keep you accountable through regular check-ins and support.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountabilityTypeOption(BuildContext context, String type) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _selectedAccountabilityType == type;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Material(
        color: isSelected
            ? AppTheme.primaryBlue.withValues(alpha: 0.1)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedAccountabilityType = type;
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryBlue
                    : colorScheme.outline.withValues(alpha: 0.2),
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Radio<String>(
                  value: type,
                  groupValue: _selectedAccountabilityType,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedAccountabilityType = value;
                      });
                    }
                  },
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _getAccountabilityTypeDescription(type),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getAccountabilityTypeDescription(String type) {
    switch (type) {
      case 'Check-ins':
        return 'Regular progress updates and encouragement';
      case 'Milestone tracking':
        return 'Track specific goals and deadlines';
      case 'Habit formation':
        return 'Build consistent daily or weekly habits';
      case 'Goal completion':
        return 'Stay focused on completing a specific objective';
      default:
        return 'General accountability support';
    }
  }

  void _postJob() {
    if (_formKey.currentState?.validate() ?? false) {
      final jobData = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'duration': _selectedDuration,
        'accountabilityType': _selectedAccountabilityType,
        'requesterName': 'You',
        'requesterAvatar': null,
        'requesterSemanticLabel': 'Your profile avatar',
        'timePosted': 'Just now',
        'rating': 'New',
        'postedAt': DateTime.now().toIso8601String(),
      };

      widget.onPostJob(jobData);
      Navigator.pop(context);
    }
  }
}
