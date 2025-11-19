import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/business/auth/roles.dart';
import 'package:flutter_application_1/screens/hub/auth-screens/dashboard_screen.dart';
import 'app_layout.dart';
import '../navigations/app_bottom_nav.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.role});
  final AppRole role;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  final _navKeys = List.generate(3, (_) => GlobalKey<NavigatorState>());

  Widget _buildRoot(int tabIndex) {
    final role = widget.role;
    if (role == AppRole.driver) {
      switch (tabIndex) {
        case 0:
          return const DashboardScreen();
        case 1:
          return const _TabRoot(title: 'Booking');
        default:
          return const _TabRoot(title: 'Profile');
      }
    } else {
      switch (tabIndex) {
        case 0:
          return Text('Dashboard for passenger');
        case 1:
          return const _TabRoot(title: 'Trips');
        default:
          return const _TabRoot(title: 'Profile');
      }
    }
  }

  Future<void> _onReselect() async {
    final nav = _navKeys[_index].currentState!;

    while (nav.canPop()) {
      nav.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = widget.role;

    final destinations = (role == AppRole.driver)
        ? [
            AppNavItem(
              label: 'Home',
              icon: Icons.dashboard_outlined,
              selectedIcon: Icons.dashboard,
            ),
            AppNavItem(
              label: 'Jobs',
              icon: Icons.local_shipping_outlined,
              selectedIcon: Icons.local_shipping,
              badgeCount: 3,
            ),
            AppNavItem(
              label: 'Profile',
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
            ),
          ]
        : [
            AppNavItem(
              label: 'Home',
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
            ),
            AppNavItem(
              label: 'Trips',
              icon: Icons.explore_outlined,
              selectedIcon: Icons.explore,
              badgeCount: 1,
            ),
            AppNavItem(
              label: 'Profile',
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
            ),
          ];

    final stacks = List.generate(_navKeys.length, (i) {
      return Navigator(
        key: _navKeys[i],
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (_) => _buildRoot(i),
            settings: const RouteSettings(name: 'root'),
          );
        },
      );
    });

    return AppLayout(
      appBar: AppBar(title: Text(destinations[_index].label)),
      body: IndexedStack(index: _index, children: stacks),
      bottomNavigation: AppBottomNav(
        items: destinations,
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        onReselect: _onReselect,
      ),
    );
  }
}

class _TabRoot extends StatelessWidget {
  const _TabRoot({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => _DetailsPage(title: '$title details'),
            ),
          );
        },
        child: Text('Open $title details'),
      ),
    );
  }
}

class _DetailsPage extends StatelessWidget {
  const _DetailsPage({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
