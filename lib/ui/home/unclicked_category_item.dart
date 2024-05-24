
import 'package:flutter/material.dart';
import 'package:hostels/providers/hotels_provider.dart';
import 'package:hostels/variables/util_variables.dart';

import '../../apptheme.dart';

class UnClickedCategoryItem extends StatefulWidget {
  const UnClickedCategoryItem({super.key, required this.index, required this.category});
final int index;
final Category category;
  @override
  State<UnClickedCategoryItem> createState() => _UnClickedCategoryItemState();
}

class _UnClickedCategoryItemState extends State<UnClickedCategoryItem> {
  int _clickedIndex = 0;
  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    setState(() {
      _clickedIndex = widget.index;
    });
    return Container(
      alignment: Alignment.center,
      margin:
      EdgeInsets.symmetric(horizontal: 4.o, vertical: 4.o),
      decoration: BoxDecoration(
          border: Border.all(width: 1,color: mTheme.colorScheme.secondary),
          color: mTheme.colorScheme.background,
          borderRadius:
          BorderRadius.all(Radius.circular(20.o))),
      padding:
      EdgeInsets.symmetric(horizontal: 12.o, vertical: 4.o),
      child: Text(
        widget.category.name,
        textAlign: TextAlign.center,
        style: theme.primaryTextStyle
            .copyWith(fontWeight: FontWeight.w600,color: mTheme.colorScheme.surface),
      ),
    );
  }
}
