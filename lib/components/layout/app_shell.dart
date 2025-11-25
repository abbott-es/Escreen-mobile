import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/business/auth/roles.dart';
import 'package:flutter_application_1/core/navigation/nav_config.dart';
import 'app_layout.dart';
import 'package:flutter_application_1/components/navigations/app_bottom_nav.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.role});
  final AppRole role;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  late List<GlobalKey<NavigatorState>> _navKeys;
  late List<NavConfig> _tabs;

  @override
  void initState() {
    super.initState();
    _hydrateForRole(widget.role);
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.role != widget.role) {
      _hydrateForRole(widget.role);
      _index = 0;
      setState(() {});
    }
  }

  void _hydrateForRole(AppRole role) {
    _tabs = navConfig[role] ?? [];
    _navKeys = List.generate(_tabs.length, (_) => GlobalKey<NavigatorState>());
  }

  Future<void> _onReselect() async {
    final nav = _navKeys[_index].currentState!;

    while (nav.canPop()) {
      nav.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_tabs.length < 2) {
      return const Scaffold(body: Center(child: Text('No tabs configured')));
    }

    final stacks = List.generate(_navKeys.length, (i) {
      return Navigator(
        key: _navKeys[i],
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (_) => _tabs[i].builder(widget.role),
            settings: const RouteSettings(name: 'root'),
          );
        },
      );
    });

    return AppLayout(
      appBar: AppBar(title: Text(_tabs[_index].label)),
      body: IndexedStack(index: _index, children: stacks),
      bottomNavigation: AppBottomNav(
        items: _tabs
            .map(
              (t) => AppNavItem(
                label: t.label,
                icon: t.icon,
                selectedIcon: t.selectedIcon,
                badgeCount: t.badgeCount,
              ),
            )
            .toList(),
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        onReselect: _onReselect,
      ),
    );
  }
}
