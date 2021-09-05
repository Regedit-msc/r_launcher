import 'dart:convert';

Settings settingsFromJson(String str) {
  if (str == null) {
    return Settings(
        accentColor: 0000,
        swipeHome: "false",
        gridCount: "3",
        appIconSize: "20.0",
        appIconShape: "");
  }
  Map<String, dynamic> decodedSettings = json.decode(str);
  return Settings.fromJson(decodedSettings);
}

String settingsToJson(Settings data) => json.encode(data.toJson());

class Settings {
  Settings(
      {this.swipeHome,
      this.gridCount,
      this.appIconSize,
      this.appIconShape,
      this.appStartAnimationType,
      this.accentColor});

  int accentColor;
  String swipeHome;
  String gridCount;
  String appIconSize;
  String appIconShape;
  String appStartAnimationType;

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
      swipeHome: json["swipeHome"],
      gridCount: json["gridCount"],
      appIconSize: json["appIconSize"],
      appIconShape: json["appIconShape"],
      appStartAnimationType: json["appStartAnimationShape"],
      accentColor: json["accentColor"]);

  Map<String, dynamic> toJson() => {
        "swipeHome": swipeHome,
        "gridCount": gridCount,
        "appIconSize": appIconSize,
        "appIconShape": appIconShape,
        "appStartAnimationType": appStartAnimationType,
        "accentColor": accentColor
      };
}
