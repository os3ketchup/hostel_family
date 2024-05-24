import 'package:flutter/material.dart';
import 'package:hostels/variables/util_variables.dart';

import '../../apptheme.dart';
import '../../variables/language.dart';

class ChooseAllWidget extends StatelessWidget {
const ChooseAllWidget({super.key, required this.title, required this.onTap});

final String title;
final Function() onTap;
  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(left: 12.o),
      child: Row(
        children: [
          Text(
            title,
            style: theme.primaryTextStyle.copyWith(
                color: mTheme.colorScheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 14.o),
          ),
          const Spacer(),
          InkWell(
              borderRadius: BorderRadius.all(Radius.circular(12.o)),
              onTap:onTap,
              child: Container(
                  padding: EdgeInsets.only(
                      right: 4.o, top: 4.o, left: 8.o, bottom: 4.o),
                  child: Row(
                    children: [
                      Text(
                        all.tr,
                        style: theme.primaryTextStyle.copyWith(color: ThemeMode.dark == ThemeMode.light
                            ?theme.primaryTextStyle.color:mTheme.colorScheme.surface,fontSize: 14.o),
                      ),
                       Icon(Icons.chevron_right,color: mTheme.colorScheme.surface,)
                    ],
                  )))
        ],
      ),
    );
  }
}
