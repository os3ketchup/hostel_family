import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/client.dart';
import '../network/http_result.dart';
import '../variables/links.dart';
import 'hotels_provider.dart';

final roomProvider = ChangeNotifierProvider<RoomCounter>((ref) {
  return roomCounter;
});

RoomCounter? _roomCounter;

RoomCounter get roomCounter {
  _roomCounter ??= RoomCounter();
  return _roomCounter!;
}

class RoomCounter with ChangeNotifier {
  List<Room>? roomList;
  List<Room>? allRoomList;


  // RoomCounter(){
  //   getRoomList(0, roomNumber, adultCount, childCount)
  // }

  Future<dynamic> getRoomList({
    required String hotelId,
    required int roomNumber,
    required int adultCount,
    required int childCount,
    required String startedDate,
    required String finishedSDate,
  }) async {
    MainModel result = await client.get(
        '${Links.getRoomByFilter}$hotelId&startedDate=$startedDate&finishedDate=$finishedSDate&roomNumber=$roomNumber&adultCount=$adultCount&childCount=$childCount');
    if(result.status==200){
      if (result.data is List) {
        try {
          roomList =
          List<Room>.from(result.data.map((room) => Room.fromJSON(room)));
        } catch (error) {
          print("$error room ishlamayapti");
          roomList = [];
        }
      }if (result.data.toString().isEmpty){
        roomList = [];
        print('data pustoy');
      }
    }else{
      print('else');
      roomList = [];
    }
    update();
  }

  Future<dynamic> getAllRoom({required String hotelId}) async {
    MainModel result = await client.get(
        Links.getRoom+hotelId);
    if(result.status==200){
      if (result.data is List) {
        try {
          allRoomList =
          List<Room>.from(result.data.map((room) => Room.fromJSON(room)));

        } catch (error) {
          print("$error room ishlamayapti");
          allRoomList = [];

        }
      }if (result.data.toString().isEmpty){
        allRoomList = [];

        print('data pustoy');
      }
    }else{
      print('else');
      allRoomList = [];

    }
    update();
  }


  void update() {
    notifyListeners();
  }
}

class Room {
  Room(
      {required this.id,
      required this.discountPrice,
      required this.name,
      required this.activeFeatures,
      required this.originalPrice,
      required this.imageUrl,
      required this.adultCount,
      required this.childCount,
      required this.hotelId,
      required this.images,
      required this.roomCount,
      required this.roomNumber});

  String id;
  String hotelId;
  String name;
  String discountPrice;
  String originalPrice;
  String roomNumber;
  String roomCount;
  String childCount;
  String adultCount;
  String imageUrl;
  List<String> images;
  List<ActiveFeatures> activeFeatures;

  factory Room.fromJSON(Map<String, dynamic> json) {
    return Room(
        id: json['id'].toString(),
        name: json['name'].toString(),
        activeFeatures: List<ActiveFeatures>.from(
            json['activeFeatures'].map((s) => ActiveFeatures.fromJSON(s))),
        originalPrice: json['original_price'].toString(),
        imageUrl: json['imageUrl'].toString(),
        adultCount: json['adult_count'].toString(),
        childCount: json['child_count'].toString(),
        hotelId: json['hotel_id'].toString(),
        images:  json['images'] is List
            ? List<String>.generate((json['images'] as List).length,
                (index) => json['images'][index].toString())
            : [],
        roomCount: json['room_count'].toString(),
        roomNumber: json['room_number'].toString(),
        discountPrice: json['discount_price'].toString(),);
  }
}
