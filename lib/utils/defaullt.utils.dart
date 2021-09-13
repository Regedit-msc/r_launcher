import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:r_launcher/views/default_pages/apps.view.dart';
import 'package:r_launcher/views/default_pages/home.view.dart';
import 'package:r_launcher/widgets/Anims/custom.router.dart';

import '../main.dart';

class Constants {
  static const PLATFORM = MethodChannel("com.mdot.r_launcher/channels");
  static const APP_EVENTS = EventChannel("com.mdot.r_launcher/events/apps");
  static const String WALLPAPER_METHOD = "wallpaper";
  static const String APPS_METHOD = "apps";
  static const String PERMISSION = "permission";
  static const String CHECK_PERMISSION = "checkPermission";
  static const String SWIPE_HOME = "swipeHome";
  static const String GRID_COUNT = "gridCount";
  static const String ACCENT_COLOR = "accentColor";
  static const List<Map<String, dynamic>> settingsList = [
    {
      "name": "Swipe Up apps",
      "icon": FontAwesomeIcons.handHolding,
      "subtitle": ""
    },
    {
      "name": "Use device wallpaper",
      "icon": FontAwesomeIcons.images,
      "subtitle": ""
    },
    {"name": "Accent color", "icon": null, "subtitle": ""}
  ];
  static replace(String routeName) {
    Navigator.pushReplacementNamed(navigatorKey.currentContext, routeName);
  }

  static to(String routeName) {
    Navigator.pushNamed(navigatorKey.currentContext, routeName);
  }

  static toWithData(Widget whateverWidget) {
    Navigator.push(
        navigatorKey.currentContext, CustomPageRoute(child: whateverWidget));
  }

  static List<Widget> initialTabs = [
    HomeView(),
    AppsView(),
  ];
}
