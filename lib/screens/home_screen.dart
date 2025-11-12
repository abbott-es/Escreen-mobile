import 'package:flutter/material.dart';
import '../components/layout/app_layout.dart';

Future<String> fetchSomething() async {
  await Future.delayed(const Duration(milliseconds: 600));
  return 'Lols';
}

class HomeScreen extends StatelessWidget {
  static const route = '/';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchSomething(),
      builder: (context, snapshot) {
        final title = switch (snapshot.connectionState) {
          ConnectionState.waiting => 'Loading…',
          _ when snapshot.hasError => 'Error',
          _ => 'Welcome, ${snapshot.data}',
        };

        return AppLayout(
          appBar: AppBar(title: Text(title)),
          body: const Center(child: Text('Home content')),
          bottomActions: [],
        );
      },
    );
  }
}
