import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppNavItem {
  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final int? badgeCount;
  final bool showDot;

  AppNavItem({
    required this.label,
    required this.icon,
    this.badgeCount,
    this.showDot = false,
    this.selectedIcon,
  });
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.onReselect,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.elevation,
  });

  final List<AppNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback? onReselect;

  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return isIOS
        ? _buildCupertino(context, scheme)
        : _buildMaterial(context, scheme);
  }

  Widget _buildMaterial(BuildContext context, ColorScheme scheme) {
    final destinations = <NavigationDestination>[];
    for (int i = 0; i < items.length; i++) {
      final it = items[i];
      destinations.add(
        NavigationDestination(
          icon: _withBadge(Icon(it.icon), it),
          label: it.label,
          selectedIcon: _withBadge(
            Icon(it.selectedIcon ?? it.icon),
            it,
            selected: true,
          ),
        ),
      );
    }

    return NavigationBar(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
      elevation: elevation,
      selectedIndex: currentIndex,
      destinations: destinations,
      onDestinationSelected: (idx) {
        HapticFeedback.selectionClick();
        if (idx == currentIndex) {
          onReselect?.call();
        } else {
          onTap(idx);
        }
      },
    );
  }

  Widget _buildCupertino(BuildContext context, ColorScheme scheme) {
    return CupertinoTabBar(
      backgroundColor:
          backgroundColor ?? CupertinoTheme.of(context).barBackgroundColor,
      activeColor: activeColor ?? scheme.primary,
      inactiveColor: inactiveColor ?? scheme.onSurfaceVariant,
      currentIndex: currentIndex,
      onTap: (idx) {
        HapticFeedback.selectionClick();
        if (idx == currentIndex) {
          onReselect?.call();
        } else {
          onTap(idx);
        }
      },
      items: items.map((it) {
        return BottomNavigationBarItem(
          label: it.label,
          icon: _withBadge(Icon(it.icon, size: 24), it),
          activeIcon: _withBadge(
            Icon(it.selectedIcon ?? it.icon, size: 24),
            it,
            selected: true,
          ),
        );
      }).toList(),
    );
  }

  Widget _withBadge(Widget icon, AppNavItem it, {bool selected = false}) {
    final showCount = (it.badgeCount ?? 0) > 0;
    final showDot = it.showDot == true && !showCount;

    if (!showCount && !showDot) return icon;

    final badge = Container(
      padding: showCount
          ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: showCount ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: showCount ? BorderRadius.circular(10) : null,
      ),
      constraints: BoxConstraints(
        minWidth: showCount ? 0 : 8,
        minHeight: showCount ? 0 : 8,
      ),
      child: showCount
          ? Text(
              '${it.badgeCount}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                height: 1,
              ),
            )
          : const SizedBox(width: 8, height: 8),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        icon,
        Positioned(child: badge, right: -6, top: -2),
      ],
    );
  }
}
