import 'package:flutter/material.dart';
import '../../components/layout/app_layout.dart';

class HubScreen extends StatelessWidget {
  static const route = '/hub';
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: AppBar(title: Text('Hub')),
      body: const Center(child: Text('Hub content')),
      bottomActions: [],
    );
  }
}
