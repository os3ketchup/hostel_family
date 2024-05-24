import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/providers/comment_provider.dart';
import 'package:hostels/providers/news_provider.dart';
import 'package:hostels/ui/home/detail_room/detail/detail_screen.dart';

import 'package:hostels/variables/util_variables.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../apptheme.dart';
import '../../providers/hotels_provider.dart';
import '../../variables/icons.dart';
import '../../variables/images.dart';
import '../../variables/language.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchCategoryCardItem extends StatefulWidget {
  const SearchCategoryCardItem({
    super.key,
    required this.hostel,
    required this.onNavigate,
    required this.onLike,
    // required this.hostel,
  });

  final Hostels hostel;
  final Function(int selectedPage) onNavigate;
  final VoidCallback onLike;


  @override
  State<SearchCategoryCardItem> createState() => _SearchCategoryCardItemState();
}

class _SearchCategoryCardItemState extends State<SearchCategoryCardItem> {
  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);

    return Consumer(builder: (context, ref, child) {
      var notifier = ref.watch(commentProvider);
      return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              print(widget.hostel.name);
              return DetailScreen(
                hostel: widget.hostel,
                onNavigate: widget.onNavigate,
              );

            },
          ));
          notifier.getCommentsList(widget.hostel.id);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              border: Border.all(width: 1.o, color: mTheme.colorScheme.secondary),
              color: mTheme.colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(8.o)),
          height: 280.o,
          margin: EdgeInsets.symmetric(horizontal: 12.o, vertical: 6.o),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  FadeInImage(
                    width: double.infinity,
                    placeholder: MemoryImage(kTransparentImage),
                    image: NetworkImage(widget.hostel.image),
                    height: 90.o,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.o),
                        ),
                      ),
                      margin: EdgeInsets.only(top: 6.o, right: 16.o),
                      width: 50.o,
                      height: 30.o,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8.o)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SvgPicture.asset(SVGIcons.star),
                              Text(
                                '${double.parse(widget.hostel.rating)}',
                                style: theme.primaryTextStyle
                                    .copyWith(fontSize: 12.o, color: theme.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 55.h,
                margin: EdgeInsets.symmetric(horizontal: 12.o),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      softWrap: true,
                      maxLines: 2,
                      widget.hostel.name,
                      style: theme.primaryTextStyle.copyWith(
                          fontSize: 10.o,
                          color: mTheme.colorScheme.primary,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.start,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SvgPicture.asset(SVGIcons.locationOn),
                        Gap(5.o),
                        Expanded(
                          child: Text(
                            maxLines: 2,
                            softWrap: true,
                            widget.hostel.address,
                            style: theme.hintTextFieldStyle.copyWith(
                                fontSize: 10.o,
                                color: mTheme.colorScheme.secondary),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                color: mTheme.colorScheme.secondary,
                thickness: 0.5.o,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.o),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          price.tr,
                          style: theme.hintTextFieldStyle
                              .copyWith(color: mTheme.colorScheme.secondary)
                              .copyWith(
                              fontSize:
                              mTheme.textTheme.bodyMedium!.fontSize),
                          textAlign: TextAlign.start,
                        ),
                        widget.hostel.discountPrice == '0'
                            ? Container()
                            : Text(
                          widget.hostel.originalPrice.toString(),
                          style: theme.hintTextFieldStyle.copyWith(
                            fontSize: mTheme.textTheme.bodyMedium!.fontSize,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        widget.hostel.discountPrice == '0'
                            ? _buildRichText(
                            widget.hostel.originalPrice.toString(), mTheme)
                            : _buildRichText(
                            widget.hostel.discountPrice.toString(), mTheme),
                      ],
                    ),
                    GestureDetector(
                      onTap: widget.onLike,
                      child: Container(
                        padding: EdgeInsets.all(8.o),
                        decoration: BoxDecoration(
                            color: theme.purpleColor.withOpacity(0.1),
                            borderRadius: BorderRadius.all(Radius.circular(8.o))),
                        child: SvgPicture.asset(widget.hostel.liked
                            ? SVGIcons.heart
                            : SVGIcons.outLinedHeart),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },);
  }

  Widget _buildRichText(String price, ThemeData mTheme) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: price.substring(
              0,
              price.length - 1 - 3,
            ),
            style: theme.primaryTextStyle.copyWith(
                fontSize: mTheme.textTheme.labelLarge!.fontSize,
                color: mTheme.colorScheme.primary,
                fontWeight: FontWeight.w700)),
        TextSpan(
            text: '${price.substring(price.length - 1 - 3, price.length)} UZS',
            style: theme.primaryTextStyle.copyWith(
                fontSize: mTheme.textTheme.labelSmall!.fontSize,
                color: mTheme.colorScheme.primary,
                fontWeight: FontWeight.w700)),
        TextSpan(
            text: night.tr,
            style: theme.hintTextFieldStyle.copyWith(
                fontSize: mTheme.textTheme.labelSmall!.fontSize,
                color: mTheme.colorScheme.secondary)),
      ]),
    );
  }
}
