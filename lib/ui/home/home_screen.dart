import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/network/notification.dart';
import 'package:hostels/providers/hotels_provider.dart';
import 'package:hostels/providers/news_provider.dart';
import 'package:hostels/providers/user_provider.dart';
import 'package:hostels/ui/home/category_card_item.dart';
import 'package:hostels/ui/home/choose_all.dart';
import 'package:hostels/ui/home/clicked_category_item.dart';
import 'package:hostels/ui/home/home_appbar.dart';
import 'package:hostels/ui/home/home_search_textfield.dart';
import 'package:hostels/ui/home/loading_item.dart';
import 'package:hostels/ui/home/news/more_news_screen.dart';
import 'package:hostels/ui/home/notification_screen.dart';
import 'package:hostels/ui/home/search_screen.dart';
import 'package:hostels/ui/home/unclicked_category_item.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hostels/ui/profile/privacy_sharing/privacy_sharing_screen.dart';
import 'package:hostels/ui/profile/private_data/private_data_screen.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';
import "package:shimmer/shimmer.dart";

import 'news/announce_card_item.dart';
import 'more/more_screen.dart';

String fcToken = "";

FirebaseMessaging get fcm => FirebaseMessaging.instance;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onNavigate});

  final Function(int selectedPage) onNavigate;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int clickedItem = 0;
  var isConnected = true;
  var likeTapped = false;
  var onClickedWhenDisconnect = false;

  Future<void> setupToken() async {
    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getAPNSToken();

    // Save the initial token to the database
    print('token::: $token');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received message: ${message.notification?.title}");
      // Handle the incoming message here
      showNotification();
    });
  }

  @override
  void initState() {
    setupToken();
    _getFirebase();
    _notificationFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.o),
        child: HomeAppbar(
          onProfileTapped: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const PrivateDataScreen(),
          )),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ));
          },
        ),
      ),
      backgroundColor: mTheme.colorScheme.background,
      body: RefreshIndicator(
        onRefresh: () async {
          await hostelsCounter.getCategoryList();
          await hostelsCounter.getHostelsList();
          await homeCounter.getNewsList();
          userCounter.appUser;
        },
        child: StreamBuilder(
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

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 30.o),
                  child: Column(
                    children: [
                      Gap(20.o),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.o),
                        child: HomeSearchTextField(
                          onNavigate: widget.onNavigate,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchScreen(
                                      onNavigate: widget.onNavigate),
                                ));
                          },
                        ),
                      ),
                      Gap(20.o),
                      Consumer(
                        builder: (context, ref, child) {
                          final notifier = ref.watch(hostelsProvider);
                          return Column(
                            children: [
                              ChooseAllWidget(
                                title: category.tr,
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return MoreScreen(
                                        hostels: notifier.hostelsList ?? [],
                                        onNavigate: widget.onNavigate,
                                      );
                                    },
                                  ));
                                },
                              ),
                              Gap(10.o),
                              if (notifier.categoryList == null)
                                SizedBox(
                                  height: 50.o,
                                  child: ListView.builder(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.o),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 3,
                                    itemBuilder: (context, index) {
                                      return Shimmer.fromColors(
                                          baseColor: Colors.black26,
                                          highlightColor: Colors.white60,
                                          child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 12.o),
                                              width: 100.w,
                                              height: 50.h,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        blurRadius: 4,
                                                        spreadRadius: 1,
                                                        color: Colors.grey
                                                            .withOpacity(0.2),
                                                        offset:
                                                            const Offset(1, 4))
                                                  ],
                                                  color: Colors.white60,
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(12.o),
                                                  ))));
                                    },
                                  ),
                                )
                              else
                                SizedBox(
                                  height: 50.o,
                                  child: ListView.builder(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.o),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: notifier.categoryList!.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            clickedItem = index;
                                          });
                                        },
                                        child: clickedItem == index
                                            ? ClickedCategoryItem(
                                                index: index,
                                                category: notifier
                                                    .categoryList![index],
                                              )
                                            : UnClickedCategoryItem(
                                                index: index,
                                                category: notifier
                                                    .categoryList![index],
                                              ),
                                      );
                                    },
                                  ),
                                ),
                              Gap(20.o),
                              notifier.categoryList == null ||
                                      notifier.hostelsList == null
                                  ? SizedBox(
                                      height: 240.o,
                                      child: ListView.builder(
                                        padding: EdgeInsets.only(left: 12.o),
                                        itemCount: 2,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return const LoadingItem();
                                        },
                                      ),
                                    )
                                  : SizedBox(
                                      height: 225.o,
                                      child: ListView.builder(
                                        padding: EdgeInsets.only(left: 12.o),
                                        itemCount: notifier
                                            .categoryList![clickedItem]
                                            .activeHotels
                                            .length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return CategoryCardItem(
                                            activeHotel: notifier
                                                .categoryList![clickedItem]
                                                .activeHotels[index],
                                            index: index,
                                            hostel: notifier.hostelsList!,
                                            onNavigate: widget.onNavigate,
                                            isConnected: isConnected,
                                            onClickWhenDisconnect: () {
                                              setState(() {
                                                likeTapped = true;
                                                isConnected = false;
                                              });
                                            },
                                            // hostel: hostel![index],
                                          );
                                        },
                                      ),
                                    ),
                              Gap(20.o),
                            ],
                          );
                        },
                      ),

                      // const NearTitleWidget(),
                      // Gap(20.o),
                      // SizedBox(
                      //   height: 250.o,
                      //   child: ListView.builder(
                      //     padding: EdgeInsets.only(left: 12.o),
                      //     itemCount: 10,
                      //     scrollDirection: Axis.horizontal,
                      //     itemBuilder: (context, index) {
                      //       return  CategoryCardItem(hostels: [],);
                      //     },
                      //   ),
                      // ),
                      // Gap(20.o),
                      Consumer(
                        builder: (context, ref, child) {
                          final notifier = ref.watch(homeProvider);

                          return Column(
                            children: [
                              ChooseAllWidget(
                                title: newsAnnouncement.tr,
                                onTap: () {
                                  print('ds');
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return MoreNewsScreen(
                                        newsList: notifier.newsList!,
                                      );
                                    },
                                  ));
                                },
                              ),
                              Gap(20.o),
                              notifier.newsList == null
                                  ? SizedBox(
                                      height: 240.o,
                                      child: ListView.builder(
                                        padding: EdgeInsets.only(left: 12.o),
                                        itemCount: 2,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return const LoadingItem();
                                        },
                                      ),
                                    )
                                  : SizedBox(
                                      height: 240.o,
                                      child: ListView.builder(
                                        padding: EdgeInsets.only(left: 4.o),
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            notifier.newsList!.take(4).length,
                                        itemBuilder: (context, index) {
                                          return AnnounceCardItem(
                                            news: notifier.newsList![index],
                                          );
                                        },
                                      ),
                                    ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: !isConnected
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
                                internetNotExist.tr,
                                style: theme.primaryTextStyle.copyWith(
                                    color: Colors.white, fontSize: 10.o),
                              ),
                            ],
                          ),
                        )
                      : Container(),
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
                                    color: Colors.white, fontSize: 10.o),
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
                                      color: Colors.grey, fontSize: 8.o),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void showNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  void _getFirebase() async {
    debugPrint('request fcmToken');
    await fcm.requestPermission(provisional: true);
    await fcm.setAutoInitEnabled(true);
    String? fcmToken;
    if (Platform.isIOS) {
      fcmToken = await fcm.getAPNSToken();
      debugPrint('apnsToken: $fcmToken');
      if (fcmToken != null) {
        fcmToken = await fcm.getToken();
      }
    } else {
      fcmToken = await fcm.getToken();
    }
    debugPrint('fcmToken: $fcmToken');

    if (fcmToken != null) {
      fcm.subscribeToTopic('users');
    }
  }

  void _notificationFirebase() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      RemoteNotification? notification = message!.notification;
      if (notification != null) {
        NotificationService().showNotification(
          notification.hashCode,
          notification.title ?? "",
          notification.body ?? "",
        );
      }
    });
    Future.delayed(const Duration(seconds: 1));
    (await FirebaseMessaging.instance.getToken());
  }
}
