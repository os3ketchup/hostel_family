import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hostels/network/notification.dart';
import 'package:hostels/ui/fundamental/fundamental_screen.dart';
import 'package:hostels/ui/home/home_screen.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../apptheme.dart';
import '../../network/client.dart';
import '../../network/http_result.dart';
import '../../variables/links.dart';
import '../../widgets/Toast.dart';
import '../login/login.dart';
import '../../providers/user_provider.dart';
import '../register/register.dart';


class RegisterPinPut extends StatefulWidget {
  const RegisterPinPut({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<RegisterPinPut> createState() => _RegisterPinPutState();
}

bool isNext = false, isLoading = false, isError = false;

class _RegisterPinPutState extends State<RegisterPinPut> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  int _counter = 120; // Initial counter value in seconds
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
    _notificationFirebase();
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    Color focusedBorderColor = const Color(0xff00AE30);
    Color errorBorderColor = mTheme.colorScheme.error;
    const fillColor = Color.fromRGBO(243, 246, 249, 0);

    final defaultPinTheme = PinTheme(
      width: 56.o,
      height: 56.o,
      textStyle: theme.primaryTextStyle.copyWith(
          fontSize: 18.o,
          fontWeight: FontWeight.w400,
          color: focusedBorderColor),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19.o),
        border: Border.all(color: Colors.grey),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      borderRadius: BorderRadius.circular(9.h),
      border: Border.all(
        color: isError == true
            ? mTheme.colorScheme.error
            : mTheme.colorScheme.onPrimary,
      ),
      color: Colors.white,
    );

    /// Optionally you can use form to validate the Pinput
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Directionality(
            // Specify direction if desired
            textDirection: TextDirection.ltr,
            child: Pinput(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              keyboardType: TextInputType.number,
              length: 5,
              controller: pinController,
              focusNode: focusNode,
              androidSmsAutofillMethod:
                  AndroidSmsAutofillMethod.smsUserConsentApi,
              listenForMultipleSmsOnAndroid: true,
              defaultPinTheme: defaultPinTheme,
              separatorBuilder: (index) => SizedBox(width: 8.o),
              validator: (value) {
                setState(() {
                  isNext = value != null ? value.length == 5 : false;
                });
                _sendSMS(value.toString());

                return null;
              },
              // onChanged: (value) {
              //   debugPrint('onChanged: $value');
              //   if (value.length == 5) {
              //     _sendSMS(value);
              //   }
              // },
              // onCompleted: (value) {
              //   print('onComplete: $value');
              //   setState(() {
              //     if (value == '77777') {
              //       Navigator.push(context, MaterialPageRoute(
              //         builder: (context) {
              //           return RegisterScreen(
              //             phone: widget.phoneNumber,
              //             code: value,
              //           );
              //         },
              //       ));
              //     }
              //   });
              // },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 9.o),
                    width: 22.o,
                    height: 1.o,
                    color: focusedBorderColor,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                textStyle: theme.primaryTextStyle
                    .copyWith(color: mTheme.textTheme.bodyMedium!.color),
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(8.o),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                textStyle: theme.primaryTextStyle
                    .copyWith(color: mTheme.textTheme.bodyMedium!.color),
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(19.o),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
          TextButton(
            onPressed: _counter > 0
                ? null
                : () {
                    focusNode.unfocus();
                    formKey.currentState!.validate();
                    startTimer();
                    sendPhone();
                  },
            child: _counter > 0
                ? Text(
                    getFormattedTime(),
                    style: theme.primaryTextStyle
                        .copyWith(color: mTheme.textTheme.bodyMedium!.color),
                  )
                : Text(
                    resent.tr,
                    style: theme.primaryTextStyle.copyWith(
                        fontSize: 16.o,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue),
                  ),
          ),
        ],
      ),
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          timer.cancel(); // Stop the timer when countdown reaches 0
        }
      });
    });
  }

  String getFormattedTime() {
    int minutes = _counter ~/ 60;
    int seconds = _counter % 60;
    String minutesStr = (minutes < 10) ? '0$minutes' : '$minutes';
    String secondsStr = (seconds < 10) ? '0$seconds' : '$seconds';
    return '$minutesStr:$secondsStr';
  }

  void _sendSMS(String pinCode) async {
    print('is worksssssss');
    print('pincode : $pinCode');

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
    String signature = await enterNotifier.smartAuth.getAppSignature() ?? 'dxyHiaolzwv';
    MainModel result = await client.post(Links.sendVerify, data: {
      'phone': widget.phoneNumber,
      'code': pinCode,
      'firebase_token': fCMToken,
    });

    if (result.status == 200) {
      setState(() {
        isError = false;
      });
        print('veriify token $fCMToken');
      if (result.data!['first_name'] is String &&
          '${result.data!['first_name']}'.isNotEmpty) {
        print('data worksss');
        AppUser appUser = AppUser.fromJson(result.data);
        pref.setString(PrefKeys.name, appUser.firstName);
        pref.setString(PrefKeys.surname, appUser.lastName);
        pref.setString(PrefKeys.born, appUser.bornDate);
        pref.setString(PrefKeys.gender, appUser.gender);
        pref.setString(PrefKeys.genderName, appUser.genderName);
        pref.setString(PrefKeys.userId, appUser.id);
        pref.setString(PrefKeys.status, appUser.status);
        pref.setString(PrefKeys.phoneNumber, appUser.phone);
        pref.setString(PrefKeys.token, appUser.authKey);

        // userCounter.appUser = appUser;
        navigate();
      } else {
        print('is not wokrs');
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return RegisterScreen(phone: widget.phoneNumber, code: pinCode);
          },
        ));
      }
    } else {
      if (result.status == 403) {
        print('status code xato');
        awesomeToast(
            context: context,
            txt: 'Tasdiqlash kodi xato kiritildi!',
            title: 'Xatolik',
            contentType: ContentType.failure);
        setState(() {
          isError = true;
        });
      }
      // if (result.error != null && result.error!.values.isNotEmpty) {
      //   print('${result.error}');
      // }
    }
  }

  void sendPhone() async {
    String signature =
        await enterNotifier.smartAuth.getAppSignature() ?? 'dxyHiaolzwv';
    MainModel result = await client.post(Links.sendPhone,
        data: {'phone': widget.phoneNumber, 'signature': signature});
    if (result.status == 200) {
      _counter = 120;
      startTimer();
    } else {
      if (result.error != null && result.error.values.isNotEmpty) {
        print(result.error!.values.first.toString());
      }
    }
  }

  void navigate() {
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const FundamentalScreen();
        },
      ),
    );
  }

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
}
