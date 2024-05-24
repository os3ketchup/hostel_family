import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hostels/variables/util_variables.dart';

import '../../../../apptheme.dart';

class OrderAppBar extends StatelessWidget {
  const OrderAppBar(
      {super.key, required this.titleAppbar, required this.onBackPressed});

  final String titleAppbar;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Container(
      color: mTheme.colorScheme.primary,
      height: 100.o,
      child: Column(
        children: [
          Gap(40.o),
          Row(
            children: [
              Gap(20.o),
              IconButton(
                onPressed: onBackPressed,
                icon: Icon(
                  size: 18.o,
                  Icons.arrow_back_ios,
                  color: theme.white,
                ),
              ),
              Gap(20.o),
              Text(
                titleAppbar,
                style: theme.primaryTextStyle.copyWith(
                    fontSize: 18.o,
                    color: theme.white,
                    fontWeight: FontWeight.w600),
              )
            ],
          )
        ],
      ),
    );
  }
}
