import 'package:flutter/material.dart';

class CustomThemes {
  static darkTheme() {
    return ThemeData();
  }

  static lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      textTheme: TextTheme(),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      scrollbarTheme: ScrollbarThemeData(
          isAlwaysShown: false,
          thickness: MaterialStateProperty.all(4),
          thumbColor: MaterialStateProperty.all(Colors.blue),
          showTrackOnHover: true,
          radius: Radius.circular(10),
          minThumbLength: 50),
    );
  }
}
