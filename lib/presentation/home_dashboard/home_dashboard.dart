import 'package:aura_os/presentation/home_dashboard/widgets/greeting_screen_widget.dart';
// recent activity is now presented inside the quick access cards
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/quick_access_cards_widget.dart';
import './widgets/quick_creation_fab_widget.dart';
import 'package:aura_os/presentation/energy_focus_dashboard/widgets/wellness_chart_widget.dart';

/// Home Dashboard screen serving as the central hub for Aura OS
class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  bool _isRefreshing = false;
  bool _isSyncing = false;
  final ScrollController _scrollController = ScrollController();
  // Mock monthly focus data for compact chart on the home dashboard
  final List<Map<String, dynamic>> _monthlyFocusData = [
    {'label': 'Week 1', 'value': 72},
    {'label': 'Week 2', 'value': 85},
    {'label': 'Week 3', 'value': 79},
    {'label': 'Week 4', 'value': 91},
  ];

  @override
  void initState() {
    super.initState();
    _simulateInitialSync();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _simulateInitialSync() {
    setState(() {
      _isSyncing = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate cloud sync
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });

      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CustomIconWidget(
                iconName: 'cloud_done',
                color: colorScheme.onInverseSurface,
                size: 20,
              ),
              SizedBox(width: 2.w),
              const Text('Data synced successfully'),
            ],
          ),
          backgroundColor: colorScheme.tertiary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with sync status
            _buildHeader(),

            // Main content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: colorScheme.primary,
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.h),

                          // Greeting section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: const GreetingSectionWidget(),
                          ),

                          SizedBox(height: 3.h),

                          // Quick access cards
                          const QuickAccessCardsWidget(),

                          SizedBox(height: 4.h),

                          // Monthly focus chart (replaces standalone Recent Activity)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: WellnessChartWidget(
                              chartType: 'bar',
                              chartData: _monthlyFocusData,
                              title: 'Monthly Focus Duration',
                            ),
                          ),

                          SizedBox(height: 4.h),

                          SizedBox(height: 10.h), // Space for FAB
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom navigation
      bottomNavigationBar: CustomBottomBar.productivity(
        currentIndex: 0,
        context: context,
      ),

      // Floating action button
      floatingActionButton: const QuickCreationFabWidget(),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // App title with adaptive logo
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    theme.brightness == Brightness.dark
                        ? 'assets/aura_os_dark.png'
                        : 'assets/aura_os_light.png',
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Aura OS',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),

          // Sync status and profile
          Row(
            children: [
              // Sync status indicator
              _isSyncing || _isRefreshing
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: _handleRefresh,
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: colorScheme.tertiary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: CustomIconWidget(
                          iconName: 'cloud_done',
                          color: colorScheme.tertiary,
                          size: 16,
                        ),
                      ),
                    ),

              SizedBox(width: 3.w),

              // Profile button
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/profile-screen'),
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'person',
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
