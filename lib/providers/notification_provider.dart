import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/network/client.dart';
import 'package:hostels/network/http_result.dart';
import 'package:hostels/variables/links.dart';

final notificationProvider = ChangeNotifierProvider<NotificationCounter>((ref) {
  return notificationCounter;
});

NotificationCounter? _notificationCounter;
NotificationCounter get notificationCounter{
  _notificationCounter??=NotificationCounter();
  return _notificationCounter!;
}

class NotificationCounter with ChangeNotifier {


  void update() {
    notifyListeners();
  }
}



