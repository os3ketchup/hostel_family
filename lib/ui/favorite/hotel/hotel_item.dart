
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/providers/hotels_provider.dart';
import 'package:hostels/ui/home/detail_room/detail/detail_screen.dart';
import 'package:hostels/variables/icons.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';

import '../../../variables/images.dart';

class HotelItemScreen extends StatefulWidget {
  const HotelItemScreen({
    super.key,
    required this.hostels,
    required this.onNavigate,
  });

  final Hostels hostels;
  final Function(int selectedPage) onNavigate;

  @override
  State<HotelItemScreen> createState() => _HotelItemScreenState();
}

class _HotelItemScreenState extends State<HotelItemScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
        return DetailScreen(
          hostel: widget.hostels,
          onNavigate: widget.onNavigate,
        );
      })),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: theme.primaryColor.withOpacity(0.2)),
            color: mTheme.colorScheme.onPrimary,
            borderRadius: BorderRadius.all(
              Radius.circular(12.o),
            )),
        height: 130.o,
        margin: EdgeInsets.symmetric(vertical: 12.o, horizontal: 12.o),
        child: Row(
          children: [
            Stack(
              children: [
                SizedBox(
                    height: 130.h,
                    width: 120.o,
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.o),
                            bottomLeft: Radius.circular(12.o)),
                        child: Image.asset(
                          IMAGES.thirdRoom,
                          fit: BoxFit.cover,
                        ))),
                // Positioned(
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.grey.withOpacity(0.5),
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(8.o),
                //       ),
                //     ),
                //     margin: EdgeInsets.only(top: 6.o, left: 8.o),
                //     width: 50.o,
                //     height: 30.o,
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.all(Radius.circular(8.o)),
                //       child: BackdropFilter(
                //         filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                //           children: [
                //             SvgPicture.asset(SVGIcons.star),
                //             Text(
                //               '4.8',
                //               style: theme.primaryTextStyle
                //                   .copyWith(fontSize: 12.o, color: theme.white),
                //             )
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Gap(10.o),
                      SizedBox(
                        width: 180.o,
                        child: Text(
                          maxLines: 3,
                          widget.hostels.name,
                          style: theme.primaryTextStyle.copyWith(
                              fontSize: 14.o,
                              fontWeight: FontWeight.w600,
                              color: mTheme.colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
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
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.o),
                    width: double.infinity,
                    color: mTheme.colorScheme.primary.withOpacity(0.2),
                    height: 1.o,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Gap(10.o),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.hostels.discountPrice == '0'
                              ? Container()
                              : Text(
                                  widget.hostels.originalPrice,
                                  style: theme.hintTextFieldStyle.copyWith(
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.lineThrough,
                                      color: mTheme.colorScheme.secondary),
                                ),
                          widget.hostels.discountPrice == '0'
                              ? _buildRichText(
                                  widget.hostels.originalPrice, mTheme)
                              : _buildRichText(
                                  widget.hostels.discountPrice, mTheme)
                        ],
                      ),
                      const Spacer(),
                      Consumer(
                        builder: (context, ref, child) {
                          var notifier = ref.watch(hostelsProvider);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                notifier.postFavourite(
                                  hotelId: widget.hostels.id,
                                );
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.o),
                              decoration: BoxDecoration(
                                  color: theme.purpleColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.o))),
                              child: SvgPicture.asset(widget.hostels.liked
                                  ? SVGIcons.heart
                                  : SVGIcons.outLinedHeart),
                            ),
                          );
                        },
                      ),
                      Gap(10.o),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRichText(String price, ThemeData mThem) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: price.substring(
              0,
              price.length - 1 - 3,
            ),
            style: theme.primaryTextStyle.copyWith(
                fontSize: 18.o,
                color: mThem.colorScheme.primary,
                fontWeight: FontWeight.w700)),
        TextSpan(
            text: '${price.substring(price.length - 1 - 3, price.length)} UZS',
            style: theme.primaryTextStyle.copyWith(
                fontSize: 12.o,
                color: mThem.colorScheme.primary,
                fontWeight: FontWeight.w700)),
        TextSpan(
            text: ' \\TUN',
            style: theme.hintTextFieldStyle.copyWith(
                fontSize: 12.o,
                fontWeight: FontWeight.w700,
                color: mThem.colorScheme.secondary)),
      ]),
    );
  }
}
