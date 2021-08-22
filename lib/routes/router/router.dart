import 'package:flutter/material.dart';
import 'package:r_launcher/routes/routes/routes.dart';
import 'package:r_launcher/views/base/base.view.dart';
import 'package:r_launcher/views/settings/settings.view.dart';

class CustomRouter {
  static generateRoutes(settings) {
    switch (settings.name) {
      case CustomRoutes.initRoute:
        return MaterialPageRoute(
            builder: (context) => BaseView(), settings: settings);
      case CustomRoutes.settingsRoute:
        return MaterialPageRoute(
            builder: (context) => SettingsView(), settings: settings);
      default:
        return MaterialPageRoute(
            builder: (context) => BaseView(), settings: settings);
    }
  }
}
