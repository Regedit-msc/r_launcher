import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> checkOrRequestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      PermissionStatus result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        PermissionStatus onemore = await permission.request();
        if (onemore == PermissionStatus.granted) {
          return true;
        } else {
          ///TODO: Create a dialog
          return false;
        }
      }
    }
  }
}
