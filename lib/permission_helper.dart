
import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> requestStoragePermissions() async {
    var status = await Permission.storage.status;
    log("=> storage permission satus: $status");
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    if (!status.isPermanentlyDenied) {
      status = await Permission.storage.request();
    }


    return status == PermissionStatus.granted;
  }
}