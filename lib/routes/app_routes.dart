import 'package:flutter/material.dart';
import '../presentation/main_dashboard/main_dashboard.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/disaster_selection/disaster_selection.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/3d_simulation_gameplay/3d_simulation_gameplay.dart';
import '../presentation/multiplayer_lobby/multiplayer_lobby.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String mainDashboard = '/main-dashboard';
  static const String splash = '/splash-screen';
  static const String disasterSelection = '/disaster-selection';
  static const String userProfile = '/user-profile';
  static const String threeDSimulationGameplay = '/3d-simulation-gameplay';
  static const String multiplayerLobby = '/multiplayer-lobby';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    mainDashboard: (context) => const MainDashboard(),
    splash: (context) => const SplashScreen(),
    disasterSelection: (context) => const DisasterSelection(),
    userProfile: (context) => const UserProfile(),
    threeDSimulationGameplay: (context) => const ThreeDSimulationGameplay(),
    multiplayerLobby: (context) => const MultiplayerLobby(),
    // TODO: Add your other routes here
  };
}