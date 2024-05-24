import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/providers/theme_provider.dart';
import 'package:hostels/ui/login/login.dart';
import 'package:hostels/ui/profile/comments/my_comments_screen.dart';
import 'package:hostels/ui/profile/language_bottom_sheet.dart';
import 'package:hostels/ui/profile/privacy_sharing/privacy_sharing_screen.dart';
import 'package:hostels/ui/profile/private_data/private_data_screen.dart';
import 'package:hostels/providers/user_provider.dart';
import 'package:hostels/variables/icons.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../variables/images.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.onUpdate});
  final VoidCallback onUpdate;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> modeList = [light.tr, dark.tr, system.tr];
  List<String> modeListKey = ['light','dark','system'];




  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Scaffold(
        backgroundColor: mTheme.colorScheme.background,
        body: Consumer(
          builder: (context, ref, child) {
            final notifier = ref.watch(userProvider);
            final themeNotifier = ref.watch(themeProvider);
            return SingleChildScrollView(
              child: Column(
                children: [
                  Gap(100.o),
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.o),
                        width: 85.o,
                        height: 85.o,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.o)),
                            border: DashedBorder.fromBorderSide(
                              side: BorderSide(
                                  width: 2.o,
                                  color: mTheme.colorScheme.primary
                                      .withOpacity(0.6)),
                              dashLength: 4,
                            ),
                            color: mTheme.colorScheme.background),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50.o)),
                          child: notifier.appUser!.img.isEmpty
                              ? Image.asset(
                                  IMAGES.person,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  notifier.appUser!.img,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      // Positioned(
                      //     right: 0,
                      //     bottom: 0,
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         border: Border.all(width: 4.o, color: theme.white),
                      //         borderRadius: BorderRadius.all(Radius.circular(50.o)),
                      //         color: theme.primaryColor,
                      //       ),
                      //       width: 30.o,
                      //       height: 30.o,
                      //       child: Icon(
                      //         Icons.edit,
                      //         color: theme.white,
                      //         size: 16.o,
                      //       ),
                      //     ))
                    ],
                  ),
                  Gap(20.o),
                  Text(
                    '${notifier.appUser?.firstName} ${notifier.appUser?.lastName}',
                    style: theme.primaryTextStyle.copyWith(
                        color: mTheme.colorScheme.primary,
                        fontWeight: FontWeight.w700),
                  ),
                  Gap(10.o),
                  Text(
                    '+${notifier.appUser!.phone}',
                    style: theme.hintTextFieldStyle
                        .copyWith(color: mTheme.colorScheme.secondary),
                  ),
                  Gap(20.o),
                  _buildProfileItems(
                      privateInfo.tr,
                      SVGIcons.profilePerson,
                      () => _goDefinedNavigation(const PrivateDataScreen()),
                      mTheme.colorScheme.primary,
                      mTheme),
                  _buildProfileItems(
                      privacySharing.tr,
                      SVGIcons.shieldDone,
                      () => _goDefinedNavigation(const PrivacySharingScreen()),
                      mTheme.colorScheme.primary,
                      mTheme),
                  // _buildProfileItems(
                  //     notification.tr,
                  //     SVGIcons.notification,
                  //     () => _goDefinedNavigation(const NotificationScreen()),
                  //     mTheme.colorScheme.primary,mTheme),
                  _buildProfileItems(
                      comments.tr,
                      SVGIcons.comment,
                      () => _goDefinedNavigation(const MyCommentScreen()),
                      mTheme.colorScheme.primary,
                      mTheme),
                  _buildNightMode(themeNotifier, system.tr, SVGIcons.mask,
                      theme.primaryColor, mTheme),
                  buildLanguageMode(themeNotifier, language.tr,
                      SVGIcons.trasnlate, mTheme.colorScheme.primary, mTheme),
                  _buildProfileItems(isLast: true, exit.tr, SVGIcons.logout,
                      () {
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    //   return LoginScreen();
                    // },));
                    // pref.remove(PrefKeys.token);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(logOut.tr,
                              style: theme.primaryTextStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: mTheme.textTheme.bodyMedium!.color)),
                          content: Text(
                              maxLines: 3,
                              areYouSureLogOut.tr,
                              style: theme.primaryTextStyle.copyWith(
                                  fontSize:
                                      mTheme.textTheme.bodyMedium!.fontSize,
                                  color: mTheme.textTheme.bodyMedium!.color)),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Close the AlertDialog
                              },
                              child: Text(
                                no.tr,
                                style: theme.primaryTextStyle.copyWith(
                                    color: mTheme.colorScheme.primary),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                pref.remove(PrefKeys.token);
                                pref.remove(PrefKeys.language);
                                pref.remove(PrefKeys.authKey);
                                pref.remove(PrefKeys.genderName);
                                pref.remove(PrefKeys.gender);
                                pref.remove(PrefKeys.name);
                                pref.remove(PrefKeys.surname);
                                pref.remove(PrefKeys.born);
                                pref.remove(PrefKeys.status);
                                pref.remove(PrefKeys.theme);
                                pref.remove(PrefKeys.userId);
                                pref.remove(PrefKeys.photo);
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                yes.tr,
                                style: theme.primaryTextStyle
                                    .copyWith(color: mTheme.colorScheme.error),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }, Colors.red, mTheme),
                ],
              ),
            );
          },
        ));
  }

  void _goDefinedNavigation(Widget route) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => route,
        ));
  }

  Widget buildLanguageMode(ThemeNotifier notifier, String titleItem,
      String icon, Color colorItem, ThemeData mTheme) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isDismissible: true,
          isScrollControlled: false,
          backgroundColor: mTheme.colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24.o),
            ),
          ),
          builder: (context) {
            return LanguageBottomSheet(
                onSave: (lan) {
                  var localizationDelegate =
                      LocalizedApp.of(context).delegate;
                  localizationDelegate
                      .changeLocale(Locale(lan));
                  widget.onUpdate();
                  setState(() {});
                });
          },
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Gap(5.o),
          Row(
            children: [
              Gap(20.o),
              SvgPicture.asset(
                SVGIcons.trasnlate,
                color: colorItem,
              ),
              Gap(10.o),
              Expanded(
                child: Text(
                  titleItem,
                  style: theme.primaryTextStyle.copyWith(
                      color: colorItem,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.o),
                ),
              ),
              Icon(
                Icons.navigate_next,
                color: colorItem,
              )
            ],
          ),
          Gap(20.o),
          Container(
            width: double.infinity,
            height: 1.o,
            color: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItems(String titleItem, String icon,
      VoidCallback onGestureClicked, Color colorItem, ThemeData mTheme,
      {bool isLast = false}) {
    return InkWell(
        onTap: onGestureClicked,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.o),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Gap(20.o),
              Row(
                children: [
                  Gap(10.o),
                  SvgPicture.asset(
                    width: 24.o,
                    height: 24.o,
                    icon,
                    color: colorItem,
                  ),
                  Gap(10.o),
                  Expanded(
                    child: Text(
                      titleItem,
                      style: theme.primaryTextStyle.copyWith(
                          color: colorItem,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.o),
                    ),
                  ),
                  Icon(
                    Icons.navigate_next,
                    color: colorItem,
                  )
                ],
              ),
              Gap(20.o),
              !isLast
                  ? Container(
                      width: double.infinity,
                      height: 1.o,
                      color: Colors.grey.withOpacity(0.3),
                    )
                  : Container(),
            ],
          ),
        ));
  }

  Widget _buildNightMode(ThemeNotifier notifier, String titleItem, String icon,
      Color colorItem, ThemeData mTheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.o, vertical: 16.o),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Gap(10.o),
              SvgPicture.asset(
                width: 24.o,
                height: 24.o,
                icon,
                color: mTheme.colorScheme.primary,
              ),
              Gap(10.o),
              Expanded(
                child: Text(
                  titleItem,
                  style: theme.primaryTextStyle.copyWith(
                      color: mTheme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.o),
                ),
              ),
              DropdownButton(
                value: themeNotifier.currentTheme,
                items: modeListKey
                    .map((mode) => DropdownMenuItem(

                          value: mode,
                          child: Text(
                            mode.tr,
                            style: theme.primaryTextStyle
                                .copyWith(fontSize: 14.o,color: mTheme.colorScheme.primary),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    themeNotifier.changeTheme(value ?? 'system');
                    // _regionController.text = selectedMode;
                  });
                },
              ),
            ],
          ),
          Gap(15.o),
          Container(
            width: double.infinity,
            height: 1.o,
            color: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
