import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/bootstrap/api_bootstrap.dart';
import 'router/app_router.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApiLayer();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      initialRoute: HomeScreen.route,
      routes: AppRouter.routes,
    );
  }
}
