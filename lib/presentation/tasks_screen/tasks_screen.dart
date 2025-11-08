import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/add_task_bottom_sheet.dart';
import '../../core/tasks_store.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/task_card_widget.dart';
import './widgets/task_detail_bottom_sheet.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _allTasks = [];
  List<Map<String, dynamic>> _filteredTasks = [];
  List<FilterChipData> _activeFilters = [];
  Set<String> _selectedTaskIds = {};

  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _isMultiSelectMode = false;
  bool _showSearch = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Start with current TasksStore contents (do not auto-populate mock tasks)
    _allTasks = List.from(TasksStore.tasks);
    _filteredTasks = List.from(_allTasks);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // NOTE: previous _loadMockTasks implementation removed in favor of TasksStore

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allTasks);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((task) {
        final title = (task['title'] as String? ?? '').toLowerCase();
        final description = (task['description'] as String? ?? '')
            .toLowerCase();
        return title.contains(_searchQuery) ||
            description.contains(_searchQuery);
      }).toList();
    }

    // Apply active filters
    for (final filter in _activeFilters) {
      switch (filter.type) {
        case 'priority':
          filtered = filtered
              .where((task) => task['priority'] == filter.value)
              .toList();
          break;
        case 'source':
          filtered = filtered
              .where((task) => task['source'] == filter.value)
              .toList();
          break;
        case 'dueDate':
          filtered = _filterByDueDate(filtered, filter.value as String);
          break;
      }
    }

    setState(() => _filteredTasks = filtered);
  }

  List<Map<String, dynamic>> _filterByDueDate(
    List<Map<String, dynamic>> tasks,
    String dateFilter,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return tasks.where((task) {
      final dueDate = task['dueDate'] as DateTime?;
      if (dueDate == null) return false;

      final taskDate = DateTime(dueDate.year, dueDate.month, dueDate.day);

      switch (dateFilter) {
        case 'overdue':
          return taskDate.isBefore(today) &&
              !(task['isCompleted'] as bool? ?? false);
        case 'today':
          return taskDate.isAtSameMomentAs(today);
        case 'week':
          final weekFromNow = today.add(const Duration(days: 7));
          return taskDate.isAfter(today) && taskDate.isBefore(weekFromNow);
        default:
          return true;
      }
    }).toList();
  }

  void _toggleFilter(FilterChipData filter) {
    setState(() {
      final existingIndex = _activeFilters.indexWhere((f) => f.id == filter.id);
      if (existingIndex >= 0) {
        _activeFilters.removeAt(existingIndex);
      } else {
        _activeFilters.add(filter);
      }
      _applyFilters();
    });
  }

  void _removeFilter(FilterChipData filter) {
    setState(() {
      _activeFilters.removeWhere((f) => f.id == filter.id);
      _applyFilters();
    });
  }

  void _clearAllFilters() {
    setState(() {
      _activeFilters.clear();
      _searchController.clear();
      _searchQuery = '';
      _applyFilters();
    });
  }

  Future<void> _refreshTasks() async {
    setState(() => _isRefreshing = true);

    // Simulate refresh delay
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() => _isRefreshing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tasks synced successfully'),
          backgroundColor: AppTheme.accentGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _toggleTaskSelection(String taskId) {
    setState(() {
      if (_selectedTaskIds.contains(taskId)) {
        _selectedTaskIds.remove(taskId);
        if (_selectedTaskIds.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _selectedTaskIds.add(taskId);
        _isMultiSelectMode = true;
      }
    });
  }

  void _exitMultiSelectMode() {
    setState(() {
      _selectedTaskIds.clear();
      _isMultiSelectMode = false;
    });
  }

  void _completeTask(String taskId) {
    HapticFeedback.lightImpact();
    setState(() {
      // update the in-memory store
      final storeIndex = TasksStore.tasks.indexWhere((t) => t['id'] == taskId);
      if (storeIndex >= 0) {
        TasksStore.tasks[storeIndex]['isCompleted'] = true;
        TasksStore.tasks[storeIndex]['updatedAt'] = DateTime.now();
      }

      _allTasks = List.from(TasksStore.tasks);
      _applyFilters();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task completed!'),
        backgroundColor: AppTheme.accentGreen,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppTheme.surfaceWhite,
          onPressed: () => _undoCompleteTask(taskId),
        ),
      ),
    );
  }

  void _undoCompleteTask(String taskId) {
    setState(() {
      final storeIndex = TasksStore.tasks.indexWhere((t) => t['id'] == taskId);
      if (storeIndex >= 0) {
        TasksStore.tasks[storeIndex]['isCompleted'] = false;
        TasksStore.tasks[storeIndex]['updatedAt'] = DateTime.now();
      }

      _allTasks = List.from(TasksStore.tasks);
      _applyFilters();
    });
  }

  void _deleteTask(String taskId) {
    final task = _allTasks.firstWhere((t) => t['id'] == taskId);
    setState(() {
      // remove from store
      TasksStore.removeTask(taskId);
      _allTasks = List.from(TasksStore.tasks);
      _applyFilters();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${task['title']}" deleted'),
        backgroundColor: AppTheme.errorRed,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppTheme.surfaceWhite,
          onPressed: () {
            setState(() {
              // re-add task to store
              TasksStore.addTask(task);
              _allTasks = List.from(TasksStore.tasks);
              _applyFilters();
            });
          },
        ),
      ),
    );
  }

  void _shareTask(String taskId) {
    final task = _allTasks.firstWhere((t) => t['id'] == taskId);
    // Simulate sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing "${task['title']}"...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addTask(Map<String, dynamic> newTask) {
    // Persist to the in-memory TasksStore so it remains while the app runs
    TasksStore.addTask(newTask);
    setState(() {
      _allTasks = List.from(TasksStore.tasks);
      _applyFilters();
    });
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddTaskBottomSheet(onTaskAdded: _addTask),
      ),
    );
  }

  void _showTaskDetails(Map<String, dynamic> task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: TaskDetailBottomSheet(
          task: task,
          onEdit: () {
            // Open add/edit sheet prefilled - reuse existing sheet flow if available
            _showAddTaskBottomSheet();
          },
          onDelete: () {
            final id = task['id'] as String;
            _deleteTask(id);
          },
          onComplete: () {
            final id = task['id'] as String;
            _completeTask(id);
          },
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Filter Tasks',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),

          // Filter sections
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection(
                    'Priority',
                    FilterChipData.priorityFilters,
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    'Due Date',
                    FilterChipData.dueDateFilters,
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection('Source', FilterChipData.sourceFilters),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<FilterChipData> filters) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: filters.map((filter) {
            final isActive = _activeFilters.any((f) => f.id == filter.id);
            final count = _getFilterCount(filter);

            return FilterChipWidget(
              label: filter.label,
              count: count,
              isSelected: isActive,
              icon: filter.icon,
              color: filter.color,
              onTap: () => _toggleFilter(filter),
            );
          }).toList(),
        ),
      ],
    );
  }

  int _getFilterCount(FilterChipData filter) {
    switch (filter.type) {
      case 'priority':
        return _allTasks
            .where((task) => task['priority'] == filter.value)
            .length;
      case 'source':
        return _allTasks.where((task) => task['source'] == filter.value).length;
      case 'dueDate':
        return _filterByDueDate(_allTasks, filter.value as String).length;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: _showSearch
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search tasks...',
                  border: InputBorder.none,
                ),
                style: theme.textTheme.titleMedium,
              )
            : Text(
                _isMultiSelectMode
                    ? '${_selectedTaskIds.length} selected'
                    : 'Tasks',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
        actions: [
          if (_isMultiSelectMode) ...[
            IconButton(
              onPressed: _exitMultiSelectMode,
              icon: CustomIconWidget(
                iconName: 'close',
                size: 24,
                color: colorScheme.onSurface,
              ),
            ),
          ] else if (_showSearch) ...[
            IconButton(
              onPressed: () {
                setState(() {
                  _showSearch = false;
                  _searchController.clear();
                  _searchQuery = '';
                  _applyFilters();
                });
              },
              icon: CustomIconWidget(
                iconName: 'close',
                size: 24,
                color: colorScheme.onSurface,
              ),
            ),
          ] else ...[
            IconButton(
              onPressed: () => setState(() => _showSearch = true),
              icon: CustomIconWidget(
                iconName: 'search',
                size: 24,
                color: colorScheme.onSurface,
              ),
            ),
            IconButton(
              onPressed: _showFilterBottomSheet,
              icon: Stack(
                children: [
                  CustomIconWidget(
                    iconName: 'filter_list',
                    size: 24,
                    color: colorScheme.onSurface,
                  ),
                  if (_activeFilters.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.errorRed,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Active filters
          if (_activeFilters.isNotEmpty)
            Container(
              height: 6.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _activeFilters.length,
                itemBuilder: (context, index) {
                  final filter = _activeFilters[index];
                  return FilterChipWidget(
                    label: filter.label,
                    isSelected: true,
                    icon: filter.icon,
                    color: filter.color,
                    onRemove: () => _removeFilter(filter),
                  );
                },
              ),
            ),

          // Multi-select toolbar
          if (_isMultiSelectMode)
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      for (final taskId in _selectedTaskIds) {
                        _completeTask(taskId);
                      }
                      _exitMultiSelectMode();
                    },
                    icon: CustomIconWidget(
                      iconName: 'check',
                      size: 18,
                      color: AppTheme.accentGreen,
                    ),
                    label: const Text('Complete'),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      for (final taskId in _selectedTaskIds) {
                        _deleteTask(taskId);
                      }
                      _exitMultiSelectMode();
                    },
                    icon: CustomIconWidget(
                      iconName: 'delete',
                      size: 18,
                      color: AppTheme.errorRed,
                    ),
                    label: const Text('Delete'),
                  ),
                ],
              ),
            ),

          // Task list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredTasks.isEmpty
                ? EmptyStateWidget(onAddTask: _showAddTaskBottomSheet)
                : RefreshIndicator(
                    onRefresh: _refreshTasks,
                    color: AppTheme.primaryBlue,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = _filteredTasks[index];
                        final taskId = task['id'] as String;

                        return TaskCardWidget(
                          task: task,
                          isSelected: _selectedTaskIds.contains(taskId),
                          onTap: _isMultiSelectMode
                              ? () => _toggleTaskSelection(taskId)
                              : () => _showTaskDetails(task),
                          onComplete: () => _completeTask(taskId),
                          onEdit: () {
                            // TODO: Implement edit functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Edit functionality coming soon'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          onDelete: () => _deleteTask(taskId),
                          onShare: () => _shareTask(taskId),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: _isMultiSelectMode || _filteredTasks.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: _showAddTaskBottomSheet,
              child: CustomIconWidget(
                iconName: 'add',
                size: 24,
                color: AppTheme.surfaceWhite,
              ),
            ),
      bottomNavigationBar: CustomBottomBar.productivity(
        currentIndex: 1, // Tasks tab
        context: context,
      ),
    );
  }
}
