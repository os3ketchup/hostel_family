import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../apptheme.dart';
import '../../../../../variables/icons.dart';

class AmountTravellersBottomSheet extends StatefulWidget {
   AmountTravellersBottomSheet(
      {super.key,
      required this.onTap,
      this.adultsIncrementer = 1,
      this.childrenIncrementer = 0,
      this.roomsIncrementer = 1});

  final Function(int adult, int children, int room) onTap;

  // final int adultsIncrementer = 1;
  // final int childrenIncrementer = 0;
  // final int roomsIncrementer = 1;
   int adultsIncrementer;
   int childrenIncrementer;
   int roomsIncrementer;

  @override
  State<AmountTravellersBottomSheet> createState() =>
      _AmountTravellersBottomSheetState();
}

class _AmountTravellersBottomSheetState
    extends State<AmountTravellersBottomSheet> {


  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Container(
        padding: EdgeInsets.only(top: 30.o,bottom: Platform.isIOS?10.o:1.o
        ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 30.o),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(20.o),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20.o),
                  alignment: Alignment.centerRight,
                  child: SvgPicture.asset(
                    SVGIcons.close,
                    color: Colors.red,
                  ),
                )),
            Gap(20.o),
            Container(margin: EdgeInsets.symmetric(horizontal: 14.o),
              child: Text(textAlign: TextAlign.start,
                geustsAndRooms.tr,
                style: theme.primaryTextStyle
                    .copyWith(fontWeight: FontWeight.bold,fontSize: 18.o,color: mTheme.textTheme.bodyMedium!.color),
              ),
            ),
            Gap(20.o),
            _buildFilterItem(
              matures.tr,
              infoMatures.tr,
              mTheme,
              incrementer: widget.adultsIncrementer,
              onRemove: () {
                setState(() {
                  if (widget.adultsIncrementer == 1) {
                    return;
                  }
                  widget.adultsIncrementer--;
                });
              },
              onAdd: () {
                setState(() {
                  if (widget.adultsIncrementer > 9) {
                    return;
                  }
                  widget.adultsIncrementer++;
                });
              },
            ),
            Gap(10.o),
            _buildFilterItem(
              children.tr,
              infoChildren.tr,
              mTheme,
              incrementer: widget.childrenIncrementer,
              onRemove: () {
                setState(() {
                  if (widget.childrenIncrementer == 0) {
                    return;
                  }
                  widget.childrenIncrementer--;
                });
              },
              onAdd: () {
                setState(() {
                  if (widget.childrenIncrementer > 9) {
                    return;
                  }
                  widget.childrenIncrementer++;
                });
              },
            ),
            Gap(10.o),
            _buildFilterItem(
              room.tr,
              null,
              mTheme,
              incrementer: widget.roomsIncrementer,
              onRemove: () {
                setState(() {
                  if (widget.roomsIncrementer == 1) {
                    return;
                  }
                  widget.roomsIncrementer--;
                });
              },
              onAdd: () {
                setState(() {
                  if (widget.roomsIncrementer > 9) {
                    return;
                  }
                  widget.roomsIncrementer++;
                });
              },
            ),
            Gap(30.o),
            InkWell(
              onTap: () {
                widget.onTap(
                    widget.adultsIncrementer, widget.childrenIncrementer, widget.roomsIncrementer);
                Navigator.pop(context);
              },
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.o),
                  padding: EdgeInsets.all(8.o),
                  width: double.infinity * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.o),
                    color: mTheme.colorScheme.primary,
                  ),
                  child: Text(
                    choose.tr,
                    textAlign: TextAlign.center,
                    style: theme.primaryTextStyle.copyWith(
                        color: mTheme.colorScheme.onPrimary,
                        fontSize: mTheme.textTheme.bodyMedium!.fontSize),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFilterItem(String title, String? subtitle, ThemeData mTheme,
      {required VoidCallback onRemove,
      required VoidCallback onAdd,
      required int incrementer}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.o),
      padding: EdgeInsets.symmetric(horizontal: 18.o, vertical: 9.o),
      decoration: BoxDecoration(
          border: Border.all(
              width: 1.o, color: theme.primaryColor.withOpacity(0.2)),
          borderRadius: BorderRadius.all(Radius.circular(12.o))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.primaryTextStyle.copyWith(
                    color: mTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600),
              ),
              subtitle != null
                  ? Text(
                      subtitle,
                      style: theme.primaryTextStyle
                          .copyWith(color: mTheme.colorScheme.surface),
                    )
                  : Container(),
            ],
          ),
          Row(
            children: [
              IconButton(
                  onPressed:
                      incrementer == 0 || incrementer == 1 ? null : onRemove,
                  icon: Container(
                      padding: EdgeInsets.all(2.o),
                      decoration: BoxDecoration(
                          color: mTheme.colorScheme.primary.withOpacity(0.1),
                          border: Border.all(
                              width: 1.o,
                              color: theme.primaryColor.withOpacity(0.2)),
                          borderRadius: BorderRadius.all(Radius.circular(8.o))),
                      child: Icon(
                        Icons.remove,
                        size: 20.o,
                        color: incrementer == 0 || incrementer == 1
                            ? mTheme.colorScheme.shadow
                            : mTheme.colorScheme.primary,
                      ))),
              SizedBox(
                width: 30.w,
                child: Text(
                  textAlign: TextAlign.center,
                  incrementer.toString(),
                  style: theme.primaryTextStyle
                      .copyWith(color: mTheme.textTheme.bodyMedium!.color),
                ),
              ),
              IconButton(
                  onPressed: incrementer == 10 ? null : onAdd,
                  icon: Container(
                      padding: EdgeInsets.all(2.o),
                      decoration: BoxDecoration(
                          color: mTheme.colorScheme.primary.withOpacity(0.1),
                          border: Border.all(
                              width: 1.o,
                              color: theme.primaryColor.withOpacity(0.2)),
                          borderRadius: BorderRadius.all(Radius.circular(8.o))),
                      child: Icon(
                        Icons.add,
                        size: 20.o,
                        color: incrementer == 10 ? mTheme.colorScheme.shadow
                          : mTheme.colorScheme.primary,
                      ))),
            ],
          )
        ],
      ),
    );
  }
}
