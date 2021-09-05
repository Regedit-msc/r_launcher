import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:r_launcher/models/settings.model.dart';
import 'package:r_launcher/providers/providers.dart';
import 'package:r_launcher/routes/router/router.dart';
import 'package:r_launcher/services/shared.service.dart';
import 'package:r_launcher/theme/theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Settings setting = await SharedService.getSettings();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Color(setting.accentColor),
    statusBarColor: Colors.transparent,
  ));

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(ProviderScope(child: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final themeNotifier = watch(Providers.themeProvider);
      return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: themeNotifier.lighttheme
            ? CustomThemes.lightTheme()
            : ThemeData.dark(),
        darkTheme: ThemeData.dark(),
        title: 'R Launcher',
        initialRoute: '/',
        onGenerateRoute: (settings) => CustomRouter.generateRoutes(settings),
      );
    });
  }
}
