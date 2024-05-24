import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/network/client.dart';
import 'package:hostels/network/http_result.dart';

import '../variables/links.dart';

final homeProvider = ChangeNotifierProvider<NewsCounter>((ref) {
  return homeCounter;
});

NewsCounter? _newsCounter;
NewsCounter get homeCounter {
  _newsCounter ??= NewsCounter();
  return _newsCounter!;
}



class NewsCounter with ChangeNotifier {
  List<News>? newsList;
  NewsCounter() {
    getNewsList();
  }
  Future<dynamic> getNewsList() async {
    MainModel result = await client.get(Links.getAllNews);
    if (result.data is List) {
      try {
        newsList =
            List<News>.from(result.data.map((news) => News.fromJson(news)));
      } catch (error) {
        newsList = [];
      }
    }
    update();
  }

  void update() {
    notifyListeners();
  }
}

class News {
  News(
      {required this.id,
      required this.title,
      required this.content,
      required this.createdAt,
      required this.imageUrl,
      required this.type});

  String id;
  String title;
  String imageUrl;
  String type;
  String content;
  String createdAt;

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
        id: json['id'].toString(),
        title: json['title'].toString(),
        content: json['content'].toString(),
        createdAt: json['created_at'].toString(),
        imageUrl: json['image'].toString(),
        type: json['type'].toString());
  }
}
