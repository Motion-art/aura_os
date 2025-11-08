import 'package:flutter/material.dart';
import '../presentation/energy_focus_dashboard/energy_focus_dashboard.dart';
import '../presentation/tasks_screen/tasks_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/mind_library_screen/mind_library_screen.dart';
import '../presentation/mind_library_screen/note_editor_screen.dart';
import '../presentation/peer_pods_screen/peer_pods_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/splash_screens/splash_screen.dart';
import '../presentation/auth/login_screen.dart';
import '../presentation/chat/chat_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/splash';
  static const String energyFocusDashboard = '/energy-focus-dashboard';
  static const String tasks = '/tasks-screen';
  static const String homeDashboard = '/home-dashboard';
  static const String mindLibrary = '/mind-library-screen';
  static const String peerPods = '/peer-pods-screen';
  static const String profile = '/profile-screen';
  static const String splash = '/splash';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    '/login': (context) => const LoginScreen(),
    energyFocusDashboard: (context) => const EnergyFocusDashboard(),
    tasks: (context) => const TasksScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    mindLibrary: (context) => const MindLibraryScreen(),
    '/note-editor': (context) => const NoteEditorScreen(),
    peerPods: (context) => const PeerPodsScreen(),
    profile: (context) => const ProfileScreen(),
    // TODO: Add your other routes here
    '/chat': (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      return ChatScreen(
        partnerName: args?['partnerName'] ?? 'Partner',
        partnerId: args?['partnerId'] ?? '',
        userId: args?['userId'] ?? '',
      );
    },
  };
}
