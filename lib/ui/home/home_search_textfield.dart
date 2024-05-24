import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/variables/language.dart';

import '../../variables/util_variables.dart';
import 'package:gap/gap.dart';

class HomeSearchTextField extends StatefulWidget {
  const HomeSearchTextField(
      {super.key, required this.onNavigate, required this.onTap});

  final Function(int selectedPage) onNavigate;
  final VoidCallback onTap;

  @override
  State<HomeSearchTextField> createState() => _HomeSearchTextFieldState();
}

class _HomeSearchTextFieldState extends State<HomeSearchTextField> {
  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1.o, color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(8.o))),
        child: Row(
          children: [
            Gap(10.o),
            Icon(
              Icons.search_rounded,
              color: mTheme.colorScheme.primary,
            ),
            Gap(10.o),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                searchHotel.tr,
                style: theme.primaryTextStyle.copyWith(
                    color: mTheme.colorScheme.surface,
                    fontSize: mTheme.textTheme.titleMedium!.fontSize),
              ),
            )),
            // Container(padding: EdgeInsets.symmetric(vertical: 8.o,horizontal: 8.o),child: SvgPicture.asset(SVGIcons.settings)),
          ],
        ),
      ),
    );
  }
}
