import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/business/auth/roles.dart';
import 'package:flutter_application_1/screens/hub/auth-screens/dashboard/dashboard_screen.dart';
import 'package:flutter_application_1/screens/hub/auth-screens/profile/profile_screen.dart';

typedef ScreenBuilder = Widget Function(AppRole role);

class NavConfig {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final int? badgeCount;
  final ScreenBuilder builder;

  const NavConfig({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.builder,
    this.badgeCount,
  });
}

final Map<AppRole, List<NavConfig>> navConfig = {
  AppRole.driver: [
    NavConfig(
      label: 'Home',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      builder: (role) => DashboardScreen(role: role),
    ),
    NavConfig(
      label: 'Carpool',
      icon: Icons.local_shipping_outlined,
      selectedIcon: Icons.local_shipping,
      badgeCount: 3,
      builder: (_) => const PlaceholderScreen(title: 'Driver Jobs'),
    ),
    NavConfig(
      label: 'Profile',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      builder: (_) => const ProfileScreen(),
    ),
  ],
  AppRole.passenger: [
    NavConfig(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      builder: (_) => const PlaceholderScreen(title: 'Passenger Home'),
    ),
    NavConfig(
      label: 'Trips',
      icon: Icons.explore_outlined,
      selectedIcon: Icons.explore,
      badgeCount: 1,
      builder: (_) => const PlaceholderScreen(title: 'Passenger Trips'),
    ),
    NavConfig(
      label: 'Profile',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      builder: (_) => const PlaceholderScreen(title: 'Passenger Profile'),
    ),
  ],
};

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
