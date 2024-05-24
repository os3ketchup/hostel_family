import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/variables/language.dart';
import 'package:gap/gap.dart';
import 'package:hostels/variables/util_variables.dart';
import '../../variables/icons.dart';
import 'pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phoneNumber});

  final String phoneNumber;



  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String maskCharacters(String text, int start, int end, String maskChar) {
    if (start < 0 || end > text.length || start >= end) {
      return text;
    }

    String maskedPart = List.filled(end - start, maskChar).join();
    return '${text.substring(0, start)}$maskedPart${text.substring(end)}';
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    String maskedText =
        maskCharacters("+998${widget.phoneNumber} ${codeSent.tr}", 6, 13, '*');
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(SVGIcons.otpPhone),
              Text(
                maskedText,
                style: theme.primaryTextStyle.copyWith(color: mTheme.textTheme.bodyMedium!.color),
              ),
              Gap(20.o),
               RegisterPinPut(phoneNumber: '+998${widget.phoneNumber}',),
            ],
          ),
        ),
      ),
    );
  }


}
