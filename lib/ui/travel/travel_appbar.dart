import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';

class TravelAppbar extends StatelessWidget {
  const TravelAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Container(
      color: mTheme.colorScheme.onPrimary,
      padding: EdgeInsets.symmetric(horizontal: 12.o),
      height: 110.o,
      child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.min,
        children: [
         Platform.isIOS?Gap(60.o): Gap(60.o),
          Text(
            myOrders.tr,
            style: theme.primaryTextStyle.copyWith(
                fontSize: 18.o,
                fontWeight: FontWeight.w700,
                color: mTheme.colorScheme.primary),
          )
        ],
      ),
    );
  }
}
