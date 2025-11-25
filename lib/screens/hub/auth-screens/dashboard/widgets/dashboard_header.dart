import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/business/auth/roles.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key, required this.role, this.userName});
  final AppRole role;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = role == AppRole.driver ? 'Driver Hub' : 'Passenger Hub';
    final greeting = _greeting();

    return SliverAppBar(
      pinned: true,
      floating: false,
      toolbarHeight: 72,
      backgroundColor: theme.colorScheme.surface,

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    final name = userName ?? 'there';
    if (hour < 12) return 'Good morning, $name';
    if (hour < 18) return 'Good afternoon, $name';
    return 'Good evening, $name';
  }
}
