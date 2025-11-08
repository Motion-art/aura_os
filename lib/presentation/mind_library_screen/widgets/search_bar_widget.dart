import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilterTap;
  final List<String> recentQueries;
  final ValueChanged<String>? onRecentQueryTap;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Search notes...',
    required this.onChanged,
    this.onFilterTap,
    this.recentQueries = const [],
    this.onRecentQueryTap,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showRecentQueries = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _showRecentQueries =
          _focusNode.hasFocus &&
          _controller.text.isEmpty &&
          widget.recentQueries.isNotEmpty;
    });
  }

  void _onTextChanged(String value) {
    widget.onChanged(value);
    setState(() {
      _showRecentQueries =
          _focusNode.hasFocus &&
          value.isEmpty &&
          widget.recentQueries.isNotEmpty;
    });
  }

  void _onRecentQuerySelected(String query) {
    _controller.text = query;
    widget.onChanged(query);
    _focusNode.unfocus();
    if (widget.onRecentQueryTap != null) {
      widget.onRecentQueryTap!(query);
    }
  }

  void _clearSearch() {
    _controller.clear();
    widget.onChanged('');
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          height: 6.h,
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _focusNode.hasFocus
                  ? colorScheme.primary
                  : colorScheme.outline,
              width: _focusNode.hasFocus ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Search icon
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),

              // Search input
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: _onTextChanged,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.5.h,
                    ),
                  ),
                ),
              ),

              // Clear button
              if (_controller.text.isNotEmpty)
                GestureDetector(
                  onTap: _clearSearch,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                ),

              // Filter button
              if (widget.onFilterTap != null)
                GestureDetector(
                  onTap: widget.onFilterTap,
                  child: Container(
                    margin: EdgeInsets.only(right: 3.w),
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'tune',
                      color: colorScheme.primary,
                      size: 4.w,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Recent queries dropdown
        if (_showRecentQueries)
          Container(
            margin: EdgeInsets.only(top: 1.h),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Text(
                    'Recent searches',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ...widget.recentQueries
                    .take(5)
                    .map(
                      (query) => InkWell(
                        onTap: () => _onRecentQuerySelected(query),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 2.h,
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'history',
                                color: colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.7,
                                ),
                                size: 4.w,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  query,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
      ],
    );
  }
}
