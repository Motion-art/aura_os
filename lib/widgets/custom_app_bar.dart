import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget implementing purposeful minimalism design philosophy
/// Provides clean, minimal headers optimized for productivity applications
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title text to display in the app bar
  final String title;

  /// Optional leading widget (typically back button or menu icon)
  final Widget? leading;

  /// List of action widgets to display on the right side
  final List<Widget>? actions;

  /// Whether to show the back button automatically
  final bool automaticallyImplyLeading;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom background color (optional, uses theme default if null)
  final Color? backgroundColor;

  /// Custom foreground color for text and icons (optional, uses theme default if null)
  final Color? foregroundColor;

  /// Elevation of the app bar
  final double elevation;

  /// Whether the app bar should have a shadow when scrolled under
  final double? scrolledUnderElevation;

  /// Custom title widget (overrides title string if provided)
  final Widget? titleWidget;

  /// Bottom widget (typically TabBar)
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.centerTitle = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.scrolledUnderElevation,
    this.titleWidget,
    this.bottom,
  });

  /// Factory constructor for home screen app bar with specific styling
  factory CustomAppBar.home({
    Key? key,
    String title = 'Focus Flow',
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      key: key,
      title: title,
      leading: null,
      actions: actions ??
          [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                // Navigate to notifications or show notification panel
              },
              tooltip: 'Notifications',
            ),
            IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              onPressed: () {
                // Navigate to profile screen
              },
              tooltip: 'Profile',
            ),
          ],
      automaticallyImplyLeading: false,
      centerTitle: false,
    );
  }

  /// Factory constructor for secondary screens with back navigation
  factory CustomAppBar.secondary({
    Key? key,
    required String title,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
  }) {
    return CustomAppBar(
      key: key,
      title: title,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: onBackPressed,
        tooltip: 'Back',
      ),
      actions: actions,
      automaticallyImplyLeading: false,
      centerTitle: false,
    );
  }

  /// Factory constructor for search-enabled app bar
  factory CustomAppBar.search({
    Key? key,
    required String title,
    required VoidCallback onSearchPressed,
    List<Widget>? additionalActions,
  }) {
    return CustomAppBar(
      key: key,
      title: title,
      actions: [
        IconButton(
          icon: const Icon(Icons.search_outlined),
          onPressed: onSearchPressed,
          tooltip: 'Search',
        ),
        ...?additionalActions,
      ],
      automaticallyImplyLeading: true,
      centerTitle: false,
    );
  }

  /// Factory constructor for modal app bar (used in bottom sheets, dialogs)
  factory CustomAppBar.modal({
    Key? key,
    required String title,
    VoidCallback? onClosePressed,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      key: key,
      title: title,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: onClosePressed ??
            () {
              // Default close behavior
            },
        tooltip: 'Close',
      ),
      actions: actions,
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: titleWidget ??
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: foregroundColor ?? colorScheme.onSurface,
              letterSpacing: -0.2,
            ),
          ),
      leading: leading,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation ?? 1,
      shadowColor: theme.shadowColor,
      surfaceTintColor: backgroundColor ?? colorScheme.surface,
      bottom: bottom,
      iconTheme: IconThemeData(
        color: foregroundColor ?? colorScheme.onSurface,
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: foregroundColor ?? colorScheme.onSurfaceVariant,
        size: 24,
      ),
      titleSpacing: centerTitle ? 0 : 16,
      toolbarHeight: kToolbarHeight,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}
