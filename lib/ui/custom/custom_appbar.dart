import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/variables/icons.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';

class RegisterAppbar extends StatelessWidget {
  const RegisterAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Container(
      alignment: Alignment.bottomLeft,
      height: 100.o,
      width: double.infinity,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Container(padding: EdgeInsets.all(4.o),decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6.o)),border: Border.all(width: 1,color: mTheme.colorScheme.primary)),child: SvgPicture.asset(SVGIcons.arrowBack,color: mTheme.colorScheme.primary,)),
          ),
          Gap(20.o),
          Text(fillProfile.tr,style: theme.primaryTextStyle.copyWith(fontSize: 18,color: mTheme.colorScheme.primary,fontWeight: FontWeight.w600),),
        ],
      ),
    );
  }
}
