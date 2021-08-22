import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {
  List<Widget> defaultTabs = [];
  int initialTabIndex = 0;
  void setTabIndex(int index) {
    initialTabIndex = index;
    notifyListeners();
  }

  void setDefaultTabs(List<Widget> tabs) {
    defaultTabs = tabs;
    notifyListeners();
  }
}
