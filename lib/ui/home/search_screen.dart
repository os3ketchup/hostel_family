import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/providers/hotels_provider.dart';
import 'package:hostels/ui/home/search_category_card_item.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.onNavigate});

  final Function(int selectedPage) onNavigate;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  var isConnected = false;
  var likeTapped = false;

  @override
  void initState() {

    hostelsCounter.searchHotelByName('');
    WidgetsBinding.instance.addPostFrameCallback((_) => _requestKeyboard());
    super.initState();
  }

  void _requestKeyboard() {
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
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
        return Consumer(
          builder: (context, ref, child) {
            var notifier = ref.watch(hostelsProvider);
            return Scaffold(
                backgroundColor: mTheme.colorScheme.background,
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0.5,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes the position of the shadow
                          ),
                        ],
                      ),
                      child: AppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: mTheme.colorScheme.background,
                        title: TextField(
                          focusNode: _focusNode,
                          style: theme.primaryTextStyle.copyWith(
                              color: mTheme.textTheme.bodyLarge!.color),
                          onChanged: (value) {
                            setState(() {
                              _controller.text = value;
                              notifier.searchHotelByName(value);
                            });
                          },
                          controller: _controller,
                          decoration: InputDecoration(
                              prefixIcon: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: mTheme.colorScheme.primary,
                                ),
                              ),
                              suffixIcon: _controller.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _controller.clear();
                                          hostelsCounter.searchHotelByName('');
                                        });
                                      },
                                    )
                                  : null,
                              hintStyle: theme.primaryTextStyle.copyWith(
                                  color: mTheme.colorScheme.secondary,
                                  fontSize:
                                      mTheme.textTheme.titleMedium!.fontSize),
                              hintText: searchHotel.tr,
                              border: InputBorder.none),
                        ),
                      ),
                    )),
                body: Stack(
                  children: [
                    Column(
                      children: [
                        if (notifier.searchedList == null)
                          Expanded(
                              child: GridView.builder(
                            padding: EdgeInsets.only(bottom: 20.o, top: 20.o),
                            scrollDirection: Axis.vertical,
                            itemCount: 4,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: min(315.w, 315.h),
                                    mainAxisExtent: 230.o),
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                  baseColor: Colors.black26,
                                  highlightColor: Colors.white60,
                                  child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 12.o, vertical: 12.o),
                                      width: min(315.w, 315.h),
                                      height: 230.o,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 4,
                                                spreadRadius: 1,
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                offset: const Offset(1, 4))
                                          ],
                                          color: Colors.white60,
                                          border: Border.all(
                                              width: 1, color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12.o),
                                          ))));
                            },
                          ))
                        else
                          Expanded(
                              child: GridView.builder(
                            padding: EdgeInsets.only(bottom: 20.o, top: 20.o),
                            scrollDirection: Axis.vertical,
                            itemCount: notifier.searchedList!.length,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: min(400.w, 400.h),
                                    mainAxisExtent: 240.o),
                            itemBuilder: (context, index) {
                              return SearchCategoryCardItem(
                                  hostel: notifier.searchedList![index],
                                  onNavigate: widget.onNavigate,
                                  onLike:isConnected&&!likeTapped? () {
                                    notifier.postFavourite(
                                      hotelId:
                                      notifier.searchedList![index].id,
                                    );
                                  }:() {
                                    setState(() {
                                      likeTapped = true;
                                    });
                                  });
                            },
                          )),
                      ],
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
                  ],
                ));
          },
        );
      },
    );
  }
}
