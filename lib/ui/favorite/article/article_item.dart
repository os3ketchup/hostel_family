import 'package:flutter/material.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../variables/icons.dart';
import '../../../variables/images.dart';
import '../../../variables/language.dart';

class ArticleItemScreen extends StatefulWidget {
  const ArticleItemScreen({super.key});

  @override
  State<ArticleItemScreen> createState() => _ArticleItemScreenState();
}

class _ArticleItemScreenState extends State<ArticleItemScreen> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Container(
      width: 253.o,
      height: 240.o,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: theme.primaryColor.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(4, 4))
          ],
          color: mTheme.colorScheme.onPrimary,
          borderRadius: BorderRadius.all(
            Radius.circular(12.o),
          ),
          border: Border.all(width: 0.4, color: Colors.grey)),
      margin: EdgeInsets.symmetric(vertical: 12.o, horizontal: 12.o),
      child: Column(children: [
        SizedBox(
          width: double.infinity,
          height: 120.o,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  12.o,
                ),
                topRight: Radius.circular(12.o)),
            child: Image.asset(
              IMAGES.news,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12.o),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10.o),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(8.o))),
                      padding: EdgeInsets.all(6.o),
                      child: Text(
                        announce.tr,
                        style: theme.primaryTextStyle
                            .copyWith(color: Colors.green),
                      )),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected = !isSelected;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: theme.purpleColor.withOpacity(0.05),
                          borderRadius: BorderRadius.all(Radius.circular(6.o))),
                      padding: EdgeInsets.all(8.o),
                      child: SvgPicture.asset(
                          isSelected ? SVGIcons.heart : SVGIcons.outLinedHeart),
                    ),
                  )
                ],
              ),
              Gap(10.o),
              Text(
                maxLines: 2,
                'Family hostel xonalariga buyurtma berish yanada oson ',
                style: theme.primaryTextStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    color: mTheme.textTheme.bodyMedium!.color),
              ),
              Gap(10.o),
              // const Divider(),
              // Gap(10.o),
              // Row(
              //   children: [
              //     SvgPicture.asset(SVGIcons.thumbsUp),
              //     Gap(10.o),
              //     Text(
              //       '25',
              //       style: theme.primaryTextStyle.copyWith(color: mTheme.textTheme.bodyMedium!.color),
              //     ),
              //     Gap(10.o),
              //     // SvgPicture.asset(SVGIcons.comment),
              //     // Gap(10.o),
              //     // Text(
              //     //   '4',
              //     //   style: theme.primaryTextStyle,
              //     // ),
              //     Gap(10.o),
              //     SvgPicture.asset(SVGIcons.share),
              //     const Spacer(),
              //     GestureDetector(
              //       onTap: () {
              //         setState(() {
              //           isSelected = !isSelected;
              //         });
              //       },
              //       child: Container(
              //         decoration: BoxDecoration(
              //
              //             color: theme.purpleColor.withOpacity(0.05),
              //             borderRadius: BorderRadius.all(Radius.circular(6.o))),
              //         padding: EdgeInsets.all(8.o),
              //         child: SvgPicture.asset(
              //             isSelected ? SVGIcons.heart : SVGIcons.outLinedHeart),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        )
      ]),
    );
  }
}
