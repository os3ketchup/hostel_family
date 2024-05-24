import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/network/http_result.dart';
import 'package:hostels/ui/custom/custom_appbar.dart';
import 'package:hostels/ui/custom/custom_button.dart';
import 'package:hostels/ui/login/login.dart';
import 'package:hostels/ui/register/date_textfield.dart';
import 'package:hostels/ui/register/dialog/picker_dialog.dart';
import 'package:hostels/ui/register/name_textfield.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:intl/intl.dart';
import '../../network/client.dart';
import '../../variables/language.dart';
import 'package:gap/gap.dart';

import '../../variables/links.dart';
import '../fundamental/fundamental_screen.dart';
import '../../providers/user_provider.dart';

enum SingingCharacter { male, female }

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.phone, required this.code});

  final String phone;
  final String code;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var enableName = false;
  var enableSecondName = false;
  var enable1password = false;
  var enable2password = false;
  var enableDate = false;
  String birthDay = '';

  bool isLoading = false,
      nameError = false,
      surnameError = false,
      isMan = true,
      dateError = false,
      isNext = false;
  String bornDay = '';
  TextEditingController firstName = TextEditingController(text: '');
  TextEditingController lastName = TextEditingController(text: '');

  String selectedOption = '20';

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: RegisterAppbar()),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 14.o),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Gap(50.o),
                NameTextField(
                  controller: firstName,
                  onChanged: (value) {
                    setState(() {
                      if (value.isNotEmpty && value.length > 2) {
                        enableName = true;
                      } else {
                        enableName = false;
                      }
                    });
                  },
                  firstName: enterFirstName.tr,
                ),
                Gap(20.o),
                NameTextField(
                  controller: lastName,
                  onChanged: (value) {
                    setState(() {
                      if (value.isNotEmpty && value.length > 2) {
                        enableSecondName = true;
                      } else {
                        enableSecondName = false;
                      }
                    });
                  },
                  firstName: enterSecondName.tr,
                ),
                Gap(20.o),
                // DateTextField(
                //   date: myBirthDay.tr,
                //   onIconTapped: () {
                //     {
                //       showModalBottomSheet<void>(
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(30.h),
                //         ),
                //         isScrollControlled: true,
                //         backgroundColor: Colors.white,
                //         context: context,
                //         builder: (BuildContext context) {
                //           return PickerDialog(
                //             title: birthDay.tr,
                //             selected: (year, mounth, day) {
                //               setState(() {
                //                 birthDay = [
                //                   day.toString().padLeft(2, '0'),
                //                   mounth.toString().padLeft(2, '0'),
                //                   year,
                //                 ].join('.');
                //                 checkIs(false);
                //                 setState(() {
                //                   if (birthDay.isNotEmpty) {
                //                     print(birthDay.isNotEmpty);
                //                     enableDate = true;
                //                   } else {
                //                     enableDate = false;
                //                   }
                //                 });
                //               });
                //             },
                //             initialDate:
                //                 DateFormat('dd.MM.yyyy').format(DateTime.now()),
                //           );
                //         },
                //       );
                //     }
                //   },
                //   birthDay: birthDay,
                //   onTextFieldTapped: () {
                //     showModalBottomSheet<void>(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(30.h),
                //       ),
                //       isScrollControlled: true,
                //       backgroundColor: Colors.white,
                //       context: context,
                //       builder: (BuildContext context) {
                //         return PickerDialog(
                //           title: 'select',
                //           selected: (year, mounth, day) {
                //             setState(() {
                //               birthDay = [
                //                 day.toString().padLeft(2, '0'),
                //                 mounth.toString().padLeft(2, '0'),
                //                 year,
                //               ].join('.');
                //               checkIs(false);
                //               setState(() {
                //                 if (birthDay.isNotEmpty) {
                //                   print(birthDay.isNotEmpty);
                //                   enableDate = true;
                //                 } else {
                //                   enableDate = false;
                //                 }
                //               });
                //             });
                //           },
                //           initialDate:
                //               DateFormat('dd.MM.yyyy').format(DateTime.now()),
                //         );
                //       },
                //     );
                //   },
                // ),
                // Gap(20.o),
                // PasswordTextField(
                //   onChanged: (value) {
                //     setState(() {
                //       print(value.isNotEmpty);
                //       if (value.isNotEmpty) {
                //         enable1password = true;
                //       } else {
                //         enable1password = false;
                //       }
                //     });
                //   },
                //   title: password.tr,
                // ),
                // Gap(20.o),
                // PasswordTextField(
                //   title: repeatPassword.tr,
                //   onChanged: (String value) {
                //     setState(() {
                //       if (value.isNotEmpty) {
                //         enable2password = true;
                //       } else {
                //         enable2password = false;
                //       }
                //     });
                //   },
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: () {
                //           setState(() {
                //             selectedOption = '20';
                //           });
                //         },
                //         child: Container(
                //           margin: EdgeInsets.only(right: 12.o),
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(12.o),
                //             color: mTheme.colorScheme.onSurfaceVariant,
                //           ),
                //           child: ListTile(
                //             title: Text(
                //               male.tr,
                //               style: theme.primaryTextStyle.copyWith(
                //                   color: mTheme.textTheme.bodyMedium!.color,
                //                   fontSize: 12.o),
                //             ),
                //             leading: Radio<String>(
                //               activeColor: mTheme.colorScheme.primary,
                //               value: '20',
                //               groupValue: selectedOption,
                //               onChanged: (value) {
                //                 setState(() {
                //                   selectedOption = value!;
                //                 });
                //               },
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: () {
                //           setState(() {
                //             selectedOption = '30';
                //           });
                //         },
                //         child: Container(
                //           margin: EdgeInsets.only(left: 12.o),
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(12.o),
                //             color: mTheme.colorScheme.onSurfaceVariant,
                //           ),
                //           child: ListTile(
                //             title: Text(female.tr,
                //                 style: theme.primaryTextStyle.copyWith(
                //                     color: mTheme.textTheme.bodyMedium!.color,
                //                     fontSize: 12.o)),
                //             leading: Radio<String>(
                //               activeColor: mTheme.colorScheme.primary,
                //               value: '30',
                //               groupValue: selectedOption,
                //               onChanged: (value) {
                //                 setState(() {
                //                   selectedOption = value!;
                //                 });
                //               },
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Expanded(
                //       child: Container(
                //         margin: EdgeInsets.only(right: 12.o),
                //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.o),
                //             color: mTheme.colorScheme.primary.withOpacity(0.2)),
                //         child: ListTile(
                //           title: Text(
                //             'Erkak',
                //             style: theme.primaryTextStyle.copyWith(
                //                 color: mTheme.textTheme.bodyMedium!.color),
                //           ),
                //           leading: Radio<String>(
                //             activeColor: mTheme.colorScheme.primary,
                //             value: '20',
                //             groupValue: selectedOption,
                //             onChanged: (value) {
                //               setState(() {
                //                 selectedOption = value!;
                //               });
                //             },
                //           ),
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       child: Container(
                //         margin: EdgeInsets.only(left: 12.o),
                //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.o),
                //             color: mTheme.colorScheme.primary.withOpacity(0.2)),
                //         child: ListTile(
                //           title: const Text('Ayol'),
                //           leading: Radio<String>(
                //             activeColor: mTheme.colorScheme.primary,
                //             value: '30',
                //             groupValue: selectedOption,
                //             onChanged: (value) {
                //               setState(() {
                //                 selectedOption = value!;
                //               });
                //             },
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                Gap(100.o),
                Text(
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  agreement.tr,
                  style: theme.primaryTextStyle
                      .copyWith(color: mTheme.colorScheme.primary),
                ),
                Gap(10.o),

            CustomButton(
                title: isLoading
                    ? SizedBox(
                  height: 24.o,
                  width: 24.o,
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: mTheme.colorScheme.onPrimary,
                  ),
                )
                    : Text(
                  textAlign: TextAlign.center,
                  proceed.tr,
                  style: theme.primaryTextStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: enableName
                    ? () {
                  sendData();
                }
                    : null),
                Gap(20.o),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool checkIs(bool isToast) {
    dateError = bornDay.isEmpty;
    isNext = true;
    if (isToast) {
      if (nameError) {
        isNext = false;
        // toast(context: context, txt: "enter name");
        return false;
      } else if (surnameError) {
        isNext = false;
        // toast(context: context, txt: 'enterSurname'.tr);
        return false;
      } else if (dateError) {
        isNext = false;
        // toast(context: context, txt: bornDate.tr);
        return false;
      }
    }
    setState(() {});
    return true;
  }

  void sendData() async {
    setState(() {
      isLoading = false;
    });
    final firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission();
    String sfCMToken = '';
    if (Platform.isIOS) {
      sfCMToken = await firebaseMessaging.getAPNSToken() ?? '';
    }
    String fCMToken = '';
    if (sfCMToken.isEmpty || Platform.isAndroid) {
      fCMToken = await firebaseMessaging.getToken() ?? '';
    }
    print("$fCMToken ######### it is token");
    print("$sfCMToken ######### it is tokenee");
    String signature =
        await enterNotifier.smartAuth.getAppSignature() ?? 'dxyHiaolzwv';
    MainModel result = await client.post(Links.sendVerify, data: {
      'phone': widget.phone,
      'code': widget.code,
      'firebase_token': fCMToken,
    });

    await client.post(Links.signUp, data: {
      'first_name': firstName.text,
      'last_name': lastName.text,
      'born_date': birthDay,
      'gender': selectedOption,
      'phone': widget.phone,
      'code': widget.code,
      'firebase_token': fCMToken,
    }).then(
      (result) {
        if (result.status == 200) {
          setState(() {
            isLoading = true;
          });
          pref.setString(PrefKeys.name, firstName.text);
          pref.setString(PrefKeys.surname, lastName.text);
          pref.setString(PrefKeys.born, birthDay);
          pref.setString(PrefKeys.gender, isMan ? '20' : '30');
          pref.setString(PrefKeys.token, result.data['auth_key']).toString();
          userCounter.appUser = AppUser(
            firstName: firstName.text,
            lastName: lastName.text,
            gender: selectedOption == '20' ? '20' : '30',
            bornDate: birthDay ?? '',
            authKey: result.data['auth_key'].toString(),
            phone: widget.phone.toString(),
            status: result.data['status'].toString(),
            id: result.data['id'].toString(),
            genderName: result.data['gender_name'].toString(),
            img: result.data['img'].toString(),
          );

          userCounter.update();
          print('rrrr $fCMToken');
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const FundamentalScreen(),
              ));
        }
      },
    );
  }

}



