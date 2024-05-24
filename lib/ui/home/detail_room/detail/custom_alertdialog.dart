import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hostels/providers/comment_provider.dart';
import 'package:hostels/providers/hotels_provider.dart';
import 'package:hostels/providers/user_provider.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../../apptheme.dart';
import '../../../../variables/images.dart';

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog(
      {super.key,
      required this.commentNotifier,
      required this.hotelId,
      required this.width});

  final CommentCounter commentNotifier;
  final int hotelId;
  final double width;

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  final TextEditingController _commentController = TextEditingController();
  bool isEmpty = true;
  double rating = 1;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);

    return AlertDialog(
      backgroundColor: mTheme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.o)),
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      content: Container(
        padding: EdgeInsets.all(12.o),
        width: widget.width - 30.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RatingBar.builder(
              itemSize: 25.o,
              initialRating: 1,
              itemPadding: EdgeInsets.symmetric(horizontal: 20.w),
              // ignoreGestures: isEditable ? false : true,
              allowHalfRating: true,
              direction: Axis.horizontal,
              minRating: 1,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Icon(
                  size: 30.o,
                  Icons.star,
                  color: Colors.amber,
                );
              },
              onRatingUpdate: (value) {
                rating = value;
              },
            ),
            Gap(10.h),
            Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(4.o),
                decoration: BoxDecoration(
                    color: mTheme.cardColor,
                    borderRadius: BorderRadius.circular(12.o),
                    border: Border.all(
                        width: 1,
                        color: mTheme.colorScheme.primary.withOpacity(0.2))),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        isEmpty = true;
                      }
                      if (value.isNotEmpty) {
                        isEmpty = false;
                      }
                      print(isEmpty);
                    });
                  },
                  minLines: 1,
                  maxLines: 3,
                  maxLength: 100,
                  controller: _commentController,
                  cursorColor: mTheme.colorScheme.primary,
                  style: theme.primaryTextStyle
                      .copyWith(color: mTheme.textTheme.bodyMedium!.color),
                  decoration: InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    prefixIcon:userCounter.appUser!.img == "null" ||
                        userCounter.appUser!.img == ""? Container(
                        margin: EdgeInsets.all(4.o),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50)),
                        width: 5.w,
                        height: 5.h,
                        child: Image.asset(
                          fit: BoxFit.cover,
                          IMAGES.person,
                          height: 5.h,
                          width: 5.w,
                        )):Container(
                        margin: EdgeInsets.all(4.o),
                        width: 5.w,
                        height: 5.h,
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.all(Radius.circular(50.o)),
                          child: FadeInImage(
                            placeholder: MemoryImage(kTransparentImage),
                            image: NetworkImage(userCounter.appUser!.img),
                            width: 5.w,
                            height: 5.h,
                            fit: BoxFit.cover,
                          ),
                        )),
                    hintText: leaveComment.tr,
                    hintStyle: mTheme.inputDecorationTheme.hintStyle,
                    suffixIcon: IconButton(
                        onPressed: isEmpty
                            ? null
                            : () {
                                widget.commentNotifier.postComment(
                                    widget.hotelId,
                                    _commentController.text,
                                    rating);
                                _commentController.clear();
                                hostelsCounter.getHostelsList();
                                Navigator.pop(context);
                                commentCounter.getCommentsList(widget.hotelId.toString());
                              },
                        icon: Icon(Icons.send_outlined,
                            color: isEmpty ? Colors.grey : Colors.blue)),
                    filled: true,
                    fillColor: mTheme.cardColor,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
