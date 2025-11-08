import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NoteContextMenuWidget extends StatelessWidget {
  final Map<String, dynamic> note;
  final VoidCallback onShare;
  final VoidCallback onDuplicate;
  final VoidCallback onArchive;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onFavorite;

  const NoteContextMenuWidget({
    super.key,
    required this.note,
    required this.onShare,
    required this.onDuplicate,
    required this.onArchive,
    required this.onDelete,
    required this.onEdit,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isFavorite = (note['isFavorite'] as bool?) ?? false;
    final isArchived = (note['isArchived'] as bool?) ?? false;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowDark,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'description',
                  color: AppTheme.primaryBlue,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    (note['title'] as String?) ?? 'Untitled',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Menu items
          _buildMenuItem(
            context: context,
            icon: 'edit',
            title: 'Edit Note',
            onTap: onEdit,
          ),

          _buildMenuItem(
            context: context,
            icon: isFavorite ? 'favorite' : 'favorite_border',
            title: isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
            onTap: onFavorite,
            iconColor: isFavorite ? AppTheme.accentGreen : null,
          ),

          _buildMenuItem(
            context: context,
            icon: 'share',
            title: 'Share Note',
            onTap: onShare,
          ),

          _buildMenuItem(
            context: context,
            icon: 'content_copy',
            title: 'Duplicate Note',
            onTap: onDuplicate,
          ),

          _buildMenuItem(
            context: context,
            icon: isArchived ? 'unarchive' : 'archive',
            title: isArchived ? 'Unarchive Note' : 'Archive Note',
            onTap: onArchive,
            iconColor: isArchived ? AppTheme.warningAmber : null,
          ),

          // Divider before delete
          Container(
            height: 1,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            color: colorScheme.outline.withValues(alpha: 0.1),
          ),

          _buildMenuItem(
            context: context,
            icon: 'delete',
            title: 'Delete Note',
            onTap: onDelete,
            iconColor: AppTheme.errorRed,
            textColor: AppTheme.errorRed,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 2.h,
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: iconColor ?? colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textColor ?? colorScheme.onSurface,
                  fontWeight: isDestructive ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
