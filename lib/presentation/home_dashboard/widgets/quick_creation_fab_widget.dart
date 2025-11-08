import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Floating Action Button widget for quick content creation
class QuickCreationFabWidget extends StatefulWidget {
  const QuickCreationFabWidget({super.key});

  @override
  State<QuickCreationFabWidget> createState() => _QuickCreationFabWidgetState();
}

class _QuickCreationFabWidgetState extends State<QuickCreationFabWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Backdrop
        if (_isExpanded)
          GestureDetector(
            onTap: _toggleExpanded,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withValues(alpha: 0.3),
            ),
          ),

        // Quick action buttons
        AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_expandAnimation.value > 0) ...[
                  Transform.scale(
                    scale: _expandAnimation.value,
                    child: Opacity(
                      opacity: _expandAnimation.value,
                      child: _buildQuickActionButton(
                        label: 'Add Task',
                        icon: 'add_task',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        onPressed: () => _showQuickCreateModal(context, 'task'),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Transform.scale(
                    scale: _expandAnimation.value,
                    child: Opacity(
                      opacity: _expandAnimation.value,
                      child: _buildQuickActionButton(
                        label: 'Create Note',
                        icon: 'note_add',
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        onPressed: () => _showQuickCreateModal(context, 'note'),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Transform.scale(
                    scale: _expandAnimation.value,
                    child: Opacity(
                      opacity: _expandAnimation.value,
                      child: _buildQuickActionButton(
                        label: 'Log Energy',
                        icon: 'bolt',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        onPressed: () =>
                            _showQuickCreateModal(context, 'energy'),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Transform.scale(
                    scale: _expandAnimation.value,
                    child: Opacity(
                      opacity: _expandAnimation.value,
                      child: _buildQuickActionButton(
                        label: 'Post Challenge',
                        icon: 'campaign',
                        color: AppTheme.lightTheme.colorScheme.error,
                        onPressed: () =>
                            _showQuickCreateModal(context, 'challenge'),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],

                // Main FAB
                FloatingActionButton(
                  onPressed: _toggleExpanded,
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  child: AnimatedRotation(
                    turns: _isExpanded ? 0.125 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: CustomIconWidget(
                      iconName: _isExpanded ? 'close' : 'add',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 24,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required String label,
    required String icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.shadowColor,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 2.w),
        FloatingActionButton.small(
          onPressed: onPressed,
          backgroundColor: color,
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
          heroTag: label,
          child: CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 20,
          ),
        ),
      ],
    );
  }

  void _showQuickCreateModal(BuildContext context, String type) {
    _toggleExpanded(); // Close the FAB menu

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _QuickCreateModal(type: type),
    );
  }
}

/// Modal for quick content creation
class _QuickCreateModal extends StatefulWidget {
  final String type;

  const _QuickCreateModal({required this.type});

  @override
  State<_QuickCreateModal> createState() => _QuickCreateModalState();
}

class _QuickCreateModalState extends State<_QuickCreateModal> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _priority = 'Medium';
  double _energyLevel = 5.0;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getModalTitle(),
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: _buildModalContent(),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleCreate,
                    child: const Text('Create'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getModalTitle() {
    switch (widget.type) {
      case 'task':
        return 'Add Task';
      case 'note':
        return 'Create Note';
      case 'energy':
        return 'Log Energy';
      case 'challenge':
        return 'Post Challenge';
      default:
        return 'Quick Create';
    }
  }

  Widget _buildModalContent() {
    switch (widget.type) {
      case 'task':
        return _buildTaskForm();
      case 'note':
        return _buildNoteForm();
      case 'energy':
        return _buildEnergyForm();
      case 'challenge':
        return _buildChallengeForm();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTaskForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Task Title',
            hintText: 'Enter task title...',
          ),
        ),
        SizedBox(height: 2.h),
        TextField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Description (Optional)',
            hintText: 'Add task details...',
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Priority',
          style: AppTheme.lightTheme.textTheme.labelLarge,
        ),
        SizedBox(height: 1.h),
        DropdownButtonFormField<String>(
          value: _priority,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: ['Low', 'Medium', 'High', 'Urgent']
              .map((priority) => DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _priority = value;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildNoteForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Note Title',
            hintText: 'Enter note title...',
          ),
        ),
        SizedBox(height: 2.h),
        TextField(
          controller: _descriptionController,
          maxLines: 8,
          decoration: const InputDecoration(
            labelText: 'Content',
            hintText: 'Start writing your note...',
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }

  Widget _buildEnergyForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Energy Level',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        Text(
          'Current Level: ${_energyLevel.round()}/10',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Slider(
          value: _energyLevel,
          min: 1,
          max: 10,
          divisions: 9,
          onChanged: (value) {
            setState(() {
              _energyLevel = value;
            });
          },
        ),
        SizedBox(height: 2.h),
        TextField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Notes (Optional)',
            hintText: 'How are you feeling today?',
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Challenge Title',
            hintText: 'What challenge are you facing?',
          ),
        ),
        SizedBox(height: 2.h),
        TextField(
          controller: _descriptionController,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: 'Description',
            hintText:
                'Describe your challenge and what kind of support you need...',
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }

  void _handleCreate() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    // Handle creation based on type
    String message = '';
    switch (widget.type) {
      case 'task':
        message = 'Task created successfully!';
        break;
      case 'note':
        message = 'Note saved successfully!';
        break;
      case 'energy':
        message = 'Energy level logged!';
        break;
      case 'challenge':
        message = 'Challenge posted to feed!';
        break;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
