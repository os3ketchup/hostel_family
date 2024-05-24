import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../apptheme.dart';
import '../../../providers/comment_provider.dart';
import '../../../variables/images.dart';

class CommentsItem extends StatefulWidget {
  const CommentsItem({super.key, required this.comment, required this.rating,  this.width = 1});
  final double width;
  final Comment comment;
  final double rating;

  @override
  State<CommentsItem> createState() => _CommentsItemState();
}

class _CommentsItemState extends State<CommentsItem> {
  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(12.o),
          margin: EdgeInsets.symmetric(horizontal: 12.o, vertical: 6.o),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.o)),
              border: DashedBorder.fromBorderSide(
                side:
                    BorderSide(width: 2.o, color: mTheme.colorScheme.secondary),
                dashLength: 4,
              ),
              color: mTheme.colorScheme.background),
          height: 160.o,
          width: width * widget.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  widget.comment.clientImage == "null" ||
                          widget.comment.clientImage == ""
                      ? SizedBox(
                          width: 50.o,
                          height: 50.o,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.o)),
                            child: Image.asset(
                              IMAGES.person,
                              fit: BoxFit.cover,
                            ),
                          ))
                      : SizedBox(
                          width: 50.o,
                          height: 50.o,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.o)),
                            child: FadeInImage(
                              placeholder: MemoryImage(kTransparentImage),
                              image: NetworkImage(widget.comment.clientImage),
                              height: 120.o,
                              fit: BoxFit.cover,
                            ),
                          )),
                  Gap(10.o),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 100.o,
                          child: Text(
                            widget.comment.clientId,
                            maxLines: 2,
                            style: theme.primaryTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ThemeMode.dark == ThemeMode.light
                                    ? theme.primaryColor
                                    : mTheme.colorScheme.primary),
                          ),
                        ),
                        RatingBar.builder(
                          unratedColor: Colors.amber.withOpacity(0.24),
                          itemSize: 20.o,
                          initialRating: widget.rating,
                          ignoreGestures: true,
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
                          onRatingUpdate: (value) {},
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Gap(20.o),
                      Text(
                        DateFormat("dd.MM.yyyy").format(
                            DateFormat("dd.MM.yyyy HH:mm")
                                .parse(widget.comment.createdAt)),
                        style: theme.hintTextFieldStyle.copyWith(
                            fontSize: 12.o,
                            color: ThemeMode.dark == ThemeMode.light
                                ? theme.hintTextFieldStyle.color
                                : mTheme.colorScheme.surface),
                      ),
                    ],
                  )
                ],
              ),
              Divider(
                color: mTheme.colorScheme.secondary,
              ),
              Expanded(
                child: Text(
                  textAlign: TextAlign.start,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  widget.comment.message,
                  style: theme.hintTextFieldStyle.copyWith(
                      color: ThemeMode.dark == ThemeMode.light
                          ? theme.hintTextFieldStyle.color
                          : mTheme.colorScheme.surface),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: PopupMenuButton<String>(
            color: mTheme.colorScheme.background,
            icon: Icon(Icons.more_vert),
            onSelected: (String result) {
              print('Selected: $result');
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
               PopupMenuItem<String>(
                value: 'option1',
                child: Text(complain.tr,style: theme.primaryTextStyle.copyWith(color: mTheme.textTheme.bodyMedium!.color),),
              ),
               PopupMenuItem<String>(
                value: 'option2',
                child: Text(markAsSpam.tr,style: theme.primaryTextStyle.copyWith(color: mTheme.textTheme.bodyMedium!.color)),
              ),
            ],
          ),
        )
      ],
    );
  }
}
