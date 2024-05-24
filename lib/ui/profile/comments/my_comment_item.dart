import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/variables/icons.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';

import '../../../providers/user_provider.dart';

class MyCommentItem extends StatelessWidget {
  const MyCommentItem({super.key, required this.userComment});

  final UserComment userComment;

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(12.o),
      decoration: BoxDecoration(
          border: Border.all(
              width: 1.o, color: theme.primaryColor.withOpacity(0.2)),
          color: mTheme.colorScheme.onSecondary,
          borderRadius: BorderRadius.all(Radius.circular(12.o))),
      margin: EdgeInsets.all(12.o),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: RatingBar.builder(
                  ignoreGestures: true,
                  itemSize: 15.o,
                  allowHalfRating: true,
                  direction: Axis.horizontal,
                  initialRating: double.tryParse(userComment.rating) ?? 0,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return SvgPicture.asset(
                      SVGIcons.star,
                      width: 5.o,
                      height: 5.o,
                    );
                  },
                  onRatingUpdate: (value) {},
                ),
              ),
              Text(
                userComment.createdAt,
                style: theme.primaryTextStyle.copyWith(
                    color: mTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Gap(10.o),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Icon(
              //   Icons.thumb_up_alt_outlined,
              //   color: Colors.amber,
              // ),
              // Gap(5.o),
              Text(
                userComment.hotelId,
                style: theme.hintTextFieldStyle
                    .copyWith(color: mTheme.colorScheme.secondary),
              )
            ],
          ),
          Gap(10.o),
          const Divider(),
          Gap(10.o),
          Text(
            textAlign: TextAlign.start,
            maxLines: 4,
            userComment.message,
            style: theme.hintTextFieldStyle
                .copyWith(color: mTheme.colorScheme.secondary),
          ),
        ],
      ),
    );
  }
}
