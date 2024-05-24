import 'package:flutter/material.dart';
import 'package:hostels/providers/hotels_provider.dart';
import 'package:hostels/variables/util_variables.dart';

import '../../apptheme.dart';

class ClickedCategoryItem extends StatefulWidget {
  const ClickedCategoryItem(
      {super.key, required this.index, required this.category});

  final int index;
  final Category category;

  @override
  State<ClickedCategoryItem> createState() => _ClickedCategoryItemState();
}

class _ClickedCategoryItemState extends State<ClickedCategoryItem> {
  int _clickedIndex = 0;

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    setState(() {
      _clickedIndex = widget.index;
    });
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 4.o, vertical: 4.o),
      decoration: BoxDecoration(
          color: mTheme.colorScheme.primary,
          borderRadius: BorderRadius.all(Radius.circular(20.o))),
      padding: EdgeInsets.symmetric(horizontal: 12.o, vertical: 4.o),
      child: Text(
        widget.category.name,
        textAlign: TextAlign.center,
        style: theme.primaryTextStyle.copyWith(color: Colors.white),
      ),
    );
  }
}
