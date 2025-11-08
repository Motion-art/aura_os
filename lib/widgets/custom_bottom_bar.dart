import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item data structure for bottom navigation
class NavigationItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final String route;
  final String tooltip;

  const NavigationItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    required this.route,
    required this.tooltip,
  });
}

/// Custom Bottom Navigation Bar implementing adaptive navigation patterns
/// Provides seamless navigation experience optimized for productivity applications
class CustomBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when navigation item is tapped
  final ValueChanged<int> onTap;

  /// Custom background color (optional, uses theme default if null)
  final Color? backgroundColor;

  /// Custom selected item color (optional, uses theme default if null)
  final Color? selectedItemColor;

  /// Custom unselected item color (optional, uses theme default if null)
  final Color? unselectedItemColor;

  /// Elevation of the bottom bar
  final double elevation;

  /// Whether to show labels
  final bool showLabels;

  /// Type of bottom navigation bar
  final BottomNavigationBarType type;

  /// Predefined navigation items for the productivity app
  static const List<NavigationItem> _navigationItems = [
    NavigationItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      route: '/home-dashboard',
      tooltip: 'Home Dashboard',
    ),
    NavigationItem(
      label: 'Tasks',
      icon: Icons.task_outlined,
      activeIcon: Icons.task,
      route: '/tasks-screen',
      tooltip: 'Task Management',
    ),
    NavigationItem(
      label: 'Mind',
      icon: Icons.psychology_outlined,
      activeIcon: Icons.psychology,
      route: '/mind-library-screen',
      tooltip: 'Mind Library',
    ),
    NavigationItem(
      label: 'Energy',
      icon: Icons.bolt_outlined,
      activeIcon: Icons.bolt,
      route: '/energy-focus-dashboard',
      tooltip: 'Energy & Focus',
    ),
    NavigationItem(
      label: 'Pods',
      icon: Icons.groups_outlined,
      activeIcon: Icons.groups,
      route: '/peer-pods-screen',
      tooltip: 'Peer Pods',
    ),
  ];

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8,
    this.showLabels = true,
    this.type = BottomNavigationBarType.fixed,
  });

  /// Factory constructor for default productivity app navigation
  factory CustomBottomBar.productivity({
    Key? key,
    required int currentIndex,
    required BuildContext context,
  }) {
    return CustomBottomBar(
      key: key,
      currentIndex: currentIndex,
      onTap: (index) => _handleNavigation(context, index),
      type: BottomNavigationBarType.fixed,
      showLabels: true,
    );
  }

  /// Factory constructor for minimal navigation (icons only)
  factory CustomBottomBar.minimal({
    Key? key,
    required int currentIndex,
    required BuildContext context,
  }) {
    return CustomBottomBar(
      key: key,
      currentIndex: currentIndex,
      onTap: (index) => _handleNavigation(context, index),
      type: BottomNavigationBarType.fixed,
      showLabels: false,
    );
  }

  /// Factory constructor for shifting navigation (when more than 3 items)
  factory CustomBottomBar.shifting({
    Key? key,
    required int currentIndex,
    required BuildContext context,
  }) {
    return CustomBottomBar(
      key: key,
      currentIndex: currentIndex,
      onTap: (index) => _handleNavigation(context, index),
      type: BottomNavigationBarType.shifting,
      showLabels: true,
    );
  }

  /// Handle navigation to different screens
  static void _handleNavigation(BuildContext context, int index) {
    if (index >= 0 && index < _navigationItems.length) {
      final route = _navigationItems[index].route;

      // Get current route name
      final currentRoute = ModalRoute.of(context)?.settings.name;

      // Only navigate if not already on the target route
      if (currentRoute != route) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          route,
          (route) => false, // Remove all previous routes
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Use Material 3 NavigationBar for better design consistency
    if (theme.useMaterial3) {
      return NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        backgroundColor: backgroundColor ?? colorScheme.surface,
        elevation: elevation,
        shadowColor: theme.shadowColor,
        indicatorColor:
            (selectedItemColor ?? colorScheme.primary).withValues(alpha: 0.1),
        labelBehavior: showLabels
            ? NavigationDestinationLabelBehavior.alwaysShow
            : NavigationDestinationLabelBehavior.alwaysHide,
        destinations: _navigationItems.asMap().entries.map((entry) {
          final item = entry.value;
          final isSelected = entry.key == currentIndex;

          return NavigationDestination(
            icon: Icon(
              item.icon,
              color: unselectedItemColor ?? colorScheme.onSurfaceVariant,
            ),
            selectedIcon: Icon(
              item.activeIcon ?? item.icon,
              color: selectedItemColor ?? colorScheme.primary,
            ),
            label: item.label,
            tooltip: item.tooltip,
          );
        }).toList(),
      );
    }

    // Fallback to traditional BottomNavigationBar for Material 2
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: type,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      selectedItemColor: selectedItemColor ?? colorScheme.primary,
      unselectedItemColor: unselectedItemColor ?? colorScheme.onSurfaceVariant,
      elevation: elevation,
      showSelectedLabels: showLabels,
      showUnselectedLabels: showLabels,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      items: _navigationItems.asMap().entries.map((entry) {
        final item = entry.value;
        final isSelected = entry.key == currentIndex;

        return BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Icon(
              isSelected ? (item.activeIcon ?? item.icon) : item.icon,
              size: 24,
            ),
          ),
          label: item.label,
          tooltip: item.tooltip,
          backgroundColor: backgroundColor ?? colorScheme.surface,
        );
      }).toList(),
    );
  }
}

/// Extension to get current navigation index based on route name
extension NavigationIndexExtension on String {
  int get navigationIndex {
    const routes = [
      '/home-dashboard',
      '/tasks-screen',
      '/mind-library-screen',
      '/energy-focus-dashboard',
      '/peer-pods-screen',
    ];

    final index = routes.indexOf(this);
    return index >= 0 ? index : 0;
  }
}