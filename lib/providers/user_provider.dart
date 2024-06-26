import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/network/client.dart';
import 'package:hostels/variables/links.dart';

import '../network/http_result.dart';
import '../variables/util_variables.dart';

final userProvider = ChangeNotifierProvider<Counter>((ref) {
  return userCounter;
});

Counter? _counter;

Counter get userCounter {
  _counter ??= Counter();
  return _counter!;
}

class Counter with ChangeNotifier {
  AppUser? appUser;
  List<UserComment>? userCommentList;
  List<HostelNotification>? hostelNotificationList;

  Counter() {
    appUser = AppUser(
      firstName: pref.getString(PrefKeys.name) ?? '',
      lastName: pref.getString(PrefKeys.surname) ?? '',
      gender: pref.getString(PrefKeys.gender) ?? '',
      bornDate: pref.getString(PrefKeys.born) ?? '',
      authKey: pref.getString(PrefKeys.authKey) ?? '',
      phone: pref.getString(PrefKeys.phoneNumber) ?? '',
      status: pref.getString(PrefKeys.status) ?? '',
      id: pref.getString(PrefKeys.userId) ?? '',
      genderName: pref.getString(PrefKeys.genderName) ?? '',
      img: pref.getString(PrefKeys.photo) ?? '',
    );
  }



  Future<dynamic> getNotificationList() async {
    MainModel result = await client.get(Links.getAllNotification);
    if (result.data is List) {
      try {
        hostelNotificationList = List<HostelNotification>.from(result.data
            .map((notification) => HostelNotification.fromJSON(notification)));
      } catch (e) {
        print('error caught: $e');
        hostelNotificationList = [];
      }
    } else {
      print('result: ${result.status}');
    }
    update();
  }

  Future<dynamic> getUserAllComment() async {
    MainModel result = await client.get(Links.getUserAllComment);

    if (result.data is List) {
      try {
        userCommentList = List<UserComment>.from(result.data
            .map((userComment) => UserComment.fromJSON(userComment)));
      } catch (e) {
        print('$e:  userCommentList error caught');
      }
    }
    update();
  }

  void update() {
    notifyListeners();
  }
}

class UserComment {
  String id;
  String clientId;
  String hotelId;
  String message;
  String rating;
  String createdAt;

  UserComment(
      {required this.id,
      required this.createdAt,
      required this.hotelId,
      required this.rating,
      required this.clientId,
      required this.message});

  factory UserComment.fromJSON(Map<String, dynamic> json) {
    return UserComment(
        id: json['id'].toString(),
        createdAt: json['created_at'].toString(),
        hotelId: json['hotel_id'].toString(),
        rating: json['rating'].toString(),
        clientId: json['client_id'].toString(),
        message: json['message'].toString());
  }
}

class AppUser {
  AppUser({
    required this.img,
    required this.bornDate,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.phone,
    required this.status,
    required this.id,
    required this.authKey,
    required this.genderName,
  });

  String firstName,
      img,
      lastName,
      gender,
      genderName,
      bornDate,
      authKey,
      phone,
      status,
      id;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      firstName: json['first_name'].toString(),
      lastName: json['last_name'].toString(),
      gender: json['gender'].toString(),
      bornDate: json['born_date'].toString(),
      authKey: json['auth_key'].toString(),
      phone: json['phone'].toString(),
      status: json['status'].toString(),
      id: json['id'].toString(),
      genderName: json['gender_name'].toString(),
      img: json['img'],
    );
  }
}

class HostelNotification {
  HostelNotification(
      {required this.id,
      required this.image,
      required this.description,
      required this.title,
      required this.createdAt,
      required this.status});

  String id;
  String image;
  String title;
  String description;
  String createdAt;
  String status;

  factory HostelNotification.fromJSON(Map<String, dynamic> json) {
    return HostelNotification(
        id: json['id'].toString(),
        image: json['image'].toString(),
        description: json['description'].toString(),
        title: json['title'].toString(),
        createdAt: json['created_at'].toString(),
        status: json['status'].toString());
  }
}
