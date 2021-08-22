import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:r_launcher/main.dart';
import 'package:r_launcher/providers/providers.dart';
import 'package:r_launcher/services/permission.service.dart';
import 'package:r_launcher/utils/defaullt.utils.dart';
import 'package:r_launcher/views/settings/settings.view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    checkAndSetDefault();
    super.initState();
  }

  void checkAndSetDefault() async {
    String isGranted =
        await Constants.PLATFORM.invokeMethod(Constants.CHECK_PERMISSION);
    print(isGranted);
    if (isGranted == "true") {
      print("No worries");
      _setWallPaper();
    } else {
      print("Wahala");
      bool done = await Constants.PLATFORM.invokeMethod(Constants.PERMISSION);
      if (done) {
        _setWallPaper();
      }
    }
  }

  void _setWallPaper() async {
    bool isStorageAccessGranted =
        await PermissionService.checkOrRequestPermission(Permission.storage);
    dynamic currentWallPaperBytes = navigatorKey.currentContext
        .read(Providers.homeProvider)
        .wallPaperImageBytes;
    if (currentWallPaperBytes != null) return;
    if (isStorageAccessGranted) {
      dynamic bytes;
      try {
        bytes =
            await Constants.PLATFORM.invokeMethod(Constants.WALLPAPER_METHOD);
        navigatorKey.currentContext
            .read(Providers.homeProvider)
            .setImageBytes(bytes);
      } on PlatformException catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(alignment: Alignment.center, children: [
        Consumer(builder: (context, watch, child) {
          final homeProvider = watch(Providers.homeProvider);
          return homeProvider.wallPaperImageBytes != null
              ? TweenAnimationBuilder(
                  curve: Curves.easeIn,
                  duration: Duration(seconds: 2),
                  tween: Tween<double>(begin: 0, end: 1.0),
                  builder: (context, double _val, Widget child) {
                    return Opacity(
                      opacity: _val,
                      child: child,
                    );
                  },
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      child: Image.memory(
                        homeProvider.wallPaperImageBytes,
                        fit: BoxFit.cover,
                      )),
                )
              : Container(
                  color: Colors.black,
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  ));
        }),
        GestureDetector(
          onTap: () {
            Constants.toWithData(SettingsView());
          },
          child: Consumer(builder: (context, watch, child) {
            final homeProvider = watch(Providers.homeProvider);
            return homeProvider.wallPaperImageBytes != null
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        child: CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              FontAwesomeIcons.cogs,
                              color: Colors.white,
                              size: 25.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container();
          }),
        ),
      ]),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
