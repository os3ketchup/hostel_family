import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../../../providers/room_provider.dart';
import '../../../../../variables/icons.dart';
import '../../../../../variables/images.dart';
import '../../detail/order_hotel_bottom_sheet.dart';

class RoomInformationScreen extends StatefulWidget {
  const RoomInformationScreen(
      {super.key,
      required this.room,
      required this.startDate,
      required this.finishDate,
      required this.onNavigate, required this.price});

  final int price;
  final Room room;
  final String startDate;
  final String finishDate;
  final Function(int selectedPage) onNavigate;

  @override
  State<RoomInformationScreen> createState() => _RoomInformationScreenState();
}

class _RoomInformationScreenState extends State<RoomInformationScreen> {
  String selectedImage = '';

  @override
  void initState() {
    selectedImage = widget.room.images.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100.o),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageStack(),
                Gap(20.o),
                Container(
                  margin: EdgeInsets.only(left: 20.o),
                  child: Text(
                    widget.room.name,
                    style: theme.primaryTextStyle.copyWith(
                        fontSize: 28.o,
                        fontWeight: FontWeight.w600,
                        color: mTheme.textTheme.bodyMedium!.color),
                  ),
                ),
                Gap(20.o),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.o))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12.o),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row(
                            //   children: [
                            //     SvgPicture.asset(
                            //       SVGIcons.flash,
                            //       width: 12.w,
                            //       height: 12.h,
                            //     ),
                            //     Gap(10.o),
                            //     Text(
                            //       highLights.tr,
                            //       style: theme.primaryTextStyle.copyWith(
                            //           fontWeight: FontWeight.w600,
                            //           color:
                            //               mTheme.textTheme.bodyMedium!.color),
                            //     )
                            //   ],
                            // ),
                            // Gap(10.o),
                            // Container(
                            //   padding: EdgeInsets.all(16.o),
                            //   decoration: BoxDecoration(
                            //       color: Colors.amber.withOpacity(0.2),
                            //       borderRadius:
                            //           BorderRadius.all(Radius.circular(12.o))),
                            //   child:                                     Text(
                            //       maxLines: 10,
                            //       style: theme.primaryTextStyle, widget.room.name),
                            // ),
                            Column(
                              children: [
                                for (final item in widget.room.activeFeatures)
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 6.o),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            height: 24.o,
                                            width: 24.o,
                                            child: FadeInImage(
                                              placeholder: MemoryImage(kTransparentImage),
                                              image: NetworkImage(item.imageUrl),
                                              fit: BoxFit.cover,
                                            )),
                                        Gap(10.o),
                                        Text(item.name,style: theme.primaryTextStyle.copyWith(color: mTheme.textTheme.bodySmall!.color)),
                                      ],
                                    ),
                                  )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Container(
              margin: Platform.isIOS
                  ? EdgeInsets.only(bottom: 30.o, right: 12.o, left: 12.o)
                  : EdgeInsets.only(bottom: 15.o, left: 12.o, right: 12.o),
              alignment: Alignment.bottomCenter,
              child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: mTheme.colorScheme.primary),
                  onPressed: () {
                    print('room bottom sheet clicked');
                    showModalBottomSheet(
                      backgroundColor: Colors.white,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return OrderHotelBottomSheet(
                          room: widget.room,
                          startedDate: widget.startDate,
                          finishedDate: widget.finishDate,
                          onNavigate: widget.onNavigate, totalPrice: widget.price.toString(),
                        );
                      },
                    );
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: 20.h,
                      width: double.infinity,
                      child: Text(
                        textAlign: TextAlign.center,
                        order.tr,
                        style:
                            theme.primaryTextStyle.copyWith(color: theme.white),
                      ))),
            ),
          )
        ],
      ),
    );
  }

  Widget _categoryHeader(IconData icon, String title) {
    return Row(
      children: [Icon(icon), Gap(10.o), Text(title)],
    );
  }

  Widget _buildFeatureWidget(IconData icon, String title, ThemeData mTheme) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.o),
      child: Row(
        children: [
          Icon(icon),
          Gap(10.o),
          Text(
            title,
            style: theme.primaryTextStyle
                .copyWith(color: mTheme.textTheme.bodyMedium!.color),
          )
        ],
      ),
    );
  }

  Widget _categoryFeatures(String title, ThemeData mTheme) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.o),
      child: Row(
        children: [
          Gap(40.o),
          Text(
            title,
            style: theme.primaryTextStyle
                .copyWith(color: mTheme.textTheme.bodyMedium!.color),
          ),
        ],
      ),
    );
  }

  Widget _buildImageStack() {
    return Stack(
      children: [
        FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: NetworkImage(selectedImage),
          height: 374.o,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          child: _buildBackButton(),
        ),
        Positioned(
          bottom: 0,
          child: _buildImageList(),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5.o),
        borderRadius: BorderRadius.all(
          Radius.circular(50.o),
        ),
      ),
      margin: EdgeInsets.only(top: 40.o, left: 20.o),
      width: 40.0,
      height: 40.0,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(50.o)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.o, sigmaY: 8.o),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_sharp,
              size: 15.o,
              color: theme.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageList() {
    return Container(
      width: 600.w - 100.w,
      height: 60.o,
      margin: EdgeInsets.only(left: 20.o, bottom: 20.o),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.room.images.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color:selectedImage == widget.room.images[index]? Colors.white:Colors.grey.withOpacity(0.5.o),
              borderRadius: BorderRadius.all(Radius.circular(8.o)),
            ),
            margin: EdgeInsets.symmetric(horizontal: 6.o),
            width: selectedImage == widget.room.images[index]?75.o:60.o,
            height: selectedImage == widget.room.images[index]?75.o:60.o,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8.o)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8.o, sigmaY: 8.o),
                child: Container(
                  margin: EdgeInsets.all(6.o),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(6.o)),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImage = widget.room.images[index];
                        });
                      },
                      child: FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: NetworkImage(widget.room.images[index]),
                        height: 374.o,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShareButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.4.o),
        borderRadius: BorderRadius.all(
          Radius.circular(50.o),
        ),
      ),
      margin: EdgeInsets.only(top: 40.o, left: 20.o),
      width: 40.o,
      height: 40.o,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(50.o)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.o, sigmaY: 8.o),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 15.o,
              color: theme.white,
            ),
          ),
        ),
      ),
    );
  }
}
