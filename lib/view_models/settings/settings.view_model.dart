import 'dart:async';

import 'package:flutter/material.dart';
import 'package:r_launcher/models/settings.model.dart';
import 'package:r_launcher/services/shared.service.dart';
import 'package:r_launcher/utils/defaullt.utils.dart';

class SettingsProvider extends ChangeNotifier {
  int accentColor;
  String swipeHome = "false";
  List<int> filteredSettings = [];
  String gridCount = "3";
  String appIconSize = "20.0";
  String appIconShape = "";
  String appStartAnimationType = "shrink";
  String searchString = '';
  bool searching = false;
  ScrollController settingsScrollController;
  StreamController<List<Widget>> streamC = StreamController.broadcast();

  void setSearching(bool isSearching) {
    searching = isSearching;
    notifyListeners();
  }

  void setSearchString(String searchS) {
    searchString = searchS;
    notifyListeners();
  }

  void search(String searchText) async {
    if (searchText.trim().length == 0) {
      streamC.sink.add([]);
    } else {
      List<Widget> finalListOfSettings = [];
      List<int> filteredSettingsListIndexes =
          searchIndex(Constants.settingsList, searchText);
      filteredSettings = filteredSettingsListIndexes;
      print(filteredSettingsListIndexes);
      for (int i = 0; i < filteredSettingsListIndexes.length; i++) {
        finalListOfSettings.add(GestureDetector(
          onTap: () {
            searching = false;
            searchString = '';
            notifyListeners();
            // Future.delayed(Duration(seconds: 1), () {
            //   if (settingsScrollController.hasClients)
            //     settingsScrollController.animateTo(200.0 * i,
            //         duration: Duration(seconds: 2),
            //         curve: Curves.fastOutSlowIn);
            // });
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Constants.settingsList[i]["icon"] == null
                    ? CircleAvatar(
                        backgroundColor: Color(accentColor ?? 0000),
                      )
                    : Icon(Constants.settingsList[i]["icon"]),
                title: Text(
                  "   ${Constants.settingsList[i]["name"].toString()}",
                  style: TextStyle(fontSize: 13.0),
                ),
                subtitle: Text(
                  "    ${Constants.settingsList[i]["subtitle"]}",
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
            ),
          ),
        ));
      }
      streamC.sink.add(finalListOfSettings);
    }
  }

  List<int> searchIndex(ls, name) {
    List<int> returnVal = [];
    int i;
    for (i = 0; i < ls.length; i++) {
      if (ls[i]["name"]
          .trim()
          .toLowerCase()
          .contains(name.trim().toLowerCase())) {
        returnVal.add(i);
      }
    }
    if (returnVal.length == 0) {
      return [];
    }
    return returnVal;
  }

  void closeStream() {
    streamC.close();
  }

  void setInit(Settings settings) {
    swipeHome = settings.swipeHome;
    gridCount = settings.gridCount;
    appIconSize = settings.appIconSize;
    appIconShape = settings.appIconShape;
    accentColor = settings.accentColor;
    appStartAnimationType = settings.appStartAnimationType;
    notifyListeners();
  }

  void changeSetting(String settingName, dynamic newValue) async {
    Settings settings = await SharedService.getSettings();
    switch (settingName) {
      case Constants.SWIPE_HOME:
        swipeHome = settings.swipeHome == "false" ? "true" : "false";
        notifyListeners();
        await SharedService.setSettingsJSON(Settings(
            accentColor: settings.accentColor,
            swipeHome: settings.swipeHome == "false" ? "true" : "false",
            gridCount: settings.gridCount,
            appIconShape: settings.appStartAnimationType,
            appIconSize: settings.appIconSize,
            appStartAnimationType: settings.appStartAnimationType));
        break;
      case Constants.GRID_COUNT:
        if (settings.gridCount == newValue) return;
        gridCount = newValue;
        notifyListeners();
        await SharedService.setSettingsJSON(Settings(
            accentColor: settings.accentColor,
            swipeHome: settings.gridCount,
            gridCount: newValue,
            appIconShape: settings.appStartAnimationType,
            appIconSize: settings.appIconSize,
            appStartAnimationType: settings.appStartAnimationType));
        break;
      case Constants.ACCENT_COLOR:
        accentColor = newValue;
        notifyListeners();
        await SharedService.setSettingsJSON(Settings(
            accentColor: newValue,
            swipeHome: settings.swipeHome,
            gridCount: settings.gridCount,
            appIconShape: settings.appStartAnimationType,
            appIconSize: settings.appIconSize,
            appStartAnimationType: settings.appStartAnimationType));
        break;

      default:
        break;
    }
  }
}
