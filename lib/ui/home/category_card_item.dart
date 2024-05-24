import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/providers/comment_provider.dart';

import 'package:hostels/variables/util_variables.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../apptheme.dart';
import '../../providers/hotels_provider.dart';
import '../../variables/icons.dart';
import '../../variables/language.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'detail_room/detail/detail_screen.dart';

class CategoryCardItem extends StatefulWidget {
   const CategoryCardItem({
    super.key,
    required this.activeHotel,
    required this.index,
    required this.hostel,
    required this.onNavigate,
    required this.isConnected, required this.onClickWhenDisconnect,

    // required this.hostel,
  });

  final ActiveHotel activeHotel;
  final int index;
  final List<Hostels> hostel;
  final Function(int selectedPage) onNavigate;
  final bool isConnected;
  final  VoidCallback onClickWhenDisconnect;

  @override
  State<CategoryCardItem> createState() => _CategoryCardItemState();
}

class _CategoryCardItemState extends State<CategoryCardItem> {
  bool isClicked = false;


  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    var hostel = widget.hostel
        .where((hostel) => hostel.id == widget.activeHotel.id)
        .toList()
        .first;
    return Consumer(
      builder: (context, ref, child) {
        var notifier = ref.watch(commentProvider);
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    print('${hostel.imageUrls} lll');
                    return DetailScreen(
                      hostel: hostel,
                      onNavigate: widget.onNavigate,
                    );
                  },
                ));
                notifier.getCommentsList(hostel.id);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: mTheme.colorScheme.onPrimary,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.o),
                    ),
                    border: Border.all(
                        width: 1.o, color: mTheme.colorScheme.secondary)),
                margin: EdgeInsetsDirectional.symmetric(horizontal: 8.o),
                width: 180.o,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 90.o,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12.o),
                            topLeft: Radius.circular(12.o)),
                        child: FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: NetworkImage(hostel.image),
                          height: 120.o,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 6.o),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(10.o),
                          SizedBox(
                            height: 55.o,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(left: 12.o),
                                    child: Text(
                                      softWrap: true,
                                      maxLines: 2,
                                      widget.activeHotel.name,
                                      style: theme.primaryTextStyle.copyWith(
                                          fontSize: 10.o,
                                          color: mTheme.colorScheme.primary,
                                          fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.start,
                                    )),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Gap(10.o),
                                      SvgPicture.asset(SVGIcons.locationOn),
                                      Gap(5.o),
                                      Text(
                                        widget.activeHotel.address,
                                        style: theme.hintTextFieldStyle
                                            .copyWith(
                                                fontSize: 10.o,
                                                color: mTheme
                                                    .colorScheme.secondary),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: mTheme.colorScheme.secondary,
                            thickness: 0.5.o,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Gap(12.o),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    price.tr,
                                    style: theme.hintTextFieldStyle
                                        .copyWith(
                                            color: mTheme.colorScheme.secondary)
                                        .copyWith(fontSize: 10.o),
                                    textAlign: TextAlign.start,
                                  ),
                                  widget.activeHotel.discountPrice == '0'
                                      ? Container()
                                      : Text(
                                          widget.activeHotel.originalPrice
                                              .toString(),
                                          style:
                                              theme.hintTextFieldStyle.copyWith(
                                            fontStyle: FontStyle.italic,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                  widget.activeHotel.discountPrice == '0'
                                      ? _buildRichText(
                                          widget.activeHotel.originalPrice
                                              .toString(),
                                          mTheme)
                                      : _buildRichText(
                                          widget.activeHotel.discountPrice
                                              .toString(),
                                          mTheme),
                                ],
                              ),
                              const Spacer(),
                              Consumer(
                                builder: (context, ref, child) {
                                  final notifier = ref.watch(hostelsProvider);
                                  return widget.isConnected
                                      ? InkWell(
                                          onTap: () {
                                            notifier.postFavourite(
                                              hotelId: widget.activeHotel.id,
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8.o),
                                            decoration: BoxDecoration(
                                                color: theme.purpleColor
                                                    .withOpacity(0.1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.o))),
                                            child: SvgPicture.asset(hostel.liked
                                                ? SVGIcons.heart
                                                : SVGIcons.outLinedHeart),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: widget.onClickWhenDisconnect,
                                          child: Container(
                                            padding: EdgeInsets.all(8.o),
                                            decoration: BoxDecoration(
                                                color: theme.purpleColor
                                                    .withOpacity(0.1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.o))),
                                            child: SvgPicture.asset(hostel.liked
                                                ? SVGIcons.heart
                                                : SVGIcons.outLinedHeart),
                                          ),
                                        );
                                },
                              ),
                            ],
                          ),
                          Gap(10.o),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                          '${double.parse(widget.activeHotel.rating)}',
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
        );
      },
    );
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
            text: ' ${night.tr}',
            style: theme.hintTextFieldStyle.copyWith(
                fontSize: mTheme.textTheme.labelSmall!.fontSize,
                color: mTheme.colorScheme.secondary)),
      ]),
    );
  }
}
