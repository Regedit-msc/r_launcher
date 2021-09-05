import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:r_launcher/providers/providers.dart';
import 'package:r_launcher/utils/defaullt.utils.dart';

import '../../main.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key key}) : super(key: key);
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  final TextEditingController searchController = TextEditingController();
  var focusNode = FocusNode();
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  void changeColor(Color color) {
    int colorValue = color.value;
    navigatorKey.currentContext
        .read(Providers.settingsProvider)
        .changeSetting(Constants.ACCENT_COLOR, colorValue);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: color,
    ));
  }

  @override
  void dispose() {
    searchController.dispose();
    navigatorKey.currentContext.read(Providers.settingsProvider).dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    focusNode.addListener(() {
      navigatorKey.currentContext
          .read(Providers.settingsProvider)
          .setSearching(true);
    });
  }

  void didChangeMetrics() {
    super.didChangeMetrics();
    final value = WidgetsBinding.instance.window.viewInsets.bottom;
    if (navigatorKey.currentContext
            .read(Providers.settingsProvider)
            .searching !=
        true) return;
    if (value == 0) {
      if (!focusNode.hasPrimaryFocus) {
        focusNode.unfocus();
        searchController.clear();
        navigatorKey.currentContext
            .read(Providers.settingsProvider)
            .setSearching(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 40.0,
          ),
          Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            width: MediaQuery.of(context).size.width - 32.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Consumer(
                    builder: (context, watch, child) {
                      final settingsProvider =
                          watch(Providers.settingsProvider);
                      return TextField(
                          cursorColor: Color(settingsProvider.accentColor),
                          focusNode: focusNode,
                          controller: searchController,
                          cursorHeight: 30.0,
                          onChanged: (v) {
                            navigatorKey.currentContext
                                .read(Providers.settingsProvider)
                                .search(v);
                            navigatorKey.currentContext
                                .read(Providers.settingsProvider)
                                .setSearchString(v);
                          },
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                          decoration: InputDecoration(
                              suffixIcon:
                                  Consumer(builder: (context, watch, child) {
                                final settingsProvider =
                                    watch(Providers.settingsProvider);
                                return settingsProvider.searching &&
                                        settingsProvider.searchString.length > 0
                                    ? GestureDetector(
                                        onTap: () {
                                          searchController.clear();
                                          settingsProvider.setSearchString('');
                                        },
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                          size: 20.0,
                                        ),
                                      )
                                    : Icon(Icons.clear,
                                        color: Colors.transparent);
                              }),
                              hintText: ' Search settings',
                              hintStyle: TextStyle(
                                  fontSize: 17.0, color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.3),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(settingsProvider.accentColor),
                                    width: 0.3),
                              ),
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.3),
                              ),
                              prefixIcon:
                                  Consumer(builder: (context, watch, child) {
                                final settingsProvider =
                                    watch(Providers.settingsProvider);
                                return GestureDetector(
                                  onTap: () {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);
                                    currentFocus.unfocus();
                                    searchController.clear();
                                    navigatorKey.currentContext
                                        .read(Providers.settingsProvider)
                                        .setSearching(false);
                                  },
                                  child: Icon(
                                    settingsProvider.searching
                                        ? Icons.arrow_back
                                        : Icons.search,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                );
                              })));
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Consumer(
            builder: (context, watch, child) {
              final settingsProvider = watch(Providers.settingsProvider);
              return settingsProvider.searching == false
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      controller: settingsProvider.settingsScrollController,
                      child: Column(
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 4, bottom: 4),
                              child: Consumer(
                                builder: (context, watch, child) {
                                  final settingsProvider =
                                      watch(Providers.settingsProvider);
                                  return SwitchListTile(
                                    inactiveThumbColor: Colors.grey,
                                    activeColor:
                                        Color(settingsProvider.accentColor),
                                    value: settingsProvider.swipeHome == "true",
                                    onChanged: (value) {
                                      navigatorKey.currentContext
                                          .read(Providers.settingsProvider)
                                          .changeSetting(
                                              Constants.SWIPE_HOME, '');
                                      Fluttertoast.showToast(
                                          msg: "Successfully changed setting",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Color(navigatorKey
                                              .currentContext
                                              .read(Providers.settingsProvider)
                                              .accentColor),
                                          textColor: Colors.white,
                                          fontSize: 13.0);
                                    },
                                    title: Text(
                                      "Swipe Up Apps",
                                      style: TextStyle(fontSize: 13.0),
                                    ),
                                    subtitle: Text(
                                      "Swipe up to view app drawer.",
                                      style: TextStyle(fontSize: 13.0),
                                    ),
                                    secondary:
                                        Icon(FontAwesomeIcons.handHolding),
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 4, bottom: 4),
                              child: Consumer(builder: (context, watch, child) {
                                final settingsProvider =
                                    watch(Providers.settingsProvider);
                                return SwitchListTile(
                                  inactiveThumbColor: Colors.grey,
                                  activeColor:
                                      Color(settingsProvider.accentColor),
                                  value: true,
                                  onChanged: (value) {},
                                  title: Text(
                                    'Use device wallpaper',
                                    style: TextStyle(fontSize: 13.0),
                                  ),
                                  subtitle: Text(
                                    "Use device wallpaper as launcher's wallpaper.",
                                    style: TextStyle(fontSize: 13.0),
                                  ),
                                  secondary: Icon(FontAwesomeIcons.images),
                                );
                              }),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Choose a color'),
                                  content: SingleChildScrollView(
                                    child: ColorPicker(
                                      pickerColor: Color(navigatorKey
                                          .currentContext
                                          .read(Providers.settingsProvider)
                                          .accentColor),
                                      onColorChanged: changeColor,
                                      showLabel: true,
                                      pickerAreaHeightPercent: 0.8,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: const Text('Done'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Fluttertoast.showToast(
                                            msg: "Successfully changed color",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Color(navigatorKey
                                                .currentContext
                                                .read(
                                                    Providers.settingsProvider)
                                                .accentColor),
                                            textColor: Colors.white,
                                            fontSize: 13.0);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              child: ListTile(
                                leading: Consumer(
                                  builder: (context, watch, child) {
                                    final settingsProvider =
                                        watch(Providers.settingsProvider);
                                    return CircleAvatar(
                                      backgroundColor: Color(
                                          settingsProvider.accentColor ?? 0000),
                                    );
                                  },
                                ),
                                title: Text(
                                  "   Accent color",
                                  style: TextStyle(fontSize: 13.0),
                                ),
                                subtitle: Text(
                                  "   Accent color of the launcher.",
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : StreamBuilder(
                      stream: settingsProvider.streamC.stream,
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [...snapshot.data],
                                ),
                              )
                            : Container();
                      });
            },
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
