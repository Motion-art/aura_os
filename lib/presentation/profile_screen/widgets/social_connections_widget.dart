import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialConnectionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> podMemberships;
  final List<Map<String, dynamic>> accountabilityPartners;

  const SocialConnectionsWidget({
    super.key,
    required this.podMemberships,
    required this.accountabilityPartners,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Social Connections',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          // Pod Memberships Section
          _buildConnectionSection(
            context: context,
            title: 'Pod Memberships',
            items: podMemberships,
            emptyMessage: 'No pod memberships yet',
            emptyDescription:
                'Join accountability pods to connect with like-minded peers.',
            iconName: 'groups',
            onTap: (item) => _navigateToPod(context, item),
          ),
          SizedBox(height: 3.h),
          // Accountability Partners Section
          _buildConnectionSection(
            context: context,
            title: 'Accountability Partners',
            items: accountabilityPartners,
            emptyMessage: 'No accountability partners',
            emptyDescription:
                'Connect with partners to stay motivated and accountable.',
            iconName: 'handshake',
            onTap: (item) => _viewPartnerProfile(context, item),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionSection({
    required BuildContext context,
    required String title,
    required List<Map<String, dynamic>> items,
    required String emptyMessage,
    required String emptyDescription,
    required String iconName,
    required Function(Map<String, dynamic>) onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              '${items.length}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        items.isEmpty
            ? _buildEmptyConnectionState(
                context,
                emptyMessage,
                emptyDescription,
                iconName,
              )
            : SizedBox(
                height: 12.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length > 8 ? 8 : items.length,
                  separatorBuilder: (context, index) => SizedBox(width: 3.w),
                  itemBuilder: (context, index) {
                    if (index == 7 && items.length > 8) {
                      return _buildMoreConnectionsCard(
                        context,
                        items.length - 7,
                      );
                    }
                    return _buildConnectionCard(context, items[index], onTap);
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildEmptyConnectionState(
    BuildContext context,
    String message,
    String description,
    String iconName,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 8.w,
          ),
          SizedBox(height: 1.h),
          Text(
            message,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionCard(
    BuildContext context,
    Map<String, dynamic> item,
    Function(Map<String, dynamic>) onTap,
  ) {
    return GestureDetector(
      onTap: () => onTap(item),
      child: Container(
        width: 20.w,
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            item["avatar"] != null
                ? ClipOval(
                    child: CustomImageWidget(
                      imageUrl: item["avatar"] as String,
                      width: 12.w,
                      height: 12.w,
                      fit: BoxFit.cover,
                      semanticLabel:
                          item["avatarSemanticLabel"] as String? ??
                          "Profile photo",
                    ),
                  )
                : Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        (item["name"] as String).substring(0, 1).toUpperCase(),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
            SizedBox(height: 1.h),
            Text(
              item["name"] as String,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreConnectionsCard(BuildContext context, int additionalCount) {
    return Container(
      width: 20.w,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'add',
            color: Theme.of(context).colorScheme.primary,
            size: 6.w,
          ),
          SizedBox(height: 1.h),
          Text(
            '+$additionalCount',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'more',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPod(BuildContext context, Map<String, dynamic> pod) {
    Navigator.pushNamed(context, '/peer-pods-screen');
  }

  void _viewPartnerProfile(BuildContext context, Map<String, dynamic> partner) {
    // Navigate to chat screen for this partner
    Navigator.pushNamed(
      context,
      '/chat',
      arguments: {
        'partnerId': partner['id'],
        'partnerName': partner['name'],
        // You may want to pass the current userId from parent context
        // For now, use a placeholder or fetch from a provider
        'userId': 'user_001',
      },
    );
  }
}
