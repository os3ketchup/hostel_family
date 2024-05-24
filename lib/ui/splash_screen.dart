import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hostels/network/notification.dart';
import 'package:hostels/ui/fundamental/fundamental_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../variables/util_variables.dart';
import 'login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _notificationFirebase();
    Future.delayed(
      const Duration(seconds: 2),
    ).then((value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => (pref.getString(PrefKeys.token) ?? '').isEmpty
              ? const LoginScreen()
              :  const FundamentalScreen(),
        )));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: mTheme.colorScheme.primary,
        body: Center(
            child: Text('FAMILY HOSTEL',
                style: GoogleFonts.poppins(

                  textStyle:  TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: mTheme.textTheme.headlineLarge!.fontSize,
                    color: mTheme.colorScheme.onPrimary,
                    overflow: TextOverflow.ellipsis,
                  ),
                ))));
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
