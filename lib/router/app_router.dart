import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

class AppRouter {
  static final Map<String, WidgetBuilder> routes = {
    HomeScreen.route: (_) => const HomeScreen(),
  };
}
