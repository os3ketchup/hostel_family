import 'package:flutter/services.dart';

class FileUtils {
  static const MethodChannel _channel = MethodChannel('uz.inSoft.hostels/downloads');

  static Future<String?> getDownloadsDirectory() async {
    try {
      return await _channel.invokeMethod('getExternalStorageDirectory');
    } on PlatformException catch (e) {
      print("Failed to get downloads directory: '${e.message}'.");
      return null;
    }
  }
}