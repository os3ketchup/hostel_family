import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:hostels/widgets/Toast.dart';
import 'package:pinput/pinput.dart';
import 'package:gap/gap.dart';
import 'package:hostels/ui/login/phone_textfield.dart';
import 'package:hostels/ui/otp/otp.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../../apptheme.dart';
import '../../network/client.dart';
import '../../network/http_result.dart';
import '../../variables/icons.dart';
import '../../variables/language.dart';
import '../../variables/links.dart';
import '../custom/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: mTheme.colorScheme.background,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.o),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(SVGIcons.enterPhone),
                Gap(20.o),
                Text(
                  enter.tr,
                  style: theme.primaryTextStyle
                      .copyWith(color: mTheme.textTheme.bodyMedium!.color)
                      .copyWith(fontSize: 24.o, fontWeight: FontWeight.w700),
                ),
                Gap(20.o),
                Text(
                  findBestPlace.tr,
                  style: theme.hintTextFieldStyle
                      .copyWith(color: mTheme.colorScheme.secondary),
                ),
                Gap(30.o),
                PhoneTextField(
                  onChanged: (value) {
                    setState(() {
                      phoneNumber = value;
                    });
                  },
                ),
                Gap(20.o),
                Consumer(
                  builder: (context, ref, child) {
                    final notifier = ref.watch(enterProvider);
                    double opacity = notifier.getOpacity();
                    return CustomButton(
                      title: notifier.isLoading ? SizedBox(
                        height: 24.o,
                        width: 24.o,
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: mTheme.colorScheme.onPrimary,
                        ),
                      )
                          : Text(
                        textAlign: TextAlign.center,
                        enter.tr,
                        style: theme.primaryTextStyle
                            .copyWith(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      onPressed: phoneNumber.isEmpty
                          ? null
                          : () {
                        print(phoneNumber);
                        notifier
                            .sendPhone('+998$phoneNumber')
                            .then((value) {
                          if (value != null) {
                            if (value.status == 200) {
                              try {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OtpScreen(
                                            phoneNumber: phoneNumber,
                                          ),
                                    ));
                              } catch (e) {
                                print(e);
                              }
                              if (value.data?['message'] is String) {
                                // toast(
                                //     context: context,
                                //     txt: value.data?['message']);
                                awesomeToast(context: context,
                                    txt: '+998$phoneNumber ${sentSms.tr}!',
                                    title: sms.tr,
                                    contentType: ContentType.warning);
                              } else {
                                if (value.error != null &&
                                    value.error!.isNotEmpty) {
                                  toast(
                                      context: context,
                                      txt: value.error!.values.first
                                          .toString());
                                }
                              }
                            } else if (value.status == 403) {
                                awesomeToast(context: context, txt: numberWrongEntered.tr, title: error.tr, contentType: ContentType.failure);
                            }
                            return;
                          }
                          toast(
                              context: context,
                              txt: defaultModel.error!.values.first
                                  .toString());
                        });
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final enterProvider = ChangeNotifierProvider<EnterNotifier>((ref) {
  return enterNotifier;
});

EnterNotifier? _enterNotifier;

EnterNotifier get enterNotifier {
  _enterNotifier ??= EnterNotifier();
  return _enterNotifier!;
}

class EnterNotifier with ChangeNotifier {
  late SmartAuth smartAuth;

  EnterNotifier() {
    smartAuth = SmartAuth();
  }

  bool isLoading = false,
      canNext = false;

  @override
  void dispose() {
    smartAuth.removeSmsListener();
    super.dispose();
  }

  Future<MainModel?> sendPhone(String number) async {
    isLoading = true;
    update();
    String signature = 'dxyHiaolzwv';
    try {
      signature = await smartAuth.getAppSignature() ?? 'dxyHiaolzwv';
    } catch (e) {
      print("Unknown exception: $e");
    }
    MainModel result = await client
        .post(Links.sendPhone, data: {'phone': number, 'signature': signature});
    isLoading = false;
    update();
    return result;
  }

  double getOpacity() => canNext && !isLoading ? 1 : 0.2;

  void update() {
    notifyListeners();
  }
}
