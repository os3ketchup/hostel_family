import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/network/client.dart';
import 'package:hostels/variables/links.dart';

import '../network/http_result.dart';

final commentProvider = ChangeNotifierProvider((ref) {
  return commentCounter;
});

CommentCounter? _commentCounter;

CommentCounter get commentCounter {
  _commentCounter = CommentCounter();
  return _commentCounter!;
}

class CommentCounter with ChangeNotifier {
  List<Comment>? commentList;



  Future<dynamic> getCommentsList(String hotelId) async {
    MainModel result = await client.post('${Links.getAllComment}$hotelId');
    if (result.data is List) {
      try {
        commentList = List<Comment>.from(
            result.data.map((comment) => Comment.fromJson(comment)));
      } catch (error) {
        print("$error nimadaa");
        commentList = [];
      }
    }
    update();
  }

  Future<dynamic> postComment(
      int hotelId, String comment, double rating) async {
    MainModel result =
        await client.post('${Links.writeComment}$hotelId', data: {
      'rating': rating,
      'message': comment,
    });
    if (result.data is List) {
      try {
        commentList = List<Comment>.from(
            result.data.map((comment) => Comment.fromJson(comment)));
      } catch (error) {
        print("$error comment qoldirishda xatolik");
        commentList = [];
      }
    }
    update();
  }

  // void postComment() async {
  //   await client.post('${Links.writeComment}1',data: {
  //     'rating':1.0,
  //     'message':'this is example'
  //   }).then(
  //         (value) {},
  //   );
  // }


  void update() {
    notifyListeners();
  }
}

class Comment {
  Comment(
      {required this.id,
        required this.clientImage,
      required this.createdAt,
      required this.clientId,
      required this.hotelId,
      required this.message,
      required this.rating});

  String id;
  String clientId;
  String clientImage;
  String hotelId;
  String message;
  String rating;
  String createdAt;

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'].toString(),
        createdAt: json['created_at'].toString(),
        clientId: json['client_id'].toString(),
        hotelId: json['hotel_id'].toString(),
        message: json['message'].toString(),
        rating: json['rating'].toString(), clientImage: json['client_image'].toString());
  }
}
