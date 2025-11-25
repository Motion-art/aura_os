import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
// recent activity widget removed from quick access slides; kept the file import removed

/// Widget displaying quick access cards for today's priorities
class QuickAccessCardsWidget extends StatefulWidget {
  const QuickAccessCardsWidget({super.key});

  @override
  State<QuickAccessCardsWidget> createState() => _QuickAccessCardsWidgetState();
}

class _QuickAccessCardsWidgetState extends State<QuickAccessCardsWidget> {
  late final PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.78);
    _pageController.addListener(() {
      setState(() {
        _currentPage =
            _pageController.page ?? _pageController.initialPage.toDouble();
      });
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(() {});
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Text(
            'Today\'s Priorities',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(height: 2.5.h),
        SizedBox(
          height: 19.h,
          child: Center(
            child: Builder(
              builder: (context) {
                final List<Widget> slides = [];

                slides.add(
                  _buildQuickAccessCard(
                    context: context,
                    title: 'Pending Tasks',
                    value: '8',
                    subtitle: '3 due today',
                    icon: 'task_alt',
                    color: colorScheme.primary,
                    onTap: () => Navigator.pushNamed(context, '/tasks-screen'),
                  ),
                );

                slides.add(
                  _buildQuickAccessCard(
                    context: context,
                    title: 'Energy Check-in',
                    value: 'Tap to update',
                    subtitle: 'Not logged',
                    icon: 'bolt',
                    color: colorScheme.tertiary,
                    onTap: () =>
                        Navigator.pushNamed(context, '/energy-focus-dashboard'),
                  ),
                );

                slides.add(
                  _buildQuickAccessCard(
                    context: context,
                    title: 'Active Jobs',
                    value: '2',
                    subtitle: '1 accountability',
                    icon: 'groups',
                    color: colorScheme.secondary,
                    onTap: () =>
                        Navigator.pushNamed(context, '/peer-pods-screen'),
                  ),
                );

                return PageView.builder(
                  controller: _pageController,
                  itemCount: slides.length,
                  padEnds: false,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 2.5.h,
                        horizontal: 1.5.w,
                      ),
                      child: SizedBox(width: 38.w, child: slides[index]),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccessCard({
    required BuildContext context,
    required String title,
    required String value,
    required String subtitle,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // determine if the displayed value/subtitle represent negative/missing states
    final bool subtitleNegative =
        subtitle.toLowerCase().contains('due') ||
        subtitle.toLowerCase().contains('overdue') ||
        subtitle.toLowerCase().contains('not logged') ||
        subtitle.toLowerCase().contains('not set');
    final bool valueNegative =
        value.toLowerCase().contains('not logged') ||
        value.toLowerCase().contains('not set');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.w,
        padding: EdgeInsets.symmetric(horizontal: 0.75.w, vertical: 0.625.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
          boxShadow: [
            // Top shadow (softer)
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.11),
              blurRadius: 6,
              offset: const Offset(0, -3),
            ),
            // Bottom shadow (softer)
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.11),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: title at the top with navigation arrow
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 18.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.4.h),
            // Main content: value/subtitle on the left, large icon anchored to the right
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 0.6.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            value,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: valueNegative
                                  ? colorScheme.error
                                  : colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(height: 0.175.h),
                          subtitleNegative
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.error.withOpacity(0.13),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    subtitle,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.error,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                )
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.onSurfaceVariant
                                        .withOpacity(0.13),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    subtitle,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  // Icon anchored to the right, centered vertically and slightly larger
                  // Icon anchored to the right, shifted slightly upward so it's not too close to the bottom
                  Transform.translate(
                    offset: Offset(0, -0.8.h),
                    child: Container(
                      margin: EdgeInsets.only(left: 6, right: 2.5.w),
                      padding: EdgeInsets.all(0.9.w),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CustomIconWidget(
                        iconName: icon,
                        color: color,
                        size: 29,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // _buildSlideWrapper was removed in favor of PageView.builder wrapping
}
