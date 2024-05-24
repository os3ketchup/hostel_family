import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hostels/variables/util_variables.dart';

import '../../apptheme.dart';

class ProfileAppbar extends StatelessWidget {
  const ProfileAppbar({super.key, required this.titleAppbar, required this.color});

  final String titleAppbar;
  final Color color;

  @override
  Widget build(BuildContext context) {

    ThemeData mTheme = Theme.of(context);
    return Column(
      children: [
        Gap(40.o),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.o,
                            color: color),
                        borderRadius: BorderRadius.all(Radius.circular(18.o))),
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.o, vertical: 6.o),
                    child: Icon(
                      Icons.arrow_back,
                      color: mTheme.colorScheme.primary,
                    ))),
            Gap(20.o),
            Text(
              titleAppbar,
              style: theme.primaryTextStyle.copyWith(
                  color: mTheme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.o),
            ),
          ],
        ),
      ],
    );
  }
}
