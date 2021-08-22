import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:r_launcher/main.dart';
import 'package:r_launcher/providers/providers.dart';

class AppsView extends StatefulWidget {
  const AppsView({Key key}) : super(key: key);

  @override
  _AppsViewState createState() => _AppsViewState();
}

class _AppsViewState extends State<AppsView>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  final TextEditingController searchAppsController = TextEditingController();
  var focusNode = FocusNode();
  @override
  void initState() {
    _getDeviceApps();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    focusNode.addListener(() {
      navigatorKey.currentContext
          .read(Providers.appProvider)
          .setSearching(true);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    searchAppsController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final value = WidgetsBinding.instance.window.viewInsets.bottom;
    if (navigatorKey.currentContext.read(Providers.appProvider).searching !=
        true) return;
    if (value == 0) {
      if (!focusNode.hasPrimaryFocus) {
        focusNode.unfocus();
        searchAppsController.clear();
        navigatorKey.currentContext
            .read(Providers.appProvider)
            .setSearching(false);
      }
    }
  }

  void _getDeviceApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: true,
        includeAppIcons: true);
    List<Application> currentAppList =
        navigatorKey.currentContext.read(Providers.appProvider).apps;
    if (currentAppList != null) return;
    navigatorKey.currentContext.read(Providers.appProvider).setAppsList(apps);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        bool searching =
            navigatorKey.currentContext.read(Providers.appProvider).searching;
        if (searching != true) return;
        focusNode.unfocus();
        searchAppsController.clear();
        navigatorKey.currentContext
            .read(Providers.appProvider)
            .setSearching(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            child: Stack(
              children: [
                Consumer(builder: (context, watch, child) {
                  final homeProvider = watch(Providers.homeProvider);
                  return homeProvider.wallPaperImageBytes != null
                      ? Container(
                          height: MediaQuery.of(context).size.height,
                          width: double.infinity,
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.9),
                                BlendMode.darken),
                            child: Image.memory(
                              homeProvider.wallPaperImageBytes,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              colorBlendMode: BlendMode.darken,
                            ),
                          ))
                      : Center(
                          child: Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        ));
                }),
                Positioned(
                  top: 40.0,
                  bottom: 2.0,
                  child: Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    width: MediaQuery.of(context).size.width - 32.0,
                    child: TextField(
                        focusNode: focusNode,
                        controller: searchAppsController,
                        cursorHeight: 30.0,
                        onChanged: (v) {
                          navigatorKey.currentContext
                              .read(Providers.appProvider)
                              .search(v);
                        },
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                        decoration: InputDecoration(
                            hintText: ' Search apps',
                            hintStyle:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.3),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 0.3),
                            ),
                            border: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.3),
                            ),
                            prefixIcon:
                                Consumer(builder: (context, watch, child) {
                              final appProvider = watch(Providers.appProvider);
                              return GestureDetector(
                                onTap: () {
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                  currentFocus.unfocus();
                                  searchAppsController.clear();
                                  navigatorKey.currentContext
                                      .read(Providers.appProvider)
                                      .setSearching(false);
                                },
                                child: Icon(
                                  appProvider.searching
                                      ? Icons.arrow_back                                      : Icons.search,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                              );
                            }))),
                  ),
                ),
                Consumer(builder: (context, watch, child) {
                  final appsProvider = watch(Providers.appProvider);
                  return appsProvider.apps != null
                      ? Positioned(
                          top: 95.0,
                          left: 2.0,
                          right: 2.0,
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            child: Consumer(builder: (context, watch, child) {
                              final appsProvider = watch(Providers.appProvider);
                              return appsProvider.apps != null
                                  ? appsProvider.searching
                                      ? Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              1.15,
                                          child: TweenAnimationBuilder(
                                            curve: Curves.easeIn,
                                            duration: Duration(seconds: 2),
                                            tween: Tween<double>(
                                                begin: 0, end: 1.0),
                                            builder: (context, double _val,
                                                Widget child) {
                                              return Opacity(
                                                opacity: _val,
                                                child: child,
                                              );
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Scrollbar(
                                                radius: Radius.circular(10),
                                                isAlwaysShown: false,
                                                showTrackOnHover: true,
                                                child: StreamBuilder(
                                                    stream: appsProvider
                                                        .streamC.stream,
                                                    builder:
                                                        (context, snapshot) {
                                                      return snapshot.hasData
                                                          ? GridView.count(
                                                              mainAxisSpacing:
                                                                  20.0,
                                                              shrinkWrap: true,
                                                              crossAxisSpacing:
                                                                  20.0,
                                                              physics:
                                                                  BouncingScrollPhysics(),
                                                              crossAxisCount: 3,
                                                              children:
                                                                  List.generate(
                                                                      snapshot
                                                                          .data
                                                                          .length,
                                                                      (index) {
                                                                if (snapshot
                                                                        .data ==
                                                                    []) {
                                                                  return Text(
                                                                      "Check your spelling app not found.");
                                                                }
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    appsProvider.startApp(
                                                                        snapshot
                                                                            .data[index]
                                                                            .packageName,
                                                                        "shrink");
                                                                  },
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            200,
                                                                        decoration:
                                                                            ShapeDecoration(
                                                                          shape:
                                                                              CircleBorder(),
                                                                        ),
                                                                        child: Image
                                                                            .memory(
                                                                          (snapshot.data[index] as ApplicationWithIcon)
                                                                              .icon,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10.0,
                                                                      ),
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                70,
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                snapshot.data[index].appName,
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              }))
                                                          : Container();
                                                    }),
                                              ),
                                            ),
                                          ),
                                        )
                                      : TweenAnimationBuilder(
                                          builder: (context, double _val,
                                              Widget child) {
                                            return Opacity(
                                              opacity: _val,
                                              child: child,
                                            );
                                          },
                                          curve: Curves.easeIn,
                                          duration: Duration(seconds: 2),
                                          tween:
                                              Tween<double>(begin: 0, end: 1.0),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                1.15,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Scrollbar(
                                                radius: Radius.circular(10),
                                                isAlwaysShown: false,
                                                showTrackOnHover: true,
                                                child: GridView.count(
                                                    mainAxisSpacing: 20.0,
                                                    shrinkWrap: true,
                                                    crossAxisSpacing: 20.0,
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    crossAxisCount: 3,
                                                    children: List.generate(
                                                        appsProvider
                                                            .apps.length,
                                                        (index) =>
                                                            GestureDetector(
                                                              onTap: () {
                                                                appsProvider.startApp(
                                                                    appsProvider
                                                                        .apps[
                                                                            index]
                                                                        .packageName,
                                                                    "shrink");
                                                              },
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    height: 50,
                                                                    width: 200,
                                                                    decoration:
                                                                        ShapeDecoration(
                                                                      shape:
                                                                          CircleBorder(),
                                                                    ),
                                                                    child: Image
                                                                        .memory(
                                                                      (appsProvider.apps[index]
                                                                              as ApplicationWithIcon)
                                                                          .icon,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        10.0,
                                                                  ),
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            70,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            appsProvider.apps[index].appName,
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ))),
                                              ),
                                            ),
                                          ),
                                        )
                                  : Positioned(
                                      top: MediaQuery.of(context).size.height /
                                          2,
                                      child: Center(
                                          child: Container(
                                        width: 50,
                                        height: 50,
                                        child: CircularProgressIndicator(),
                                      )),
                                    );
                            }),
                          ))
                      : SizedBox();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
