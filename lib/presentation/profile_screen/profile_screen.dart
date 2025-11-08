import 'package:aura_os/presentation/profile_screen/widgets/section_header_widget.dart';
import 'package:aura_os/presentation/profile_screen/widgets/statistics_card_widgets.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/achievement_badges_widget.dart';
import './widgets/activity_timeline_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/social_connections_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();

  List<CameraDescription>? _cameras;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  XFile? _capturedImage;

  // Mock user profile data
  final Map<String, dynamic> _userProfile = {
    "id": "user_001",
    "name": "Sarah Chen",
    "email": "sarah.chen@example.com",
    "bio":
        "Product Manager passionate about productivity and wellness. Building better work-life balance through technology and mindful practices.",
    "profilePhoto":
        "https://images.unsplash.com/photo-1706565029882-6f25f1d9af65",
    "profilePhotoSemanticLabel":
        "Professional headshot of an Asian woman with shoulder-length black hair, wearing a white blazer and smiling warmly at the camera",
    "joinDate": "March 2024",
    "location": "San Francisco, CA",
    "timezone": "PST",
  };

  // Mock statistics data
  final Map<String, dynamic> _statistics = {
    "tasksCompleted": 247,
    "notesCreated": 89,
    "energyCheckins": 156,
    "jobsFulfilled": 23,
  };

  // Mock activity timeline data
  final List<Map<String, dynamic>> _activities = [
    {
      "id": "activity_001",
      "type": "task_completed",
      "title": "Quarterly Review Complete",
      "description":
          "Finished Q4 performance review and goal setting for next quarter",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      "id": "activity_002",
      "type": "achievement",
      "title": "Productivity Streak",
      "description": "Achieved 30-day task completion streak milestone",
      "timestamp": DateTime.now().subtract(const Duration(hours: 5)),
    },
    {
      "id": "activity_003",
      "type": "energy_checkin",
      "title": "Energy Check-in",
      "description": "Logged high energy level after morning workout session",
      "timestamp": DateTime.now().subtract(const Duration(hours: 8)),
    },
    {
      "id": "activity_004",
      "type": "note_created",
      "title": "Meeting Notes Added",
      "description":
          "Created comprehensive notes from product strategy meeting",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      "id": "activity_005",
      "type": "job_fulfilled",
      "title": "Accountability Job Complete",
      "description":
          "Successfully helped team member with project deadline accountability",
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
    },
  ];

  // Mock achievements data
  final List<Map<String, dynamic>> _achievements = [
    {
      "id": "achievement_001",
      "title": "Task Master",
      "description": "Complete 100 tasks",
      "icon": "task_alt",
      "isUnlocked": true,
      "unlockedDate": DateTime.now().subtract(const Duration(days: 15)),
    },
    {
      "id": "achievement_002",
      "title": "Consistency King",
      "description": "30-day streak",
      "icon": "local_fire_department",
      "isUnlocked": true,
      "unlockedDate": DateTime.now().subtract(const Duration(hours: 5)),
    },
    {
      "id": "achievement_003",
      "title": "Knowledge Keeper",
      "description": "Create 50 notes",
      "icon": "library_books",
      "isUnlocked": true,
      "unlockedDate": DateTime.now().subtract(const Duration(days: 30)),
    },
    {
      "id": "achievement_004",
      "title": "Energy Expert",
      "description": "100 energy check-ins",
      "icon": "battery_full",
      "isUnlocked": true,
      "unlockedDate": DateTime.now().subtract(const Duration(days: 45)),
    },
    {
      "id": "achievement_005",
      "title": "Team Player",
      "description": "Help 50 accountability partners",
      "icon": "groups",
      "isUnlocked": false,
      "unlockedDate": null,
    },
    {
      "id": "achievement_006",
      "title": "Wellness Warrior",
      "description": "Maintain positive energy for 60 days",
      "icon": "self_improvement",
      "isUnlocked": false,
      "unlockedDate": null,
    },
  ];

  // Mock pod memberships data
  final List<Map<String, dynamic>> _podMemberships = [
    {
      "id": "pod_001",
      "name": "Product Leaders",
      "avatar": "https://images.unsplash.com/photo-1624555130581-1d9cca783bc0",
      "avatarSemanticLabel":
          "Group of diverse professionals collaborating around a modern conference table in a bright office setting",
      "memberCount": 12,
      "role": "Member",
    },
    {
      "id": "pod_002",
      "name": "Morning Achievers",
      "avatar": "https://images.unsplash.com/photo-1679489160541-1ba98f47591f",
      "avatarSemanticLabel":
          "Sunrise over mountain peaks with golden light illuminating the landscape, representing early morning motivation",
      "memberCount": 8,
      "role": "Admin",
    },
    {
      "id": "pod_003",
      "name": "Wellness Focus",
      "avatar": "https://images.unsplash.com/photo-1640622332859-55e65253475d",
      "avatarSemanticLabel":
          "Person in meditation pose on a yoga mat in a peaceful room with plants and natural lighting",
      "memberCount": 15,
      "role": "Member",
    },
  ];

  // Mock accountability partners data
  final List<Map<String, dynamic>> _accountabilityPartners = [
    {
      "id": "partner_001",
      "name": "Alex Rivera",
      "avatar": "https://images.unsplash.com/photo-1695830209166-161b6297541d",
      "avatarSemanticLabel":
          "Professional headshot of a Hispanic man with short dark hair and a friendly smile, wearing a navy blue shirt",
      "role": "Accountability Partner",
      "connectionDate": DateTime.now().subtract(const Duration(days: 45)),
    },
    {
      "id": "partner_002",
      "name": "Maya Patel",
      "avatar": "https://images.unsplash.com/photo-1733737272264-6af8f1aa41fc",
      "avatarSemanticLabel":
          "Professional headshot of an Indian woman with long black hair, wearing glasses and a white blouse, smiling confidently",
      "role": "Mutual Accountability",
      "connectionDate": DateTime.now().subtract(const Duration(days: 30)),
    },
  ];

  // Mock settings data
  Map<String, dynamic> _settings = {
    "notificationsEnabled": true,
    "darkModeEnabled": false,
    "autoSyncEnabled": true,
    "privacyMode": false,
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        final camera = _cameras!.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
          orElse: () => _cameras!.first,
        );

        _cameraController = CameraController(camera, ResolutionPreset.medium);

        await _cameraController!.initialize();

        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      // Camera initialization failed, continue without camera
    }
  }

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _changeProfilePhoto() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Change Profile Photo',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPhotoOption(
                    icon: 'camera_alt',
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _takePhoto();
                    },
                  ),
                  _buildPhotoOption(
                    icon: 'photo_library',
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _pickFromGallery();
                    },
                  ),
                  _buildPhotoOption(
                    icon: 'delete',
                    label: 'Remove',
                    onTap: () {
                      Navigator.pop(context);
                      _removePhoto();
                    },
                  ),
                ],
              ),
              SizedBox(height: 4.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhotoOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: Theme.of(context).colorScheme.primary,
                size: 7.w,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _takePhoto() async {
    if (!await _requestCameraPermission()) {
      _showPermissionDeniedDialog();
      return;
    }

    await _initializeCamera();

    if (_cameraController != null && _isCameraInitialized) {
      try {
        final XFile photo = await _cameraController!.takePicture();
        setState(() {
          _capturedImage = photo;
          _userProfile["profilePhoto"] = photo.path;
        });
      } catch (e) {
        _showErrorDialog('Failed to take photo. Please try again.');
      }
    } else {
      _showErrorDialog(
        'Camera not available. Please try selecting from gallery.',
      );
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _capturedImage = image;
          _userProfile["profilePhoto"] = image.path;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to select photo. Please try again.');
    }
  }

  void _removePhoto() {
    setState(() {
      _capturedImage = null;
      _userProfile["profilePhoto"] =
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?fm=jpg&q=60&w=400&ixlib=rb-4.0.3";
    });
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Camera Permission Required'),
          content: const Text('Please grant camera permission to take photos.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('Settings'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _editProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return _buildEditProfileForm(scrollController);
          },
        );
      },
    );
  }

  Widget _buildEditProfileForm(ScrollController scrollController) {
    final TextEditingController nameController = TextEditingController(
      text: _userProfile["name"],
    );
    final TextEditingController bioController = TextEditingController(
      text: _userProfile["bio"],
    );
    final TextEditingController locationController = TextEditingController(
      text: _userProfile["location"],
    );

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                'Edit Profile',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _userProfile["name"] = nameController.text;
                    _userProfile["bio"] = bioController.text;
                    _userProfile["location"] = locationController.text;
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  'Save',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                    ),
                  ),
                  SizedBox(height: 3.h),
                  TextField(
                    controller: bioController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Bio',
                      hintText: 'Tell us about yourself',
                    ),
                  ),
                  SizedBox(height: 3.h),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      hintText: 'Enter your location',
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Privacy Settings',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SwitchListTile(
                    title: const Text('Public Profile'),
                    subtitle: const Text('Allow others to view your profile'),
                    value: !(_settings["privacyMode"] as bool),
                    onChanged: (value) {
                      setState(() {
                        _settings["privacyMode"] = !value;
                      });
                    },
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSettingChanged(String key, dynamic value) {
    setState(() {
      _settings[key] = value;
    });
  }

  Future<void> _refreshProfile() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, this would fetch updated data from the server
    setState(() {
      // Update statistics or other data
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 0,
              floating: true,
              pinned: false,
              backgroundColor: colorScheme.surface,
              elevation: 0,
              title: Text(
                'Profile',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              centerTitle: true,
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  ProfileHeaderWidget(
                    userProfile: _userProfile,
                    onEditProfile: _editProfile,
                    onChangePhoto: _changeProfilePhoto,
                  ),
                  SizedBox(height: 3.h),
                  StatisticsCardsWidget(statistics: _statistics),
                  SizedBox(height: 4.h),
                  AchievementBadgesWidget(achievements: _achievements),
                  SizedBox(height: 4.h),
                  ActivityTimelineWidget(activities: _activities),
                  SizedBox(height: 4.h),
                  SocialConnectionsWidget(
                    podMemberships: _podMemberships,
                    accountabilityPartners: _accountabilityPartners,
                  ),
                  SizedBox(height: 4.h),
                  SettingsSectionWidget(
                    settings: _settings,
                    onSettingChanged: _onSettingChanged,
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar.productivity(
        currentIndex: '/profile-screen'.navigationIndex,
        context: context,
      ),
    );
  }
}
