import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/buttons/app_button.dart';
import 'package:flutter_application_1/components/cards/adaptive_card.dart';

class RequestLists extends StatelessWidget {
  const RequestLists({
    super.key,
    required this.onAccept,
    required this.onReject,
  });
  final void Function(String id) onAccept;
  final void Function(String id) onReject;

  @override
  Widget build(BuildContext context) {
    final items = const [
      ('REQ-8741', 'Ayala Ave → BGC', '2 seats', '₱180'),
      ('REQ-8742', 'Makati → Ortigas', '1 seat', '₱120'),
      ('REQ-8743', 'BGC → Alabang', '2 seats', '₱380'),
    ];

    return Column(
      children: items.map((e) {
        return AdaptiveCard(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: e.$2,
          subtitle: e.$3,
          trailing: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              AppButton(
                onPressed: () => onReject(e.$1),
                label: 'Reject',
                variant: AppButtonVariant.outlined,
              ),
              AppButton(
                onPressed: () => onAccept(e.$1),
                label: 'Accept',
                variant: AppButtonVariant.filled,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class UpcomingRidesList extends StatelessWidget {
  const UpcomingRidesList({super.key, required this.onOpen});
  final void Function(String id) onOpen;

  @override
  Widget build(BuildContext context) {
    final items = const [
      ('RIDE-3011', 'BGC → Makati', 'Today • 9:30 AM', 'Seat 1/3'),
      ('RIDE-3012', 'Kapitolyo → BGC', 'Today • 6:15 PM', 'Seat 2/3'),
      ('RIDE-3013', 'Makati → Ortigas', 'Tomorrow • 8:15 AM', 'Seat 1/3'),
    ];

    return Column(
      children: items.map((e) {
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 360;
              return ListTile(
                isThreeLine: true,
                leading: const CircleAvatar(child: Icon(Icons.directions_car)),
                title: Text(e.$2, overflow: TextOverflow.visible),
                subtitle: Text('${e.$3} • ${e.$4}'),
                trailing: isCompact
                    ? AppButton(
                        onPressed: () => onOpen(e.$1),
                        label: 'Open',
                        variant: AppButtonVariant.filled,
                      )
                    : AppButton(
                        onPressed: () => onOpen(e.$1),
                        label: 'Open',
                        variant: AppButtonVariant.filled,
                      ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
