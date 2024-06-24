import 'package:flutter/material.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/network/client.dart';
import 'package:hostels/ui/home/detail_room/order/choosing_room/permission/permission_screen.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';

import '../../providers/payment_provider.dart';
import '../../variables/links.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({
    super.key,
    required this.status,
  });

  final Status status;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                width: 1.o, color: mTheme.primaryColor.withOpacity(0.2)),
            color: mTheme.colorScheme.onPrimary,
            borderRadius: BorderRadius.all(Radius.circular(12.o))),
        margin: EdgeInsets.symmetric(horizontal: 8.o, vertical: 8.o),
        padding: EdgeInsets.symmetric(horizontal: 12.o, vertical: 6.o),
        // height: 204.h,
        width: 375.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${orderId.tr}: ${widget.status.id}',
                  style: theme.hintTextFieldStyle.copyWith(
                      fontSize: 14.o, color: mTheme.colorScheme.secondary),
                ),
                // const Spacer(),
                // Icon(Icons.more_vert,color: theme.textFieldHintColor,),
                Container(
                  padding: EdgeInsets.all(8.o),
                  decoration: BoxDecoration(
                      color: theme.backgroundGrey,
                      borderRadius: BorderRadius.all(Radius.circular(12.o))),
                  child: Text(
                    widget.status.paymentStatusString,
                    style: theme.primaryTextStyle.copyWith(color: Colors.red,fontSize: 10.o),
                  ),
                )
              ],
            ),
            Divider(
              color: mTheme.colorScheme.secondary,
            ),
            Row(
              children: [
                // SizedBox(
                //     width: 32.o,
                //     height: 32.o,
                //     child: Image.asset(IMAGES.firstRoom)),
                // Gap(20.o),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        maxLines: 3,
                        softWrap: true,
                        widget.status.hotelName,
                        style: theme.primaryTextStyle.copyWith(
                            color: mTheme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.o),
                      ),
                      Gap(14.o),
                      Text(
                        widget.status.roomId,
                        style: theme.hintTextFieldStyle
                            .copyWith(color: mTheme.colorScheme.secondary,fontSize: 14.o),
                      ),
                      Gap(5.o),
                    ],
                  ),
                ),
              ],
            ),
            Gap(10.o),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  priceInfo.tr,
                  style: theme.hintTextFieldStyle
                      .copyWith(color: mTheme.colorScheme.secondary,fontSize: 14.o),
                ),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: widget.status.totalPrice.substring(
                              0,
                              widget.status.totalPrice.length - 4,
                            ),
                            style: theme.primaryTextStyle.copyWith(
                                fontSize: 18.o,
                                color: mTheme.colorScheme.primary,
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                            text: widget.status.totalPrice.substring(
                                widget.status.totalPrice.length - 4,
                                widget.status.totalPrice.length),
                            style: theme.primaryTextStyle.copyWith(
                                fontSize: 12.o,
                                color: mTheme.colorScheme.primary,
                                fontWeight: FontWeight.w700)),
                        TextSpan(
                            text: ' UZS',
                            style: theme.primaryTextStyle.copyWith(
                                fontSize: 12.o,
                                color: mTheme.colorScheme.primary,
                                fontWeight: FontWeight.w700)),
                      ]),
                    ),
                    Gap(10.o),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: mTheme.colorScheme.secondary,
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              color: mTheme.colorScheme.secondary,
            ),
            isExpanded
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            priceRoom.tr,
                            style: theme.hintTextFieldStyle
                                .copyWith(color: mTheme.colorScheme.secondary),
                          ),
                          Text(
                            '${widget.status.price} UZS',
                            style: theme.primaryTextStyle.copyWith(
                                color: mTheme.textTheme.bodyMedium!.color),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            duration.tr,
                            style: theme.hintTextFieldStyle
                                .copyWith(color: mTheme.colorScheme.secondary),
                          ),
                          Text(
                            '${widget.status.day} ${day.tr}',
                            style: theme.primaryTextStyle.copyWith(
                                color: mTheme.textTheme.bodyMedium!.color),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            startDate.tr,
                            style: theme.hintTextFieldStyle
                                .copyWith(color: mTheme.colorScheme.secondary),
                          ),
                          Text(widget.status.startedDate,
                              style: theme.primaryTextStyle.copyWith(
                                  color: mTheme.textTheme.bodyMedium!.color))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(finishDate.tr,
                              style: theme.hintTextFieldStyle.copyWith(
                                  color: mTheme.colorScheme.secondary)),
                          Text(widget.status.finishedDate,
                              style: theme.primaryTextStyle.copyWith(
                                  color: mTheme.textTheme.bodyMedium!.color))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(orderGiven.tr,
                              style: theme.hintTextFieldStyle.copyWith(
                                  color: mTheme.colorScheme.secondary)),
                          Text(widget.status.createdAt,
                              style: theme.primaryTextStyle.copyWith(
                                  color: mTheme.textTheme.bodyMedium!.color))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(typePayment.tr,
                              style: theme.hintTextFieldStyle.copyWith(
                                  color: mTheme.colorScheme.secondary)),
                          Text(widget.status.paymentTypeString,
                              style: theme.primaryTextStyle.copyWith(
                                  color: mTheme.textTheme.bodyMedium!.color))
                        ],
                      )
                    ],
                  )
                : Container(),
            Gap(10.o),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: widget.status.paymentStatusCode == "2"
                        ? mTheme.colorScheme.primary
                        : Colors.lightGreen),
                onPressed: widget.status.paymentStatusCode !=
                        "2" //future we need change to ==
                    ? widget.status.paymentTypeCode == '1' ||
                            widget.status.paymentTypeCode == '2'
                        ? () {
                            paymentCounter.rePayment(widget.status.id);
                          }
                        : null
                    : () {
                        paymentCounter.getBarcode(widget.status.id);
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return PermissionScreen(
                            status: widget.status,
                            barcode: paymentCounter.barcode ?? '',
                          );
                        }));
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.status.paymentStatusCode == "2"
                          ? finishPayment.tr
                          : passToPermission.tr,
                      style: theme.primaryTextStyle.copyWith(
                          fontSize: 18.o,
                          color: theme.white,
                          fontWeight: FontWeight.w700),
                    ),
                    // Gap(20.o),
                    // Text(
                    //   '00:00:10',
                    //   style: theme.primaryTextStyle.copyWith(fontSize: 18.o,
                    //       color: theme.white, fontWeight: FontWeight.w700),
                    // )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  void postRepayment(String orderId) {
    client.post(Links.repayment + orderId);
  }
}
