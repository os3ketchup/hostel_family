import 'package:flutter/material.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../apptheme.dart';

class ComfortablenessItem extends StatefulWidget {
  const ComfortablenessItem({super.key,required this.title, required this.mTheme, required this.imageUrl });
 final  String title;
 final String imageUrl;
 final ThemeData mTheme;

  @override
  State<ComfortablenessItem> createState() => _ComfortablenessItemState();
}

class _ComfortablenessItemState extends State<ComfortablenessItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.o),
      decoration: BoxDecoration(
          color: widget.mTheme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(8.o))),
      margin: EdgeInsets.symmetric(horizontal: 6.o),
      width: 150.w,
      height: 120.o,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: NetworkImage(widget.imageUrl),
            height: 25.o,
            width: 25.o,
            fit: BoxFit.cover,
          ),
          Text(textAlign: TextAlign.center,
            maxLines: 2,
            softWrap: true,
            widget.title,
            style: theme.primaryTextStyle.copyWith(
                color:widget.mTheme.colorScheme.primary,
                fontSize: 10.o,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
