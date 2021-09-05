import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:r_launcher/theme/theme.provider.dart';
import 'package:r_launcher/view_models/base/base.view_model.dart';
import 'package:r_launcher/view_models/default_pages/apps.view_model.dart';
import 'package:r_launcher/view_models/default_pages/home.view_model.dart';
import 'package:r_launcher/view_models/settings/settings.view_model.dart';

class Providers {
  static final themeProvider = ChangeNotifierProvider((ref) => ThemeProvider());
  static final baseProvider = ChangeNotifierProvider((ref) => BaseProvider());
  static final homeProvider = ChangeNotifierProvider((ref) => HomeProvider());
  static final appProvider = ChangeNotifierProvider((ref) => AppsProvider());
  static final settingsProvider =
      ChangeNotifierProvider((ref) => SettingsProvider());
}
