import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  /// Set no of tabs
  static Future<void> setNoOfTabs(int count) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt("nooftabs", count);
  }

  /// Get no of tabs
  static Future<int> getNoOfTabs() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt("nooftabs") ?? 2;
  }

  /// Set index of current tab
  static Future<void> setIndexCurrentTab(int index) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt("currentTab", index);
  }

  /// Get index of current tab
  static Future<int> getIndexCurrentTab() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt("currentTab") ?? 0;
  }
}
