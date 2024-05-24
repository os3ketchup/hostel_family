import 'package:flutter/material.dart';
import 'package:hostels/variables/util_variables.dart';

import '../../apptheme.dart';
import 'package:flutter_svg/svg.dart';

import '../../variables/icons.dart';
import 'package:gap/gap.dart';

class NearTitleWidget extends StatefulWidget {
  const NearTitleWidget({super.key});

  @override
  State<NearTitleWidget> createState() => _NearTitleWidgetState();
}

class _NearTitleWidgetState extends State<NearTitleWidget> {
  @override
  Widget build(BuildContext context) {
    return             Container(
      margin: EdgeInsets.symmetric(horizontal: 12.o),
      child: Row(
        children: [
          SvgPicture.asset(SVGIcons.nearMe),
          Gap(10.o),
          Text(
            'Yaqin-atrof',
            style: theme.primaryTextStyle.copyWith(
                color: theme.primaryColor, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 8.o),
                  child: Text(
                    'Joylashuv',
                    style: theme.hintTextFieldStyle
                        .copyWith(fontSize: 12.o),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Toshkent, Yunusobod',
                      style: theme.primaryTextStyle.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.o),
                    ),
                    const Icon(Icons.expand_more_sharp),
                  ],
                )
              ],
            ),
          ),
          Gap(10.o),
          Container(
              padding: EdgeInsets.all(8.o),
              decoration: BoxDecoration(
                color: theme.backgroundGrey,
                borderRadius: BorderRadius.all(Radius.circular(8.o),),),
              child: SvgPicture.asset(SVGIcons.myLocation))
        ],
      ),
    );
  }
}
