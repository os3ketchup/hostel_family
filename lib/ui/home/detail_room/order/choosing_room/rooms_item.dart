import 'package:flutter/material.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/providers/hotels_provider.dart';
import 'package:hostels/providers/room_provider.dart';
import 'package:hostels/variables/icons.dart';
import 'package:hostels/variables/images.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transparent_image/transparent_image.dart';

class RoomItem extends StatefulWidget {
  const RoomItem(
      {super.key,
      required this.room,
      required this.onReserve,
      required this.onTakeDetail, required this.amountNight});

  final Room room;
  final Function(int price) onReserve;
  final Function(int price) onTakeDetail;
  final int amountNight;

  @override
  State<RoomItem> createState() => _RoomItemState();
}

class _RoomItemState extends State<RoomItem> {
  int currentIndex = 0;


  @override
  Widget build(BuildContext context) {


    List<ActiveFeatures> takeSecondTwo(List<ActiveFeatures> list) {
      // Check if the list has at least two elements
      if (list.length >= 4) {
        return list.sublist(2, 4);
      } else {
        // Return an empty list if there are fewer than two elements
        return [];
      }
    }

    List<ActiveFeatures> takeFirstTwo(List<ActiveFeatures> list) {
      // Check if the list has at least two elements
      if (list.length >= 2) {
        return list.sublist(0, 2);
      } else {
        // Return an empty list if there are fewer than two elements
        return [];
      }
    }

    ThemeData mTheme = Theme.of(context);

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(color: mTheme.colorScheme.onPrimary,boxShadow: [BoxShadow(blurRadius: 4,offset:Offset(1, 4) ,spreadRadius: 0.3,color: Colors.black.withOpacity(0.2),)],
          border: Border.all(width: 1.o, color: Colors.grey.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(12.o)),
      margin: EdgeInsets.symmetric(horizontal: 12.o,vertical: 6.o),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(
          children: [
            SizedBox(
              height: 200.o,
              width: double.infinity,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.room.images.length,
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                itemBuilder: (context, index) {
                  return FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: NetworkImage(widget.room.images[index]),
                    height: 200.o,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 3,
                  bottom: 12.o,
                ),
                alignment: Alignment.center,
                height: 8.o,
                width: 100.o,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.room.images.length,
                  //widget.room.images.length,
                  itemBuilder: (context, index) {
                    return currentIndex == index
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.o),
                              color: Colors.white,
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 2.o),
                            height: 12.o,
                            width: 15.o,
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.o),
                              color: Colors.white.withOpacity(0.6),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 2.o),
                            height: 8.o,
                            width: 8.o,
                          );
                  },
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.o, vertical: 6.o),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.o),
                        color: Colors.black.withOpacity(0.6)),
                    margin: EdgeInsets.only(right: 12.o, bottom: 12.o),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          width: 20.o,
                          height: 20.o,
                          SVGIcons.multiImages,
                          color: Colors.white,
                        ),
                        Gap(6.o),
                        Text(
                          '${widget.room.images.length}',
                          style: theme.primaryTextStyle
                              .copyWith(color: Colors.white),
                        )
                      ],
                    )))
          ],
        ),
        Gap(10.o),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12.o),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 300.o,
                child: Text(
                  widget.room.name,
                  style: theme.primaryTextStyle
                      .copyWith(color: mTheme.colorScheme.primary),
                ),
              ),
              Gap(10.o),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final item in takeFirstTwo(widget.room.activeFeatures))
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2.o),
                      child: Row(children: [
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
                      ]),
                    ),
                ],
              ),
              Gap(10.o),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final item in takeSecondTwo(widget.room.activeFeatures))
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2.o),
                      child: Row(children: [
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
                      ]),
                    ),
                ],
              ),
              Gap(10.o),
              Row(children: [
                const Icon(Icons.bed),
                Gap(10.o),
                Text('${widget.room.roomNumber} ${withRoom.tr}',style: theme.primaryTextStyle.copyWith(color: mTheme.textTheme.bodySmall!.color),)
              ]),
              Gap(10.o),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(Icons.family_restroom),
                      Gap(10.o),
                      Text(
                          '${int.parse(widget.room.adultCount) + int.parse(widget.room.childCount)}'
                          ' ${geust.tr}',style: theme.primaryTextStyle.copyWith(color: mTheme.textTheme.bodySmall!.color),)
                    ],
                  ),
                  Text('${widget.room.roomCount} ${leftRoom.tr}',
                      style: theme.primaryTextStyle
                          .copyWith(color: mTheme.colorScheme.error)),
                ],
              ),
              Gap(10.o),
              InkWell(
                onTap: () {
                  widget.onTakeDetail(formatStringToCash(widget.room.originalPrice, widget.amountNight));
                },
                child: Container(
                  padding: EdgeInsets.only(right: 12.o),
                  width: 130.o,
                  child: Row(
                    children: [
                      Text(
                        more.tr,
                        style: theme.primaryTextStyle
                            .copyWith(color: mTheme.colorScheme.primary),
                      ),
                      Gap(10.o),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: mTheme.colorScheme.primary,
                        size: 10.o,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Gap(10.o),
        const Divider(),
        Gap(10.o),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12.o),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  widget.room.discountPrice != '0'
                      ? Text(
                          '${numberFormat(widget.room.discountPrice)}UZS ${night.tr}',
                          style: theme.primaryTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              color: mTheme.textTheme.bodyMedium!.color),
                        )
                      : Text(
                          '${numberFormat(widget.room.originalPrice)}UZS ${night.tr}',
                          style: theme.primaryTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              color: mTheme.textTheme.bodyMedium!.color),
                        ),
                  Gap(10.o),
                  widget.room.discountPrice != '0'
                      ? Text(
                          widget.room.originalPrice,
                          style: theme.primaryTextStyle.copyWith(
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.lineThrough),
                        )
                      : Container(),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${total.tr}: ${numberFormat('${formatStringToCash(widget.room.originalPrice, widget.amountNight)}')} UZS',
                      style: theme.primaryTextStyle.copyWith(
                          fontWeight: FontWeight.w400,
                          color: mTheme.textTheme.bodyMedium!.color)),
                  const Spacer(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.o)),
                          backgroundColor: mTheme.colorScheme.primary),
                      onPressed: () {
                        widget.onReserve(formatStringToCash(widget.room.originalPrice, widget.amountNight));
                      },
                      child: Text(
                        reserve.tr,
                        style: theme.primaryTextStyle
                            .copyWith(color: mTheme.colorScheme.onPrimary,fontSize: 12.o),
                      )),
                ],
              ),
              Gap(10.o),
            ],
          ),
        )
      ]),
    );
  }


  String numberFormat(String currency) {
    NumberFormat formatter =
        NumberFormat.currency(decimalDigits: 0, symbol: '');
    double formattedCurrency = double.tryParse(currency) ?? 0;
    return formatter.format(formattedCurrency);
  }

  int formatStringToCash(String price,int amount){
   var result =  price.replaceAll(' ', '');
   var resultInt = int.parse(result);
    print(resultInt*amount);
    print('w');
    return resultInt*amount;
  }

}
