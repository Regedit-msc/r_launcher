import 'dart:async';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:r_launcher/utils/defaullt.utils.dart';

class AppsProvider extends ChangeNotifier {
  List<Application> apps;
  String searchAppString = '';
  bool searching = false;
  StreamController<List<Application>> streamC = StreamController.broadcast();
  void setSearching(bool isSearching) {
    searching = isSearching;
    notifyListeners();
  }

  void setSearchString(String searchString) {
    searchAppString = searchString;
    notifyListeners();
  }

  void search(String searchText) async {
    if (searchText.trim().length == 0) {
      streamC.sink.add([]);
    } else {
      List<Application> filteredAppList = apps
          .where((app) =>
              app.appName.toLowerCase().startsWith(searchText.toLowerCase()))
          .toList();
      filteredAppList.sort((a, b) => a.appName.compareTo(b.appName));
      streamC.sink.add(filteredAppList);
    }
  }

  void closeStream() {
    streamC.close();
  }

  void setAppsList(List<Application> appsList) {
    appsList.sort((a, b) => a.appName.compareTo(b.appName));
    apps = appsList;
    notifyListeners();
  }

  Future<void> startApp(String packageName, String animationType) async {
    await Constants.PLATFORM.invokeMethod(Constants.APPS_METHOD,
        {"name": packageName, "animationType": animationType});
  }
}
