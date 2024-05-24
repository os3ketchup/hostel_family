import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hostels/variables/icons.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';

import '../../apptheme.dart';

class HomeBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int)
      onIndexChanged; // Callback function to pass the selected index

  const HomeBottomNavBar({
    required this.selectedIndex,
    required this.onIndexChanged,
    super.key,
  });

  @override
  _HomeBottomNavBarState createState() => _HomeBottomNavBarState();
}

class _HomeBottomNavBarState extends State<HomeBottomNavBar>
    {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return PreferredSize(
      preferredSize: Size.fromHeight(0.o),
      child: Container(
        height: 81.o,
        decoration: BoxDecoration(
          color: ThemeMode.dark == ThemeMode.light?Colors.white:mTheme.scaffoldBackgroundColor, // Background color of the "card"
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1.o), // Shadow color
              spreadRadius: 14,
              blurRadius: 13,
              offset: Offset(0.o, -0.3.o), // Shadow position
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavItem(SVGIcons.home, basic.tr, 0,mTheme),
            buildNavItem(SVGIcons.travel, travel.tr, 1,mTheme),
            buildNavItem(SVGIcons.favorite, favorite.tr, 2,mTheme),
            buildNavItem(SVGIcons.profileBottom, profile.tr, 3,mTheme),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem(String icon, String label, int index,ThemeData mThemeData) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.onIndexChanged(index);
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Container(
          //   height: 4.0.o,
          //   width: 47.0.o,
          //   decoration: BoxDecoration(
          //     color: widget.selectedIndex == index
          //         ? Colors.blue
          //         : Colors.transparent,
          //     borderRadius: BorderRadius.only(
          //       bottomLeft: Radius.circular(5.o),
          //       bottomRight: Radius.circular(5.o),
          //     ),
          //   ),
          // ),
          Gap(4.o),
          SvgPicture.asset(
            icon,
            color: widget.selectedIndex == index
                ? mThemeData.colorScheme.primary
                : Colors.grey,
          ),
          Gap(
            4.o,
            color: theme.primaryColor,
          ),
          Text(
            label,
            style: theme.primaryTextStyle.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12.0.o,
              color: widget.selectedIndex == index
                  ? mThemeData.colorScheme.primary
                  : Colors.grey,
            ),
          ),
          Gap(20.o)
        ],
      ),
    );
  }
}
