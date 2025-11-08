import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PodCardWidget extends StatelessWidget {
  final Map<String, dynamic> podData;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const PodCardWidget({
    super.key,
    required this.podData,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        shadowColor: theme.shadowColor,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            podData['name'] as String? ?? 'Unnamed Pod',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            podData['description'] as String? ??
                                'No description',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${podData['activeJobs'] ?? 0} active',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.accentGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildMemberAvatars(context),
                    ),
                    if (podData['hasNewActivity'] == true)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Last activity: ${podData['lastActivity'] ?? 'No activity'}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    CustomIconWidget(
                      iconName: 'chevron_right',
                      color: colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberAvatars(BuildContext context) {
    final members = (podData['members'] as List<dynamic>?) ?? [];
    final displayMembers = members.take(4).toList();
    final remainingCount = members.length - displayMembers.length;

    return Row(
      children: [
        ...displayMembers.asMap().entries.map((entry) {
          final index = entry.key;
          final member = entry.value as Map<String, dynamic>;

          return Container(
            margin: EdgeInsets.only(left: index > 0 ? 1.w : 0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.surfaceVariant,
              child: member['avatar'] != null
                  ? ClipOval(
                      child: CustomImageWidget(
                        imageUrl: member['avatar'] as String,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        semanticLabel: member['semanticLabel'] as String? ??
                            'Member avatar',
                      ),
                    )
                  : CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.textSecondary,
                      size: 18,
                    ),
            ),
          );
        }).toList(),
        if (remainingCount > 0) ...[
          SizedBox(width: 1.w),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '+$remainingCount',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
