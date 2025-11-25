import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/business/auth/roles.dart';

class KpiGrid extends StatelessWidget {
  const KpiGrid({super.key, required this.role});
  final AppRole role;

  @override
  Widget build(BuildContext context) {
    final cards = role == AppRole.driver ? _driverKpis() : _passengerKpis();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, i) => _KpiCard(data: cards[i]),
    );
  }

  List<_KpiCardData> _driverKpis() => [
    _KpiCardData('Earnings', '₱1,540', Icons.payments, Colors.green),
    _KpiCardData('Completed', '8', Icons.event_available, Colors.teal),
  ];

  List<_KpiCardData> _passengerKpis() => [
    _KpiCardData('Upcoming', '3', Icons.calendar_today, Colors.blue),
    _KpiCardData('Credits', '₱420', Icons.wallet, Colors.purple),
  ];
}

class _KpiCardData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  _KpiCardData(this.title, this.value, this.icon, this.color);
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.data});
  final _KpiCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: data.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: data.color),
          const Spacer(),
          Text(
            data.value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(data.title),
        ],
      ),
    );
  }
}
