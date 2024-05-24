import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hostels/network/notification.dart';
import 'package:hostels/providers/payment_provider.dart';
import 'package:hostels/ui/favorite/favorite_screen.dart';
import 'package:hostels/ui/home/home_screen.dart';
import 'package:hostels/ui/profile/profile_screen.dart';
import 'package:hostels/ui/travel/travel_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'bottom_navigation.dart';

class FundamentalScreen extends StatefulWidget {
  const FundamentalScreen({super.key});

  @override
  State<FundamentalScreen> createState() => _FundamentalScreenState();
}

class _FundamentalScreenState extends State<FundamentalScreen> {
  int selectedIndex = 0;
  List<Widget> screens = [];

  @override
  void initState() {
    setupToken();
    _notificationFirebase();
    screens = [
      HomeScreen(onNavigate: navigateToPage),
      const TravelScreen(),
      FavoriteScreen(
        onNavigate: navigateToPage,
      ),
      ProfileScreen(
        onUpdate: () {
          setState(() {});
        },
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: selectedIndex == 0,
      onPopInvoked: (canPop) {
        if (!canPop) {
          setState(() {
            selectedIndex = 0;
          });
        }
      },
      child: Scaffold(
        body: screens[selectedIndex],
        bottomNavigationBar: HomeBottomNavBar(
            selectedIndex: selectedIndex,
            onIndexChanged: (index) {
              setState(() {
                selectedIndex = index;
                print('$selectedIndex clicked');
              });
            }),
      ),
    );
  }

  void navigateToPage(int selectedPage) => setState(() {
        selectedIndex = selectedPage;
        paymentCounter.getAllOrder();
      });

  void _notificationFirebase() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      RemoteNotification? notification = message!.notification;
      if (notification != null) {
        NotificationService().showNotification(
          notification.hashCode,
          notification.body ?? "",
          notification.title ?? "",
        );
      }
    });
    Future.delayed(const Duration(seconds: 1));
    final firebaseMessaging = FirebaseMessaging.instance;
    // (await FirebaseMessaging.instance.getToken());

    await firebaseMessaging.requestPermission();
    String sfCMToken = '';
    if (Platform.isIOS) {
      sfCMToken = await firebaseMessaging.getAPNSToken() ?? '';
    }
    String fCMToken = '';
    if (sfCMToken.isEmpty || Platform.isAndroid) {
      fCMToken = await firebaseMessaging.getToken() ?? '';
    }
    print("$sfCMToken ######### it is tokenee");
    print("$fCMToken ######### it is token");
  }

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

  Future<void> showNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }
}
