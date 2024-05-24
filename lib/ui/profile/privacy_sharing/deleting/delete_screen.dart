import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/network/client.dart';
import 'package:hostels/providers/user_provider.dart';
import 'package:hostels/ui/custom/profile_appbar.dart';
import 'package:hostels/ui/login/login.dart';
import 'package:hostels/variables/icons.dart';
import 'package:hostels/variables/images.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/links.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/svg.dart';

class DeletingScreen extends StatefulWidget {
  const DeletingScreen({super.key});

  @override
  State<DeletingScreen> createState() => _DeletingScreenState();
}

class _DeletingScreenState extends State<DeletingScreen> {
  String _selectedRegion = regions().first;
  List<String> regionList = regions();
  final _regionController = TextEditingController();
  final _contentController = TextEditingController();
  bool isContentEmpty = true;

  @override
  void initState() {
    _regionController.text = _selectedRegion;
    super.initState();
  }

  @override
  void dispose() {
    _regionController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.o),
        child: ProfileAppbar(
          titleAppbar: deleteAccount.tr,
          color: mTheme.colorScheme.background,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 20.o),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12.o),
              child: Text(
                maxLines: 3,
                confirmationToConnect.tr,
                style: theme.hintTextFieldStyle
                    .copyWith(color: mTheme.colorScheme.secondary),
              ),
            ),
            Gap(10.o),
            Stack(
              children: [
                Container(
                  height: 65.o,
                  margin: EdgeInsets.symmetric(vertical: 8.o, horizontal: 12.o),
                  padding: EdgeInsets.symmetric(horizontal: 16.o),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: mTheme.colorScheme.primary.withOpacity(0.5)),
                    borderRadius: BorderRadius.all(Radius.circular(16.o)),
                    color: mTheme.colorScheme.onSecondary,
                  ),
                  child: TextField(
                      controller: _regionController,
                      readOnly: true,
                      onChanged: (value) {},
                      keyboardType: TextInputType.phone,
                      style: theme.primaryTextStyle
                          .copyWith(color: mTheme.textTheme.bodyMedium!.color),
                      cursorColor: theme.primaryColor,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelStyle: theme.hintTextFieldStyle
                              .copyWith(color: mTheme.colorScheme.secondary),
                          labelText: livingPlace.tr)),
                ),
                Positioned.fill(
                  child: Container(
                    margin: EdgeInsets.all(24.o),
                    child: DropdownButton(
                      dropdownColor: mTheme.colorScheme.onSecondary,
                      borderRadius: BorderRadius.all(Radius.circular(16.o)),
                      // alignment: Alignment.centerRight,
                      icon: SvgPicture.asset(
                        SVGIcons.downCaret,
                        width: 8.o,
                        height: 8.o,
                        color: mTheme.colorScheme.primary,
                      ),
                      // ,
                      isExpanded: true,
                      underline: Container(),
                      menuMaxHeight: 200.h,
                      items: regionList
                          .map((region) => DropdownMenuItem(
                              value: region,
                              child: Text(
                                region,
                                style: theme.primaryTextStyle.copyWith(
                                    color: mTheme.textTheme.bodyMedium!.color),
                              )))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          if (value == null) {
                            return;
                          }
                          _selectedRegion = value;
                          _regionController.text = _selectedRegion;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
            Gap(20.o),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 14.o),
                child: Text(
                  reasonOfDeleting.tr,
                  style: theme.primaryTextStyle.copyWith(
                      fontSize: 16.o,
                      fontWeight: FontWeight.w700,
                      color: mTheme.colorScheme.primary),
                )),
            Gap(10.o),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.o, horizontal: 12.o),
              padding: EdgeInsets.symmetric(horizontal: 16.o, vertical: 8.o),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: mTheme.colorScheme.primary.withOpacity(0.5)),
                  borderRadius: BorderRadius.all(Radius.circular(16.o)),
                  color: mTheme.colorScheme.onSecondary),
              child: TextField(
                  controller: _contentController,
                  minLines: 5,
                  maxLines: 5,
                  maxLength: 150,
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        isContentEmpty = true;
                      } else {
                        isContentEmpty = false;
                      }
                    });
                  },
                  keyboardType: TextInputType.text,
                  style: theme.primaryTextStyle
                      .copyWith(color: mTheme.textTheme.bodyMedium!.color),
                  cursorColor: theme.primaryColor,
                  decoration: InputDecoration(
                    counterStyle: theme.primaryTextStyle
                        .copyWith(color: mTheme.textTheme.bodyMedium!.color),
                    // contentPadding: EdgeInsets.only(bottom: 100.o),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  )),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12.o),
              child: TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.red.withOpacity(0.1),
                      side: BorderSide(
                          width: 1.o,
                          color: mTheme.colorScheme.primary.withOpacity(0.5))),
                  onPressed: !isContentEmpty
                      ? () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: mTheme.colorScheme.background,
                                child: Container(
                                  padding: EdgeInsets.all(22.o),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(right: 6.o),
                                                width: 50.o,
                                                height: 50.o,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50.o)),
                                                    child: userCounter.appUser!
                                                            .img.isNotEmpty
                                                        ? Image.network(
                                                            userCounter
                                                                .appUser!.img,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.asset(
                                                            IMAGES.person,
                                                            fit: BoxFit.cover,
                                                          ))),
                                            Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 60.o),
                                                  child: Icon(
                                                    Icons.error,
                                                    color:
                                                        mTheme.colorScheme.error,
                                                  ),
                                                ))
                                          ],
                                        ),
                                        Gap(20.o),
                                        Text(
                                          deleteYourAccount.tr,
                                          style: theme.primaryTextStyle.copyWith(
                                              fontSize: 14.o,
                                              color: mTheme
                                                  .textTheme.bodyLarge!.color,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Gap(5.o),
                                        Text(
                                            textAlign: TextAlign.center,
                                            maxLines: 3,
                                            youWillLoseYourData.tr,
                                            style: theme.primaryTextStyle
                                                .copyWith(
                                                    color: mTheme.textTheme
                                                        .bodyLarge!.color)),
                                        Gap(40.o),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8.o)),
                                              backgroundColor:
                                                  mTheme.colorScheme.primary),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            changedMyMind.tr,
                                            style: theme.primaryTextStyle
                                                .copyWith(
                                                    color: mTheme
                                                        .colorScheme.background),
                                          ),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.o))),
                                          onPressed: () async {
                                            client.post(Links.deleteAccount).then((value) {
                                              if(value.status==200){
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
                                              }
                                            });
                                    
                                    
                                          },
                                          child: Text(
                                            deleteMyAccount.tr,
                                            style: theme.primaryTextStyle
                                                .copyWith(
                                                    color:
                                                        mTheme.colorScheme.error),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                          _contentController.clear();
                          setState(() {
                            isContentEmpty = true;
                          });
                        }
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete,
                        color: !isContentEmpty ? Colors.red : Colors.grey,
                      ),
                      Gap(10.o),
                      Text(
                        deleteAccount.tr,
                        style: theme.primaryTextStyle.copyWith(
                            color: !isContentEmpty ? Colors.red : Colors.grey),
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
