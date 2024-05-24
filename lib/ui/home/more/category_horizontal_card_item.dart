import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/providers/comment_provider.dart';
import 'package:hostels/ui/home/detail_room/detail/detail_screen.dart';

import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../providers/hotels_provider.dart';
import '../../../variables/icons.dart';
import '../../../variables/images.dart';
import 'package:flutter_svg/svg.dart';

import '../../../variables/language.dart';

class CategoryHorizontalCardItem extends StatefulWidget {
  const CategoryHorizontalCardItem(
      {super.key,
      required this.hostels,
      required this.onNavigate,
      required this.isConnected,
      required this.onClickWhenDisconnect});

  final Hostels hostels;
  final Function(int selectedPage) onNavigate;
  final bool isConnected;
  final VoidCallback onClickWhenDisconnect;

  @override
  State<CategoryHorizontalCardItem> createState() =>
      _CategoryHorizontalCardItemState();
}

class _CategoryHorizontalCardItemState
    extends State<CategoryHorizontalCardItem> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Consumer(builder: (context, ref, child) {
      var notifier = ref.watch(commentProvider);
      return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return DetailScreen(
                hostel: widget.hostels,
                onNavigate: widget.onNavigate,
              );
            },
          ));
          notifier.getCommentsList(widget.hostels.id);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.o, vertical: 6.o),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 4,
                    spreadRadius: 1,
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(1, 4))
              ],
              color: mTheme.colorScheme.onPrimary,
              border: Border.all(width: 1, color: Colors.white),
              borderRadius: BorderRadius.all(
                Radius.circular(12.o),
              )),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.o),
                              bottomLeft: Radius.circular(8.o))),
                      height: 130.o,
                      width: 200.w,
                      child: FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: NetworkImage(widget.hostels.image),
                        height: 130.o,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 12.o),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 6.o),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(10.o),
                            Container(
                                margin: EdgeInsets.only(left: 12.o),
                                child: Text(
                                  widget.hostels.name,
                                  style: theme.primaryTextStyle.copyWith(
                                      color: mTheme.colorScheme.primary,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.start,
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Gap(10.o),
                                SvgPicture.asset(SVGIcons.locationOn),
                                Text(
                                  widget.hostels.address,
                                  style: theme.hintTextFieldStyle.copyWith(
                                      fontSize: 12.o,
                                      color: mTheme.colorScheme.secondary),
                                )
                              ],
                            ),
                            const Divider(),
                            Row(
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
                                          .copyWith(fontSize: 12.o),
                                      textAlign: TextAlign.start,
                                    ),
                                    widget.hostels.discountPrice == '0'
                                        ? Container()
                                        : Text(
                                      widget.hostels.originalPrice
                                          .toString(),
                                      style:
                                      theme.hintTextFieldStyle.copyWith(
                                        fontStyle: FontStyle.italic,
                                        decoration:
                                        TextDecoration.lineThrough,
                                      ),
                                    ),
                                    widget.hostels.discountPrice == '0'
                                        ? _buildRichText(
                                        widget.hostels.originalPrice
                                            .toString(),
                                        mTheme)
                                        : _buildRichText(
                                        widget.hostels.discountPrice
                                            .toString(),
                                        mTheme),
                                  ],
                                ),
                                const Spacer(),
                                Consumer(
                                  builder: (context, ref, child) {
                                    final notifier = ref.watch(hostelsProvider);
                                    return widget.isConnected
                                        ? GestureDetector(
                                      onTap: () {
                                        notifier.postFavourite(
                                          hotelId: widget.hostels.id,
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8.o),
                                        decoration: BoxDecoration(
                                            color: theme.purpleColor
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.o))),
                                        child: SvgPicture.asset(
                                            widget.hostels.liked
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
                                        child: SvgPicture.asset(widget.hostels.liked
                                            ? SVGIcons.heart
                                            : SVGIcons.outLinedHeart),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
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
            text: ' ${night.tr}',
            style: theme.hintTextFieldStyle.copyWith(
                fontSize: mTheme.textTheme.labelSmall!.fontSize,
                color: mTheme.colorScheme.secondary)),
      ]),
    );
  }
}
