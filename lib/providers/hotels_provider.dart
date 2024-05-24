import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/widgets.dart';

import '../network/client.dart';
import '../network/http_result.dart';
import '../variables/links.dart';

final hostelsProvider = ChangeNotifierProvider<HostelsCounter>((ref) {
  return hostelsCounter;
});

HostelsCounter? _hostelsCounter;

HostelsCounter get hostelsCounter {
  _hostelsCounter ??= HostelsCounter();
  return _hostelsCounter!;
}

class HostelsCounter with ChangeNotifier {
  List<Hostels>? hostelsList;
  List<Hostels>? searchedList;
  List<FavouriteHotel>? favouriteHotelList;
  List<Category>? categoryList;
  int page = 1;

  HostelsCounter() {
    getHostelsList();
    getCategoryList();
    // getFavouriteHotelList();
  }

  Future<dynamic> getCategoryList() async {
    MainModel result = await client.get(Links.getHotelByCategory);
    if (result.data is List) {
      try {
        categoryList = List<Category>.from(
            result.data.map((category) => Category.fromJSON(category)));
        print('category success');
      } catch (e) {
        print('$e categoryList caught error');
        categoryList = [];
      }
    }
    update();
  }

  List<bool> _searchings = [];

  Future<dynamic> searchHotelByPage({String letter = ''}) async {
    if (_searchings.isEmpty || page == 1) {
      MainModel result =
          await client.get('${Links.searchHotelByName}$letter&page=$page');
      if (result.data['items'] is List) {
        try {
          if (_searchings[0]) {
            searchedList = [];
          }

          searchedList = List<Hostels>.from(
              result.data['items'].map((hostel) => Hostels.fromJSON(hostel)));
          page++;
        } catch (e) {
          print('$e categoryList caught error');
          searchedList = [];
        }
      }
      update();
      _searchings.removeAt(0);
    }
  }

  Future<dynamic> searchHotelByName(String letter) async {
    MainModel result = await client.get('${Links.searchHotelByName}$letter');
    if (result.data['items'] is List) {
      try {
        searchedList = List<Hostels>.from(
            result.data['items'].map((hostel) => Hostels.fromJSON(hostel)));
      } catch (e) {
        print('$e categoryList caught error');
        searchedList = [];
      }
    }
    update();
  }

  Future<dynamic> getHostelsList() async {
    print('hostel default');
    MainModel result = await client.get(Links.getAllHostels);
    print(result.data.toString() + "ppp");
    if (result.data['items'] is List) {
      try {
        hostelsList = List<Hostels>.from(
            result.data['items'].map((hostels) => Hostels.fromJSON(hostels)));
        print('hostel success');
      } catch (error) {
        print("$error nimada");
        hostelsList = [];
      }
    }
    print('out hostel');
    update();
  }

  Future<dynamic> postFavourite({String hotelId = '0'}) async {
    await client.get('${Links.postFavouriteHotel}$hotelId');
    List<Hostels>? myNewHostelList = [];
    for (var element in hostelsList!) {
      if (element.id == hotelId) {
        element.liked = !element.liked;
      }
      myNewHostelList.add(element);
    }
    hostelsList = myNewHostelList;
    searchedList = myNewHostelList;
    update();
  }

  // Future<dynamic> getFavouriteHotelList() async {
  //   MainModel result = await client.get(Links.getFavouriteHotel);
  //   if (result.data is List) {
  //     try {
  //       favouriteHotelList = List<FavouriteHotel>.from(result.data
  //           .map((favouriteHotel) => FavouriteHotel.fromJSON(favouriteHotel)));
  //     } catch (error) {
  //       print("$error nimada");
  //       favouriteHotelList = [];
  //     }
  //   }
  //   update();
  // }

  void update() {
    notifyListeners();
  }
}

class FavouriteHotel {
  FavouriteHotel(
      {required this.discountPrice,
      required this.originalPrice,
      required this.name,
      required this.imageUrl,
      required this.id,
      required this.address});

  String id;
  String name;
  String address;
  String originalPrice;
  String discountPrice;
  String imageUrl;

  factory FavouriteHotel.fromJSON(Map<String, dynamic> json) {
    return FavouriteHotel(
        discountPrice: json['discount_price'].toString(),
        originalPrice: json['original_price'].toString(),
        name: json['name'].toString(),
        imageUrl: json['image'].toString(),
        id: json['id'].toString(),
        address: json['address'].toString());
  }
}

class Category {
  Category({required this.id, required this.name, required this.activeHotels});

  String id;
  String name;
  List<ActiveHotel> activeHotels;

  factory Category.fromJSON(Map<String, dynamic> json) {
    return Category(
        id: json['id'].toString(),
        name: json['name'].toString(),
        activeHotels: List<ActiveHotel>.from(
            json['activeHotels'].map((s) => ActiveHotel.fromJSON(s))));
  }
}

class ActiveHotel {
  ActiveHotel(
      {required this.id,
      required this.originalPrice,
      required this.discountPrice,
      required this.liked,
      required this.rating,
      required this.name,
      required this.address,
      required this.image});

  String id;
  String name;
  String rating;
  bool liked;
  String address;
  String originalPrice;
  String discountPrice;
  String image;

  factory ActiveHotel.fromJSON(Map<String, dynamic> json) {
    return ActiveHotel(
        id: json['id'].toString(),
        originalPrice: json['original_price'].toString(),
        name: json['name'].toString(),
        address: json['address'].toString(),
        image: json['image'].toString(),
        liked: json['liked'],
        rating: json['rating'].toString(),
        discountPrice: json['discount_price'].toString());
  }
}

class Hostels {
  Hostels(
      {required this.id,
      required this.image,
      required this.listFeatures,
      required this.name,
      required this.address,
      required this.description,
      required this.originalPrice,
      required this.discountPrice,
      required this.imageUrls,
      required this.liked,
      required this.rating});

  String id;
  String name;
  String address;
  String description;
  String originalPrice;
  String discountPrice;
  String image;
  List<String> imageUrls;
  String rating;
  List<ActiveFeatures> listFeatures;
  bool liked;

  factory Hostels.fromJSON(Map<String, dynamic> json) {
    return Hostels(
        id: json['id'].toString(),
        listFeatures: List<ActiveFeatures>.from(
            json['activeFeatures'].map((s) => ActiveFeatures.fromJSON(s))),
        name: json['name'].toString(),
        address: json['address'].toString(),
        description: json['description'].toString(),
        originalPrice: json['original_price'].toString(),
        discountPrice: json['discount_price'].toString(),
        imageUrls: json['images'] is List
            ? List<String>.generate((json['images'] as List).length,
                (index) => json['images'][index].toString())
            : [],
        rating: json['rating'].toString(),
        liked: json['liked'],
        image: json['image'].toString());
  }
}

class ActiveFeatures {
  ActiveFeatures(
      {required this.id,
      required this.imageUrl,
      required this.iconCode,
      required this.name});

  String id;
  String name;
  String imageUrl;
  String iconCode;

  factory ActiveFeatures.fromJSON(Map<String, dynamic> json) {
    return ActiveFeatures(
        id: json['id'].toString(),
        imageUrl: json['image'].toString(),
        iconCode: json['icon_code'].toString(),
        name: json['name']);
  }
}
