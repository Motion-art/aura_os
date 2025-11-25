import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NoteListItemWidget extends StatelessWidget {
  final Map<String, dynamic> note;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onFavorite;
  final VoidCallback onArchive;

  const NoteListItemWidget({
    super.key,
    required this.note,
    required this.onTap,
    required this.onLongPress,
    required this.onFavorite,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final title = (note['title'] as String?) ?? 'Untitled';
    final content = (note['content'] as String?) ?? '';
    final tags = (note['tags'] as List?)?.cast<String>() ?? [];
    final isFavorite = (note['isFavorite'] as bool?) ?? false;
    final isArchived = (note['isArchived'] as bool?) ?? false;

    return Dismissible(
      key: Key('note_list_${note['id']}'),
      background: Container(
        color: AppTheme.accentGreen.withValues(alpha: 0.1),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 4.w),
        child: CustomIconWidget(
          iconName: 'favorite',
          color: AppTheme.accentGreen,
          size: 6.w,
        ),
      ),
      secondaryBackground: Container(
        color: AppTheme.warningAmber.withValues(alpha: 0.1),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        child: CustomIconWidget(
          iconName: 'archive',
          color: AppTheme.warningAmber,
          size: 6.w,
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onFavorite();
        } else if (direction == DismissDirection.endToStart) {
          onArchive();
        }
        return false;
      },
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          margin: EdgeInsets.only(bottom: 1.2.h),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            boxShadow: [
              // Top shadow
              BoxShadow(
                color: theme.brightness == Brightness.light
                    ? AppTheme.shadowLight.withOpacity(0.08)
                    : AppTheme.shadowDark.withOpacity(0.08),
                blurRadius: 3,
                offset: const Offset(0, -1),
              ),
              // Bottom shadow
              BoxShadow(
                color: theme.brightness == Brightness.light
                    ? AppTheme.shadowLight.withOpacity(0.10)
                    : AppTheme.shadowDark.withOpacity(0.10),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Note content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (content.isNotEmpty) ...[
                      SizedBox(height: 1.h),
                      Text(
                        content,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (tags.isNotEmpty) ...[
                      SizedBox(height: 1.h),
                      Text(
                        tags.take(3).map((tag) => '#$tag').join(' '),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Status icons
              SizedBox(width: 3.w),
              Column(
                children: [
                  if (isFavorite)
                    CustomIconWidget(
                      iconName: 'favorite',
                      color: AppTheme.accentGreen,
                      size: 5.w,
                    ),
                  if (isArchived) ...[
                    if (isFavorite) SizedBox(height: 1.h),
                    CustomIconWidget(
                      iconName: 'archive',
                      color: AppTheme.warningAmber,
                      size: 5.w,
                    ),
                  ],
                  if (!isFavorite && !isArchived)
                    CustomIconWidget(
                      iconName: 'chevron_right',
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.5,
                      ),
                      size: 5.w,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Removed unused _formatDate method
}
