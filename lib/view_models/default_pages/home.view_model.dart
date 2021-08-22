import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  dynamic wallPaperImageBytes;
  void setImageBytes(dynamic bytes) {
    wallPaperImageBytes = bytes;
    notifyListeners();
  }
}
