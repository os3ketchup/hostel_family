import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/providers/comment_provider.dart';
import 'package:hostels/ui/home/detail_room/comments_item.dart';
import 'package:hostels/ui/home/detail_room/detail/custom_alertdialog.dart';
import 'package:hostels/ui/home/detail_room/order/order_appbar.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';

import '../../../../../providers/hotels_provider.dart';

class AllCommentScreen extends StatefulWidget {
  const AllCommentScreen(
      {super.key,
      required this.commentList,
      required this.hotelId,
      required this.hostel});

  final List<Comment> commentList;
  final int hotelId;
  final Hostels hostel;

  @override
  State<AllCommentScreen> createState() => _AllCommentScreenState();
}

class _AllCommentScreenState extends State<AllCommentScreen> {
 
  
  @override
  Widget build(BuildContext context) {
   
    ThemeData mTheme = Theme.of(context);
   
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.o),
          child: OrderAppBar(
            titleAppbar: comments.tr,
            onBackPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Consumer(
        builder: (context, ref, child) {
          final notifier = ref.watch(commentProvider);
          return Stack(
            children: [
              ListView.builder(
                padding: EdgeInsets.only(bottom: 30.o,top: 10.o),
                scrollDirection: Axis.vertical,
                itemCount:
                    getFilteredComment(notifier.commentList!, widget.hostel)
                        .length,
                itemBuilder: (context, index) {
                  return CommentsItem(
                    comment: notifier.commentList![index],
                    rating: double.tryParse(
                          notifier.commentList![index].rating,
                        ) ??
                        0.0,
                  );
                },
              ),
              Container(
                alignment: Alignment.bottomRight,
                width: double.infinity,
                height: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        var width = MediaQuery.of(context).size.width;
                        return CustomAlertDialog(commentNotifier: notifier, hotelId: widget.hotelId, width: width,);
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.o),
                    decoration: BoxDecoration(
                        color: mTheme.colorScheme.primary,
                        borderRadius: BorderRadius.all(Radius.circular(12.o))),
                    margin: EdgeInsets.all(30.w),
                    width: 320.w,
                    height: 50.h,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 225.w,
                          child: Text(
                            maxLines: 2,
                            leaveComment.tr,
                            style: theme.primaryTextStyle
                                .copyWith(color: theme.white,fontSize: 12.o),
                          ),
                        ),
                        Icon(
                          Icons.comment,
                          color: theme.white,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  List<Comment> getFilteredComment(List<Comment> allComment, Hostels hostel) {
    List<Comment> filteredComment = [];
    for (var comment in allComment) {
      if (comment.hotelId == hostel.name) {
        filteredComment.add(comment);
      }
    }
    return filteredComment;
  }
}
