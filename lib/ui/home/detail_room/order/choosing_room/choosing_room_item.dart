import 'package:flutter/material.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/variables/icons.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../../providers/room_provider.dart';
import '../../../../../variables/images.dart';

class ChoosingRoomItem extends StatelessWidget {
  const ChoosingRoomItem({
    super.key,
    required this.orderItem,
    required this.more,
    required this.isSelected,
    required this.room,
  });

  final VoidCallback orderItem;
  final VoidCallback more;
  final bool isSelected;
  final Room room;

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Container(
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
              SizedBox(
                  height: 130.o,
                  width: 200.w,
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.o),
                          bottomLeft: Radius.circular(12.o)),
                      child: Image.asset(
                        IMAGES.thirdRoom,
                        fit: BoxFit.cover,
                      ))),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.o),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Gap(5.o),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            room.hotelId,
                            style: theme.primaryTextStyle
                                .copyWith(color: mTheme.colorScheme.primary),
                          ),
                          GestureDetector(
                              onTap: more,
                              child: SvgPicture.asset(
                                height: 8.h,
                                width: 8.w,
                                SVGIcons.downCaret,
                                color: mTheme.colorScheme.primary,
                              ))
                        ],
                      ),
                      Gap(5.o),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(SVGIcons.person,color: mTheme.colorScheme.secondary,),
                              Gap(5.o),
                              Text(
                                room.roomNumber,
                                style: theme.hintTextFieldStyle
                                    .copyWith(fontSize: 12.o,color: mTheme.colorScheme.secondary),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(SVGIcons.bedroom,color: mTheme.colorScheme.secondary,),
                              Gap(5.o),
                              Text(
                                'Egizak yotoq',
                                style: theme.hintTextFieldStyle
                                    .copyWith(fontSize: 12.o,color: mTheme.colorScheme.secondary),
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(SVGIcons.spoon,color: mTheme.colorScheme.secondary,),
                          Gap(5.o),
                          Text(
                            room.name,
                            style: theme.hintTextFieldStyle
                                .copyWith(fontSize: 12.o,color: mTheme.colorScheme.secondary),
                          ),
                        ],
                      ),
                      Gap(5.o),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              room.discountPrice == '0'
                                  ? Container()
                                  : Text(
                                      numberFormat(room.originalPrice),
                                      style: theme.hintTextFieldStyle.copyWith(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontStyle: FontStyle.italic,color: mTheme.colorScheme.secondary),
                                    ),
                              room.discountPrice == '0'
                                  ? Text(
                                      '${numberFormat(room.originalPrice)}${night.tr}',
                                      style: theme.primaryTextStyle.copyWith(color: mTheme.colorScheme.primary,fontWeight: FontWeight.w600),
                                    )
                                  : Text(
                                      '${numberFormat(room.discountPrice)}${night.tr}',
                                      style: theme.primaryTextStyle.copyWith(color: mTheme.colorScheme.primary,fontWeight: FontWeight.w600),
                                    ),
                            ],
                          ),
                          Gap(5.o),
                          InkWell(
                            onTap: orderItem,
                            child: Container(
                              width: 168.w,
                                decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.o))),
                                padding: EdgeInsets.all(8.o),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  order.tr,
                                  style: theme.hintTextFieldStyle.copyWith(
                                      fontSize: 10.o, color: Colors.green),
                                )),
                          )
                        ],
                      ),
                      Gap(5.o),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  String numberFormat(String currency) {
    NumberFormat formatter = NumberFormat.currency(decimalDigits: 0,symbol: ''
        );
    double formattedCurrency = double.tryParse(currency) ?? 0;
    return formatter.format(formattedCurrency);
  }
}
