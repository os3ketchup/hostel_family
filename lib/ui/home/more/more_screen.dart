import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/ui/home/detail_room/order/order_appbar.dart';
import 'package:hostels/ui/home/more/category_horizontal_card_item.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';

import '../../../providers/hotels_provider.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen(
      {super.key, required this.hostels, required this.onNavigate});

  final List<Hostels> hostels;
  final Function(int selectedPage) onNavigate;

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  var isConnected = false;
  var likeTapped = false;
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(stream: Connectivity().onConnectivityChanged, builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<ConnectivityResult>? result = snapshot.data;
        if (result!.contains(ConnectivityResult.mobile)) {
          isConnected = true;
          likeTapped = false;
        } else if (result.contains(ConnectivityResult.wifi)) {
          isConnected = true;
          likeTapped = false;
        } else {
          isConnected = false;
        }
      } else {}

      return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.o),
            child: OrderAppBar(
              titleAppbar: more.tr,
              onBackPressed: () {
                Navigator.pop(context);
              },
            )),
        body: Stack(children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: widget.hostels.length,
            itemBuilder: (context, index) {
              return CategoryHorizontalCardItem(
                hostels: widget.hostels[index],
                onNavigate: widget.onNavigate, isConnected: isConnected,
                  onClickWhenDisconnect: () {
                    setState(() {
                      likeTapped = true;
                      isConnected = false;
                    });
                  },
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: likeTapped
                ? Container(
              padding: EdgeInsets.all(12.o),
              color: Colors.black,
              width: double.infinity,
              height: 75.o,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    maxLines: 2,
                    reaction.tr,
                    style: theme.primaryTextStyle.copyWith(
                        color: Colors.white, fontSize: 12.o),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        likeTapped = false;
                      });
                    },
                    child: Text(
                      textAlign: TextAlign.end,
                      skip.tr,
                      style: theme.primaryTextStyle.copyWith(
                          color: Colors.grey, fontSize: 10.o),
                    ),
                  ),
                ],
              ),
            )
                : Container(),
          )


        ],),
      );
    },);
  }
}
