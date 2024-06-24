import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/providers/payment_provider.dart';
import 'package:hostels/variables/images.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:hostels/widgets/Toast.dart';
import 'package:intl/intl.dart';

import '../../../../apptheme.dart';
import '../../../../network/client.dart';
import '../../../../providers/room_provider.dart';
import '../../../../variables/links.dart';

class OrderHotelBottomSheet extends StatefulWidget {
  const OrderHotelBottomSheet(
      {required this.room,
      super.key,
      required this.startedDate,
      required this.finishedDate,
      required this.onNavigate, required this.totalPrice});

  final Function(int selectedPage) onNavigate;
  final Room room;
  final String startedDate;
  final String finishedDate;
  final String totalPrice;

  @override
  State<OrderHotelBottomSheet> createState() => _OrderHotelBottomSheetState();
}

class _OrderHotelBottomSheetState extends State<OrderHotelBottomSheet> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return SingleChildScrollView(
      child: Consumer(
        builder: (context, ref, child) {
          var paymentNotifier = ref.watch(paymentProvider);
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(14.o)),
                  color: Colors.grey,
                ),
                margin: EdgeInsets.symmetric(horizontal: 160.o, vertical: 12.o),
                height: 5.o,
                width: 54.o,
              ),
              Container(
                padding: EdgeInsets.all(12.o),
                width: double.infinity,
                child: Text(
                  bronRoom.tr,
                  style: theme.primaryTextStyle.copyWith(
                      fontSize: 20.o,
                      fontWeight: FontWeight.w600,
                      color: mTheme.textTheme.bodyMedium!.color),
                  textAlign: TextAlign.start,
                ),
              ),
              // Container(
              //   padding: EdgeInsets.only(
              //       bottom: 12.o, left: 12.o, right: 12.o),
              //   width: double.infinity,
              //   child: Text(
              //     'Sotib olish',
              //     style: theme.primaryTextStyle.copyWith(
              //         fontSize: 14.o,
              //         fontWeight: FontWeight.w400),
              //   ),
              // ),
              Container(
                padding: EdgeInsets.all(12.o),
                width: double.infinity,
                child: Text(
                  choosePaymentType.tr,
                  style: theme.primaryTextStyle.copyWith(
                      color: mTheme.textTheme.bodyMedium!.color,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCardOptions(IMAGES.click, 1, mTheme),
                  _buildCardOptions(IMAGES.orange, 2, mTheme),
                  _buildCardOptions(IMAGES.cash, 3, mTheme)
                ],
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.o, vertical: 6.o),
                  child: const Divider()),
              Container(
                padding: EdgeInsets.all(12.o),
                margin: EdgeInsets.symmetric(horizontal: 10.o),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      priceRoom.tr,
                      style: theme.primaryTextStyle.copyWith(
                          fontSize: 16.o,
                          fontWeight: FontWeight.w600,
                          color: mTheme.textTheme.bodyMedium!.color),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // widget.room.discountPrice == '0'
                        //     ? Container()
                        //     : Text(
                        //         numberFormat(widget.room.originalPrice),
                        //         style: theme.primaryTextStyle.copyWith(
                        //             decoration: TextDecoration.lineThrough,
                        //             fontSize: 12,
                        //             fontWeight: FontWeight.w400,
                        //             fontStyle: FontStyle.italic,
                        //             color: Colors.grey),
                        //       ),
                        Text(
                            /*widget.room.discountPrice == '0'
                                ? numberFormat(widget.room.originalPrice)
                                : */numberFormat(widget.totalPrice),
                            style: theme.primaryTextStyle.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.green)),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: Platform.isIOS
                    ? EdgeInsets.only(bottom: 30.o,left: 12.o,right: 12.o)
                    : EdgeInsets.only(bottom: 12.o, left: 12.o, right: 12.o),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12.o)),
                  color: selectedIndex == -1 || selectedIndex == 2
                      ? mTheme.colorScheme.primary.withOpacity(0.2)
                      : mTheme.colorScheme.primary,
                ),
                width: double.infinity,
                child: TextButton(
                  onPressed: selectedIndex == -1 || selectedIndex == 2
                      ? null
                      : () {
                          print(widget.room.originalPrice);
                          Navigator.popUntil(context, (route) => route.isFirst);
                          if(selectedIndex==3){
                            awesomeToast(context: context, txt: messageSuccess.tr, title: message.tr, contentType: ContentType.success);
                          }
                          print(widget.room.originalPrice is double);
                          paymentNotifier.payToRoom(
                              startDate: widget.startedDate,
                              finishDate: widget.finishedDate,
                              selectedIndex: selectedIndex,
                              price: widget.room.discountPrice == '0'
                                  ? widget.room.originalPrice
                                  : widget.room.discountPrice,
                              roomId: widget.room.id);
                          widget.onNavigate(1);
                            paymentCounter.getAllOrder();

                        print('clicked123');
                          // showPaymentDialog(context);
                        },
                  child: Text(
                    payment.tr,
                    style: theme.primaryTextStyle.copyWith(
                        color: theme.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.o),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildCardOptions(String image, int index, ThemeData mTheme) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 1.o,
                  color: selectedIndex == index
                      ? mTheme.colorScheme.primary
                      : Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(12.o)),
            ),
            width: 109.o,
            height: 70.o,
            margin: EdgeInsets.all(6.o),
            child: Image.asset(image),
          ),
          Container(
            width: 18.o,
            height: 18.o,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1.o,
                  color: selectedIndex == index
                      ? mTheme.colorScheme.primary
                      : Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(12.o)),
            ),
            child: Container(
              width: 16.o,
              height: 16.o,
              margin: EdgeInsets.all(2.o),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12.o)),
                  color: selectedIndex == index
                      ? mTheme.colorScheme.primary
                      : theme.white),
            ),
          )
        ],
      ),
    );
  }

  void payToRoom(String startDate, String finishDate) async {
    await client.post(Links.order, data: {
      'room_id': widget.room.id,
      'price': widget.room.originalPrice,
      'payment_type': selectedIndex,
      'started_date': startDate,
      'finished_date': finishDate
    }).then(
      (value) {},
    );
  }

  String numberFormat(String currency) {
    NumberFormat formatter =
        NumberFormat.currency(decimalDigits: 0, symbol: 'UZS');
    double formattedCurrency = double.tryParse(currency) ?? 0;
    return formatter.format(formattedCurrency);
  }
}
