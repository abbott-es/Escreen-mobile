import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/buttons/app_button.dart';
import 'package:flutter_application_1/core/business/auth/roles.dart';

class LiveCard extends StatelessWidget {
  const LiveCard({super.key, required this.role, required this.isOnline});
  final AppRole role;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDriver = role == AppRole.driver;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(
            isDriver ? Icons.location_on : Icons.schedule,
            size: 28,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isDriver ? 'Next pickup in 12 mins' : 'Next ride at 9:30AM',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  isDriver
                      ? (isOnline
                            ? 'You are online and receiving requests.'
                            : 'You are offline. Go online to get requests.')
                      : 'Pickup: BGC - Dropoff: Makati CBD',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          AppButton(
            onPressed: () {
              //navigation to driver route or details
            },
            label: isDriver ? 'View Route' : 'Details',
            variant: AppButtonVariant.tonal,
          ),
        ],
      ),
    );
  }
}
