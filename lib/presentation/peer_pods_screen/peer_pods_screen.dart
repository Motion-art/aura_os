import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/create_pod_modal.dart';
import './widgets/empty_state_widget.dart';
import './widgets/job_card_widget.dart';
import './widgets/pod_card_widget.dart';
import './widgets/post_job_modal.dart';

class PeerPodsScreen extends StatefulWidget {
  const PeerPodsScreen({super.key});

  @override
  State<PeerPodsScreen> createState() => _PeerPodsScreenState();
}

class _PeerPodsScreenState extends State<PeerPodsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  // Mock data for pods
  List<Map<String, dynamic>> _myPods = [
    {
      'id': 1,
      'name': 'Morning Routine Masters',
      'description': 'Building consistent morning habits for productivity',
      'activeJobs': 3,
      'members': [
        {
          'id': 1,
          'name': 'Sarah Chen',
          'avatar':
              'https://images.unsplash.com/photo-1597621969117-1a305d3e0c68',
          'semanticLabel':
              'Professional headshot of Asian woman with long black hair in white blazer',
        },
        {
          'id': 2,
          'name': 'Mike Johnson',
          'avatar':
              'https://images.unsplash.com/photo-1588178457501-31b7688a41a0',
          'semanticLabel':
              'Professional headshot of Caucasian man with short brown hair in navy suit',
        },
        {
          'id': 3,
          'name': 'Elena Rodriguez',
          'avatar':
              'https://images.unsplash.com/photo-1700560970703-82fd3150d5ac',
          'semanticLabel':
              'Professional headshot of Hispanic woman with curly hair in black blazer',
        },
      ],
      'hasNewActivity': true,
      'lastActivity': '2 hours ago',
    },
    {
      'id': 2,
      'name': 'Fitness Accountability',
      'description': 'Stay motivated with daily workout check-ins',
      'activeJobs': 1,
      'members': [
        {
          'id': 4,
          'name': 'David Kim',
          'avatar':
              'https://images.unsplash.com/photo-1696489647375-30cae68481f2',
          'semanticLabel':
              'Professional headshot of Asian man with glasses in gray sweater',
        },
        {
          'id': 5,
          'name': 'Lisa Thompson',
          'avatar':
              'https://images.unsplash.com/photo-1550985244-af33a8d1a9ef',
          'semanticLabel':
              'Professional headshot of blonde woman in blue shirt smiling',
        },
      ],
      'hasNewActivity': false,
      'lastActivity': '1 day ago',
    },
  ];

  // Mock data for available jobs
  List<Map<String, dynamic>> _availableJobs = [
    {
      'id': 1,
      'title': 'Complete Online Course',
      'description':
          'I need help staying accountable to finish my data science course. Looking for someone to check in weekly on my progress and help me stay motivated.',
      'duration': '2 weeks',
      'accountabilityType': 'Milestone tracking',
      'requesterName': 'Alex Martinez',
      'requesterAvatar':
          'https://images.unsplash.com/photo-1603515913839-ed6e5172a40e',
      'requesterSemanticLabel':
          'Professional headshot of Hispanic man with beard in white shirt',
      'timePosted': '3 hours ago',
      'rating': '4.8',
    },
    {
      'id': 2,
      'title': 'Daily Meditation Practice',
      'description':
          'Starting a 30-day meditation challenge and need someone to help me stay consistent. Looking for daily check-ins and encouragement.',
      'duration': '1 month',
      'accountabilityType': 'Habit formation',
      'requesterName': 'Jessica Wong',
      'requesterAvatar':
          'https://images.unsplash.com/photo-1556360691-44c1b4a470ee',
      'requesterSemanticLabel':
          'Professional headshot of Asian woman with short hair in green top',
      'timePosted': '1 day ago',
      'rating': '4.9',
    },
    {
      'id': 3,
      'title': 'Write Novel Chapter Weekly',
      'description':
          'Working on my first novel and struggling with consistency. Need someone to hold me accountable for writing one chapter per week.',
      'duration': '3 months',
      'accountabilityType': 'Check-ins',
      'requesterName': 'Robert Taylor',
      'requesterAvatar':
          'https://images.unsplash.com/photo-1692443495190-dfc1870a5e2e',
      'requesterSemanticLabel':
          'Professional headshot of Caucasian man with glasses and beard in plaid shirt',
      'timePosted': '2 days ago',
      'rating': '4.7',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search pods or jobs...',
                  border: InputBorder.none,
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              )
            : Text(
                'Peer Pods',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
            icon: CustomIconWidget(
              iconName: _isSearching ? 'close' : 'search',
              color: colorScheme.onSurface,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile-screen'),
            icon: CustomIconWidget(
              iconName: 'account_circle',
              color: colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Pods'),
            Tab(text: 'Available Jobs'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMyPodsTab(),
                _buildAvailableJobsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateOptions,
        icon: CustomIconWidget(
          iconName: 'add',
          color: colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          'Create',
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar.productivity(
        currentIndex: 4,
        context: context,
      ),
    );
  }

  Widget _buildMyPodsTab() {
    final filteredPods = _searchQuery.isEmpty
        ? _myPods
        : _myPods.where((pod) {
            final name = (pod['name'] as String? ?? '').toLowerCase();
            final description =
                (pod['description'] as String? ?? '').toLowerCase();
            return name.contains(_searchQuery) ||
                description.contains(_searchQuery);
          }).toList();

    if (filteredPods.isEmpty && _searchQuery.isEmpty) {
      return EmptyStateWidget(
        title: 'No Pods Yet',
        subtitle:
            'Create your first pod or join existing ones to start building accountability partnerships.',
        iconName: 'groups',
        buttonText: 'Create Pod',
        onButtonPressed: () => _showCreatePodModal(),
      );
    }

    if (filteredPods.isEmpty && _searchQuery.isNotEmpty) {
      return EmptyStateWidget(
        title: 'No Results Found',
        subtitle:
            'Try adjusting your search terms or browse all available pods.',
        iconName: 'search_off',
        buttonText: 'Clear Search',
        onButtonPressed: () {
          setState(() {
            _searchController.clear();
            _searchQuery = '';
          });
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshPods,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        itemCount: filteredPods.length,
        itemBuilder: (context, index) {
          final pod = filteredPods[index];
          return PodCardWidget(
            podData: pod,
            onTap: () => _viewPodDetails(pod),
            onLongPress: () => _showPodOptions(pod),
          );
        },
      ),
    );
  }

  Widget _buildAvailableJobsTab() {
    final filteredJobs = _searchQuery.isEmpty
        ? _availableJobs
        : _availableJobs.where((job) {
            final title = (job['title'] as String? ?? '').toLowerCase();
            final description =
                (job['description'] as String? ?? '').toLowerCase();
            final type =
                (job['accountabilityType'] as String? ?? '').toLowerCase();
            return title.contains(_searchQuery) ||
                description.contains(_searchQuery) ||
                type.contains(_searchQuery);
          }).toList();

    if (filteredJobs.isEmpty && _searchQuery.isEmpty) {
      return EmptyStateWidget(
        title: 'No Jobs Available',
        subtitle:
            'Be the first to post a job request and find your accountability partner.',
        iconName: 'work',
        buttonText: 'Post Job',
        onButtonPressed: () => _showPostJobModal(),
      );
    }

    if (filteredJobs.isEmpty && _searchQuery.isNotEmpty) {
      return EmptyStateWidget(
        title: 'No Jobs Found',
        subtitle: 'Try different search terms or post your own job request.',
        iconName: 'search_off',
        buttonText: 'Clear Search',
        onButtonPressed: () {
          setState(() {
            _searchController.clear();
            _searchQuery = '';
          });
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshJobs,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        itemCount: filteredJobs.length,
        itemBuilder: (context, index) {
          final job = filteredJobs[index];
          return JobCardWidget(
            jobData: job,
            onAccept: () => _acceptJob(job),
            onHide: () => _hideJob(job),
            onTap: () => _viewJobDetails(job),
          );
        },
      ),
    );
  }

  void _showCreateOptions() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'groups',
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              title: Text(
                'Create Pod',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                'Start an accountability group',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showCreatePodModal();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'work',
                color: AppTheme.accentGreen,
                size: 24,
              ),
              title: Text(
                'Post Job',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                'Request accountability support',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showPostJobModal();
              },
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  void _showCreatePodModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreatePodModal(
        onCreatePod: (podData) {
          setState(() {
            _myPods.insert(0, podData);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Pod "${podData['name']}" created successfully!'),
              backgroundColor: AppTheme.accentGreen,
            ),
          );
        },
      ),
    );
  }

  void _showPostJobModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PostJobModal(
        onPostJob: (jobData) {
          setState(() {
            _availableJobs.insert(0, jobData);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Job "${jobData['title']}" posted successfully!'),
              backgroundColor: AppTheme.accentGreen,
            ),
          );
        },
      ),
    );
  }

  void _viewPodDetails(Map<String, dynamic> pod) {
    // Navigate to pod details screen (not implemented in this scope)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${pod['name']} details...'),
      ),
    );
  }

  void _showPodOptions(Map<String, dynamic> pod) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'settings',
                color: colorScheme.onSurface,
                size: 24,
              ),
              title: Text('Pod Settings'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pod settings opened')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'notifications_off',
                color: colorScheme.onSurface,
                size: 24,
              ),
              title: Text('Mute Notifications'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications muted')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'exit_to_app',
                color: AppTheme.errorRed,
                size: 24,
              ),
              title: Text(
                'Leave Pod',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.errorRed,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _leavePod(pod);
              },
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  void _leavePod(Map<String, dynamic> pod) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Pod'),
        content: Text('Are you sure you want to leave "${pod['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _myPods.removeWhere((p) => p['id'] == pod['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Left "${pod['name']}" successfully'),
                  backgroundColor: AppTheme.errorRed,
                ),
              );
            },
            child: Text(
              'Leave',
              style: TextStyle(color: AppTheme.errorRed),
            ),
          ),
        ],
      ),
    );
  }

  void _acceptJob(Map<String, dynamic> job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accept Job'),
        content: Text('Accept accountability job: "${job['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _availableJobs.removeWhere((j) => j['id'] == job['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Job "${job['title']}" accepted!'),
                  backgroundColor: AppTheme.accentGreen,
                ),
              );
            },
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  void _hideJob(Map<String, dynamic> job) {
    setState(() {
      _availableJobs.removeWhere((j) => j['id'] == job['id']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Job "${job['title']}" hidden'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _availableJobs.add(job);
            });
          },
        ),
      ),
    );
  }

  void _viewJobDetails(Map<String, dynamic> job) {
    // Navigate to job details screen (not implemented in this scope)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening "${job['title']}" details...'),
      ),
    );
  }

  Future<void> _refreshPods() async {
    // Simulate network refresh
    await Future.delayed(const Duration(seconds: 1));

    // Update last activity times
    setState(() {
      for (var pod in _myPods) {
        pod['lastActivity'] = 'Just now';
        pod['hasNewActivity'] = true;
      }
    });
  }

  Future<void> _refreshJobs() async {
    // Simulate network refresh
    await Future.delayed(const Duration(seconds: 1));

    // Add a new mock job
    final newJob = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'title': 'Learn Spanish Daily',
      'description':
          'Committed to practicing Spanish for 30 minutes daily. Need someone to check my progress and keep me motivated.',
      'duration': '1 month',
      'accountabilityType': 'Habit formation',
      'requesterName': 'Maria Santos',
      'requesterAvatar':
          'https://images.unsplash.com/photo-1721294928128-f6c2d1d2281d',
      'requesterSemanticLabel':
          'Professional headshot of Hispanic woman with long dark hair in red blouse',
      'timePosted': 'Just now',
      'rating': '4.6',
    };

    setState(() {
      _availableJobs.insert(0, newJob);
    });
  }
}
