import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/hub/hub_screen.dart';

class AppRouter {
  static final Map<String, WidgetBuilder> routes = {
    HubScreen.route: (_) => const HubScreen(),
  };
}
