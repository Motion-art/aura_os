import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final List<String> selectedTags;
  final String selectedSortBy;
  final bool showFavoritesOnly;
  final bool showArchivedNotes;
  final ValueChanged<List<String>> onTagsChanged;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<bool> onFavoritesChanged;
  final ValueChanged<bool> onArchivedChanged;
  final VoidCallback onReset;
  final VoidCallback onApply;

  const FilterBottomSheetWidget({
    super.key,
    required this.selectedTags,
    required this.selectedSortBy,
    required this.showFavoritesOnly,
    required this.showArchivedNotes,
    required this.onTagsChanged,
    required this.onSortChanged,
    required this.onFavoritesChanged,
    required this.onArchivedChanged,
    required this.onReset,
    required this.onApply,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late List<String> _selectedTags;
  late String _selectedSortBy;
  late bool _showFavoritesOnly;
  late bool _showArchivedNotes;

  final List<String> _availableTags = [
    'work',
    'personal',
    'ideas',
    'meeting',
    'project',
    'learning',
    'research',
    'todo',
    'important',
    'draft',
    'review',
    'inspiration'
  ];

  final List<Map<String, String>> _sortOptions = [
    {'value': 'date_desc', 'label': 'Newest First'},
    {'value': 'date_asc', 'label': 'Oldest First'},
    {'value': 'title_asc', 'label': 'Title A-Z'},
    {'value': 'title_desc', 'label': 'Title Z-A'},
    {'value': 'modified', 'label': 'Recently Modified'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.selectedTags);
    _selectedSortBy = widget.selectedSortBy;
    _showFavoritesOnly = widget.showFavoritesOnly;
    _showArchivedNotes = widget.showArchivedNotes;
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedTags.clear();
      _selectedSortBy = 'date_desc';
      _showFavoritesOnly = false;
      _showArchivedNotes = false;
    });
  }

  void _applyFilters() {
    widget.onTagsChanged(_selectedTags);
    widget.onSortChanged(_selectedSortBy);
    widget.onFavoritesChanged(_showFavoritesOnly);
    widget.onArchivedChanged(_showArchivedNotes);
    widget.onApply();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
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
                  'Filter & Sort',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    'Reset',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sort by section
                  _buildSectionTitle('Sort By'),
                  SizedBox(height: 2.h),
                  ..._sortOptions
                      .map((option) => _buildSortOption(
                            option['value']!,
                            option['label']!,
                          ))
                      .toList(),

                  SizedBox(height: 3.h),

                  // Filter options
                  _buildSectionTitle('Show'),
                  SizedBox(height: 2.h),
                  _buildSwitchOption(
                    'Favorites Only',
                    _showFavoritesOnly,
                    (value) => setState(() => _showFavoritesOnly = value),
                    'favorite',
                  ),
                  _buildSwitchOption(
                    'Include Archived',
                    _showArchivedNotes,
                    (value) => setState(() => _showArchivedNotes = value),
                    'archive',
                  ),

                  SizedBox(height: 3.h),

                  // Tags section
                  _buildSectionTitle('Filter by Tags'),
                  SizedBox(height: 2.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _availableTags
                        .map((tag) => _buildTagChip(tag))
                        .toList(),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Apply button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: AppTheme.surfaceWhite,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Apply Filters',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.surfaceWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSortOption(String value, String label) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _selectedSortBy == value;

    return InkWell(
      onTap: () => setState(() => _selectedSortBy = value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 3.w,
          vertical: 2.h,
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: isSelected
                  ? 'radio_button_checked'
                  : 'radio_button_unchecked',
              color: isSelected
                  ? AppTheme.primaryBlue
                  : colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    isSelected ? AppTheme.primaryBlue : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchOption(
      String title, bool value, ValueChanged<bool> onChanged, String iconName) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 3.w,
        vertical: 1.h,
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: value ? AppTheme.primaryBlue : colorScheme.onSurfaceVariant,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _selectedTags.contains(tag);

    return InkWell(
      onTap: () => _toggleTag(tag),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 3.w,
          vertical: 1.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryBlue.withValues(alpha: 0.1)
              : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlue : AppTheme.borderSubtle,
            width: 1,
          ),
        ),
        child: Text(
          '#$tag',
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected ? AppTheme.primaryBlue : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
