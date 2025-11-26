import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/business/auth/roles.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/kpi_grid.dart';
import 'widgets/action_grid.dart';
import 'widgets/live_card.dart';
import 'widgets/request_lists.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.role, this.userName});
  final AppRole role;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    final isDriver = role == AppRole.driver;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DashboardHeader(role: role, userName: userName),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(child: KpiGrid(role: role)),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: ActionGrid(role: role, actions: []),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: LiveCard(role: role, isOnline: true),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: const SliverToBoxAdapter(child: Divider()),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: isDriver
                  ? RequestLists(
                      onAccept: (id) => _showSnack(context, 'Accepted $id'),
                      onReject: (id) => _showSnack(context, 'Rejected $id'),
                    )
                  : UpcomingRidesList(
                      onOpen: (id) => _showSnack(context, 'Opening ride $id'),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
