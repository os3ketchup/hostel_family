import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/providers/room_provider.dart';
import 'package:hostels/ui/home/detail_room/order/choosing_room/amount_travellers_bottom_sheet.dart';
import 'package:hostels/ui/home/detail_room/order/choosing_room/calendar_bottom_sheet.dart';
import 'package:hostels/ui/home/detail_room/order/choosing_room/filter_container.dart';
import 'package:hostels/ui/home/detail_room/order/choosing_room/rooms_item.dart';

import 'package:hostels/ui/home/detail_room/order/order_appbar.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../detail/order_hotel_bottom_sheet.dart';
import 'choosing_room/loading_choosing_room_item.dart';
import 'choosing_room/room_information.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen(
      {super.key, required this.hotelId, required this.onNavigate});

  final Function(int selectedPage) onNavigate;
  final String hotelId;

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String startedDate = DateFormat('dd.MM.yyyy').format(DateTime.now());
  String finishedDate = DateFormat('dd.MM.yyyy')
      .format(DateTime.now().add(const Duration(days: 1)));

  String rangeDate =
      '${DateFormat('MMMM d, y').format(DateTime.now())} - ${DateFormat('MMMM d, y').format(DateTime.now().add(const Duration(days: 1)))}';
  String travel = "1 ta";
  int adultsIncrementer = 1;
  int childrenIncrementer = 0;
  int roomsIncrementer = 1;
  int selectedIndex = -1;
  bool isFiltered = false;
  int amountNights = 1;

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.

  @override
  void initState() {
    roomCounter.getAllRoom(hotelId: widget.hotelId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    ThemeData mTheme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.o),
          child: OrderAppBar(
            titleAppbar: order.tr,
            onBackPressed: () {
              Navigator.pop(context);
            },
          )),
      backgroundColor: mTheme.colorScheme.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 30.o),
        child: Column(
          children: [
            Gap(20.o),
            FilterContainer(
              leadingIcon: Icons.date_range,
              title: date.tr,
              subtitle: rangeDate,
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: mTheme.colorScheme.background,
                  useSafeArea: true,
                  isScrollControlled: true,
                  /* constraints: BoxConstraints.tight(Size(
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height)),*/
                  context: context,
                  builder: (context) {
                    return CalendarBottomSheet(
                      onTap: (date, startDate, finishDate) {
                        setState(() {
                          rangeDate = date;
                          startedDate = startDate;
                          finishedDate = finishDate;
                        });
                      },
                      date: rangeDate,
                    );
                  },
                );
              },
            ),
            Gap(10.o),
            FilterContainer(
              leadingIcon: Icons.person,
              title: guest.tr,
              subtitle:
                  '${adultsIncrementer + childrenIncrementer} ${geust.tr}, $roomsIncrementer ${roomCount.tr}',
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: mTheme.colorScheme.background,
                  isScrollControlled: true,
                  useSafeArea: true,
/*                  constraints: BoxConstraints.tight(Size(
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height))*/
                  context: context,
                  builder: (context) {
                    return AmountTravellersBottomSheet(
                      adultsIncrementer: adultsIncrementer,
                      childrenIncrementer: childrenIncrementer,
                      roomsIncrementer: roomsIncrementer,
                      onTap: (adult, children, room) {
                        setState(() {
                          adultsIncrementer = adult;
                          childrenIncrementer = children;
                          roomsIncrementer = room;
                        });
                      },
                    );
                  },
                );
              },
            ),
            Gap(20.o),
            Consumer(builder: (context, ref, child) {
              print('${isFiltered}works?');
              final notifier = ref.watch(roomProvider);
              List<Widget> roomWidgets = [];
              if (isFiltered) {
                for (final room in notifier.roomList ?? []) {
                  roomWidgets.add(
                    RoomItem(
                      room: room,
                      onReserve: (price) {

                        showModalBottomSheet(
                          backgroundColor: mTheme.colorScheme.background,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return OrderHotelBottomSheet(
                              room: room,
                              startedDate: startedDate,
                              finishedDate: finishedDate,
                              onNavigate: widget.onNavigate, totalPrice: price.toString(),
                            );
                          },
                        );
                      },
                      onTakeDetail: (price) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoomInformationScreen(

                                  room: room,
                                  startDate: startedDate,
                                  finishDate: finishedDate,
                                  onNavigate: widget.onNavigate, price: price,),
                            ));
                      },
                      amountNight: amountNights,
                    ),
                  );
                }
              } else {
                for (final room in notifier.allRoomList ?? []) {
                  roomWidgets.add(RoomItem(
                    room: room,
                    onReserve: (price) {
                      showModalBottomSheet(
                        backgroundColor: mTheme.colorScheme.background,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return OrderHotelBottomSheet(
                            room: room,
                            startedDate: startedDate,
                            finishedDate: finishedDate,
                            onNavigate: widget.onNavigate, totalPrice: price.toString(),
                          );
                        },
                      );
                    },
                    onTakeDetail: (price) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoomInformationScreen(
                                room: room,
                                startDate: startedDate,
                                finishDate: finishedDate,
                                onNavigate: widget.onNavigate, price: price,),
                          ));
                    },
                    amountNight: amountNights,
                  ));
                }
              }
              if (isFiltered) {
                if (notifier.roomList == null) {
                  // Show circular progress indicator while loading
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12.o),
                        child: InkWell(
                          onTap: () {
                            roomCounter.getRoomList(
                              childCount: childrenIncrementer,
                              finishedSDate: finishedDate,
                              hotelId: widget.hotelId,
                              roomNumber: roomsIncrementer,
                              startedDate: startedDate,
                              adultCount: adultsIncrementer,
                            );
                            setState(() {
                              isFiltered = true;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(8.o),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.o),
                                  color: mTheme.colorScheme.primary),
                              child: Center(
                                  child: SizedBox(
                                      height: 20.o,
                                      width: 20.o,
                                      child: CircularProgressIndicator.adaptive(
                                        backgroundColor:
                                            mTheme.colorScheme.onSecondary,
                                      )))),
                        ),
                      ),
                      Gap(20.o),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12.o),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            notifier.allRoomList == null
                                ? Container()
                                : Text(
                                    '${totally.tr}: ${notifier.allRoomList!.length} ${amount.tr} ...',
                                    style: theme.primaryTextStyle.copyWith(
                                        color:
                                            mTheme.textTheme.bodyMedium!.color),
                                  ),
                            InkWell(
                              highlightColor:
                                  mTheme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.o),
                              onTap: () {
                                setState(() {
                                  isFiltered = false;
                                });
                                notifier.getAllRoom(hotelId: widget.hotelId);
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8.o),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.o),
                                      border: Border.all(
                                          width: 0.5.o,
                                          color: mTheme.colorScheme.primary)),
                                  child: Text(
                                    all.tr,
                                    style: theme.primaryTextStyle.copyWith(
                                        color: mTheme.colorScheme.primary),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      const LoadingChoosingRoomItem(),
                    ],
                  );
                }
              } else {
                if (notifier.allRoomList == null) {
                  // Show circular progress indicator while loading
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12.o),
                        child: InkWell(
                          onTap: () {
                            roomCounter.getRoomList(
                              childCount: childrenIncrementer,
                              finishedSDate: finishedDate,
                              hotelId: widget.hotelId,
                              roomNumber: roomsIncrementer,
                              startedDate: startedDate,
                              adultCount: adultsIncrementer,
                            );
                            setState(() {
                              amountNights = analyseDifferenceDays(
                                  startedDate, finishedDate);
                              isFiltered = true;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(8.o),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.o),
                                  color: mTheme.colorScheme.primary),
                              child: Text(
                                textAlign: TextAlign.center,
                                search.tr,
                                style: theme.primaryTextStyle.copyWith(
                                    color: mTheme.colorScheme.onPrimary),
                              )),
                        ),
                      ),
                      Gap(20.o),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12.o),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            notifier.allRoomList == null
                                ? Container()
                                : Text(
                                    '${totally.tr}: ${notifier.allRoomList!.length} ${amount.tr}',
                                    style: theme.primaryTextStyle.copyWith(
                                        color:
                                            mTheme.textTheme.bodyMedium!.color),
                                  ),
                            InkWell(
                              highlightColor:
                                  mTheme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.o),
                              onTap: () {
                                setState(() {
                                  isFiltered = false;
                                });
                                notifier.getAllRoom(hotelId: widget.hotelId);
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8.o),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.o),
                                      border: Border.all(
                                          width: 0.5.o,
                                          color: mTheme.colorScheme.primary)),
                                  child: Text(
                                    all.tr,
                                    style: theme.primaryTextStyle.copyWith(
                                        color: mTheme.colorScheme.primary),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      const LoadingChoosingRoomItem(),
                    ],
                  );
                }
              }
              if (isFiltered) {
                if (notifier.roomList!.isEmpty) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12.o),
                        child: InkWell(
                          onTap: () {
                            roomCounter.getRoomList(
                              childCount: childrenIncrementer,
                              finishedSDate: finishedDate,
                              hotelId: widget.hotelId,
                              roomNumber: roomsIncrementer,
                              startedDate: startedDate,
                              adultCount: adultsIncrementer,
                            );
                            setState(() {
                              amountNights = analyseDifferenceDays(
                                  startedDate, finishedDate);
                              isFiltered = true;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(8.o),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.o),
                                  color: mTheme.colorScheme.primary),
                              child: Text(
                                textAlign: TextAlign.center,
                                search.tr,
                                style: theme.primaryTextStyle.copyWith(
                                    color: mTheme.colorScheme.onPrimary),
                              )),
                        ),
                      ),
                      Gap(20.o),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12.o),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            notifier.allRoomList == null
                                ? Container()
                                : Text(
                                    '${totally.tr}: ${notifier.allRoomList!.length} ${amount.tr} ${fromThat.tr} ${notifier.roomList!.length} ${found.tr}',
                                    style: theme.primaryTextStyle.copyWith(
                                        color:
                                            mTheme.textTheme.bodyMedium!.color),
                                  ),
                            InkWell(
                              highlightColor:
                                  mTheme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.o),
                              onTap: () {
                                setState(() {
                                  isFiltered = false;
                                });
                                notifier.getAllRoom(hotelId: widget.hotelId);
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8.o),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.o),
                                      border: Border.all(
                                          width: 0.5.o,
                                          color: mTheme.colorScheme.primary)),
                                  child: Text(
                                    all.tr,
                                    style: theme.primaryTextStyle.copyWith(
                                        color: mTheme.colorScheme.primary),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Gap(200.o),
                      Center(
                        child: Text(
                          roomIsNotExist.tr,
                          style: theme.primaryTextStyle
                              .copyWith(color: mTheme.colorScheme.primary),
                        ),
                      ),
                      Gap(200.o),
                    ],
                  );
                }
              } else {
                if (notifier.allRoomList!.isEmpty) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12.o),
                        child: InkWell(
                          onTap: () {
                            roomCounter.getRoomList(
                              childCount: childrenIncrementer,
                              finishedSDate: finishedDate,
                              hotelId: widget.hotelId,
                              roomNumber: roomsIncrementer,
                              startedDate: startedDate,
                              adultCount: adultsIncrementer,
                            );
                            setState(() {
                              amountNights = analyseDifferenceDays(
                                  startedDate, finishedDate);
                              isFiltered = true;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(8.o),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.o),
                                  color: mTheme.colorScheme.primary),
                              child: Text(
                                textAlign: TextAlign.center,
                                search.tr,
                                style: theme.primaryTextStyle.copyWith(
                                    color: mTheme.colorScheme.onPrimary),
                              )),
                        ),
                      ),
                      Gap(20.o),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12.o),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            notifier.allRoomList == null
                                ? Container()
                                : Text(
                                    '${totally.tr}: ${notifier.allRoomList!.length} ${amount.tr}',
                                    style: theme.primaryTextStyle.copyWith(
                                        color:
                                            mTheme.textTheme.bodyMedium!.color),
                                  ),
                            InkWell(
                              highlightColor:
                                  mTheme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.o),
                              onTap: () {
                                isFiltered = false;
                                notifier.getAllRoom(hotelId: widget.hotelId);
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8.o),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.o),
                                      border: Border.all(
                                          width: 0.5.o,
                                          color: mTheme.colorScheme.primary)),
                                  child: Text(
                                    all.tr,
                                    style: theme.primaryTextStyle.copyWith(
                                        color: mTheme.colorScheme.primary),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Gap(200.o),
                      SizedBox(
                        height: 200.o,
                        child: Text(
                          roomIsNotExist.tr,
                          style: theme.primaryTextStyle
                              .copyWith(color: mTheme.colorScheme.primary),
                        ),
                      ),
                      Gap(200.o),
                    ],
                  );
                }
              }
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.o),
                    child: InkWell(
                      onTap: () {
                        roomCounter.getRoomList(
                          childCount: childrenIncrementer,
                          finishedSDate: finishedDate,
                          hotelId: widget.hotelId,
                          roomNumber: roomsIncrementer,
                          startedDate: startedDate,
                          adultCount: adultsIncrementer,
                        );
                        setState(() {
                          amountNights =
                              analyseDifferenceDays(startedDate, finishedDate);

                          isFiltered = true;
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.all(8.o),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.o),
                              color: mTheme.colorScheme.primary),
                          child: Text(
                            textAlign: TextAlign.center,
                            search.tr,
                            style: theme.primaryTextStyle
                                .copyWith(color: mTheme.colorScheme.onPrimary),
                          )),
                    ),
                  ),
                  Gap(20.o),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.o),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        notifier.allRoomList == null
                            ? Container()
                            : isFiltered
                                ? Text(
                                    '${totally.tr}: ${notifier.allRoomList!.length} ${amount}, ${fromThat.tr} ${notifier.roomList!.length} ${amount.tr} ${found.tr}',
                                    style: theme.primaryTextStyle.copyWith(
                                        color:
                                            mTheme.textTheme.bodyMedium!.color),
                                  )
                                : Text(
                                    '${totally.tr}: ${notifier.allRoomList!.length} ${amount.tr}',
                                    style: theme.primaryTextStyle.copyWith(
                                        color:
                                            mTheme.textTheme.bodyMedium!.color),
                                  ),
                        InkWell(
                          highlightColor:
                              mTheme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.o),
                          onTap: () {
                            notifier.getAllRoom(hotelId: widget.hotelId);
                            isFiltered = false;
                          },
                          child: Container(
                              padding: EdgeInsets.all(8.o),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.o),
                                  border: Border.all(
                                      width: 0.5.o,
                                      color: mTheme.colorScheme.primary)),
                              child: Text(
                                all.tr,
                                style: theme.primaryTextStyle.copyWith(
                                    color: mTheme.colorScheme.primary),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Gap(20.o),
                  ...roomWidgets
                ],
              );
            }),
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
                          .copyWith(color: mTheme.textTheme.bodyMedium!.color),
                    )
                  : Container(),
            ],
          ),
          Row(
            children: [
              IconButton(
                  onPressed: incrementer == 0 ? null : onRemove,
                  icon: Container(
                      padding: EdgeInsets.all(2.o),
                      decoration: BoxDecoration(
                          color: theme.backgroundGrey,
                          border: Border.all(
                              width: 1.o,
                              color: theme.primaryColor.withOpacity(0.2)),
                          borderRadius: BorderRadius.all(Radius.circular(8.o))),
                      child: Icon(
                        Icons.remove,
                        size: 20.o,
                        color: incrementer == 0 ? Colors.grey : Colors.black,
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
                          color: theme.backgroundGrey,
                          border: Border.all(
                              width: 1.o,
                              color: theme.primaryColor.withOpacity(0.2)),
                          borderRadius: BorderRadius.all(Radius.circular(8.o))),
                      child: Icon(
                        Icons.add,
                        size: 20.o,
                        color: incrementer == 10 ? Colors.grey : Colors.black,
                      ))),
            ],
          )
        ],
      ),
    );
  }

  int analyseDifferenceDays(String starting, String finishing) {
    DateFormat format = DateFormat('dd.MM.yyyy');
    DateTime startDate = format.parse(starting);
    DateTime finishDate = format.parse(finishing);
    Duration difference = finishDate.difference(startDate);
    int differenceInDays = difference.inDays;
    return differenceInDays;
  }
}
