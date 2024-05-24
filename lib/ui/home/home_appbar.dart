import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/network/client.dart';

import 'package:hostels/ui/login/login.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';

import '../../variables/images.dart';
import '../../variables/links.dart';
import '../../providers/user_provider.dart';

class HomeAppbar extends StatefulWidget {
  const HomeAppbar(
      {super.key, required this.onTap, required this.onProfileTapped});

  final VoidCallback onTap;
  final VoidCallback onProfileTapped;

  @override
  State<HomeAppbar> createState() => _HomeAppbarState();
}

class _HomeAppbarState extends State<HomeAppbar> {
  var name = '';

  @override
  void initState() {
    userCounter.getNotificationList();
    getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return SafeArea(
      child: Container(
        color: mTheme.colorScheme.background,
        height: 80.o,
        child: Column(
          children: [
            Platform.isIOS ? Gap(19.o) : Gap(10.o),
            Consumer(
              builder: (context, ref, child) {
                final notifier = ref.watch(userProvider);
                return Column(
                  children: [
                    Row(
                      children: [
                        Gap(20.o),
                        InkWell(
                          onTap: widget.onProfileTapped,
                          child: SizedBox(
                              width: 50.o,
                              height: 50.o,
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.o)),
                                  child: notifier.appUser!.img.isNotEmpty
                                      ? Image.network(
                                          notifier.appUser!.img,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          IMAGES.person,
                                          fit: BoxFit.cover,
                                        ))),
                        ),
                        Gap(20.o),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getGreeting(),
                              style: theme.primaryTextStyle.copyWith(
                                  color: mTheme.textTheme.bodyLarge!.color),
                            ),
                            Text(
                              '${notifier.appUser?.firstName} ${notifier.appUser?.lastName}',
                              style: theme.hintTextFieldStyle.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: mTheme.textTheme.bodyLarge!.color),
                            )
                          ],
                        )),
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: widget.onTap,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: mTheme.colorScheme.onSurfaceVariant,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(50.o))),
                                height: 50,
                                width: 50,
                                child: Icon(
                                  Icons.local_post_office,
                                  color: mTheme.colorScheme.primary,
                                ),
                              ),
                            ),
                            if (notifier.hostelNotificationList == null)
                              Container(),
                            if (notifier.hostelNotificationList != null &&
                                notifier.hostelNotificationList!
                                    .where((notification) =>
                                        notification.status == 'unread')
                                    .toList()
                                    .isEmpty)
                              Container(),
                            if (notifier.hostelNotificationList != null &&
                                notifier.hostelNotificationList!
                                    .where((notification) =>
                                        notification.status == 'unread')
                                    .toList()
                                    .isNotEmpty)
                              Positioned(
                                right: 0,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(top: 9, right: 9),
                                  padding:
                                      const EdgeInsets.only(left: 1, top: 1),
                                  decoration: BoxDecoration(
                                    color: theme.purpleColorClear,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  width: 15,
                                  height: 15,
                                  child: Text(
                                    '${notifier.hostelNotificationList!.where((notification) => notification.status == 'unread').toList().length}',
                                    style: theme.primaryTextStyle.copyWith(
                                      fontSize: 10,
                                      color: theme.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Gap(20.o)
                      ],
                    ),
                    Gap(10.o)
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void getProfileData() async {
    await client.get(Links.getProfile).then((result) {
      if (result.status == 200) {
        pref.setString(PrefKeys.name, result.data['first_name'].toString());
        pref.setString(PrefKeys.surname, result.data['last_name'].toString());
        pref.setString(PrefKeys.born, result.data['born_date'].toString());
        pref.setString(PrefKeys.gender, result.data['gender'].toString());
        pref.setString(PrefKeys.authKey, result.data['auth_key'].toString());
        pref.setString(PrefKeys.phoneNumber, result.data['phone']).toString();
        pref.setString(
            PrefKeys.genderName, result.data['gender_name'].toString());
        pref.setString(PrefKeys.userId, result.data['id'].toString());
        pref.setString(PrefKeys.status, result.data['status'].toString());
        pref.setString(PrefKeys.photo, result.data['img'].toString());
        userCounter.appUser = AppUser(
          firstName: result.data['first_name'].toString(),
          lastName: result.data['last_name'].toString(),
          gender: result.data['gender'].toString(),
          bornDate: result.data['born_date'].toString(),
          authKey: result.data['auth_key'].toString(),
          phone: result.data['phone'].toString(),
          status: result.data['status'].toString(),
          id: result.data['id'].toString(),
          genderName: result.data['gender_name'].toString(),
          img: result.data['img'].toString(),
        );
        userCounter.update();
      } else if (result.status == 401) {
        navigate();
      }
    });
  }

  void navigate() {
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const LoginScreen();
        },
      ),
    );
  }

  String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour >= 4 && hour < 10) {
      return goodMorning.tr;
    } else if (hour >= 10 && hour < 16) {
      return goodAfternoon.tr;
    } else {
      return goodEvening.tr;
    }
  }
}
