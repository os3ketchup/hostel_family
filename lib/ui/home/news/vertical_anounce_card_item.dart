import 'package:flutter/material.dart';
import 'package:hostels/ui/home/news/news_screen.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../apptheme.dart';
import '../../../providers/news_provider.dart';
import 'package:gap/gap.dart';

class VerticalAnnounceCardItem extends StatelessWidget {
  const VerticalAnnounceCardItem({super.key, required this.news});

  final News news;

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return NewsScreen(news: news);
        },));
      },
      child: Container(
        height: 100.h,
        margin: EdgeInsets.symmetric(horizontal: 12.o, vertical: 6.o),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: 4,
                  spreadRadius: 1,
                  color: mTheme.colorScheme.shadow.withOpacity(0.2),
                  offset: const Offset(1, 4))
            ],
            color: mTheme.colorScheme.onPrimary,
            border: Border.all(width: 1, color: mTheme.colorScheme.background),
            borderRadius: BorderRadius.all(
              Radius.circular(12.o),
            )),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.o),
                            bottomLeft: Radius.circular(12.o))),
                    height: 98.h,
                    width: 250.w,
                    clipBehavior: Clip.hardEdge,
                    child: FadeInImage(
                        fit: BoxFit.cover,
                        placeholder: MemoryImage(kTransparentImage),
                        image: NetworkImage(
                          news.imageUrl,
                        ))),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.o),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(4.o),
                              decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.o))),
                              child: Text(
                                news.type,
                                style: theme.primaryTextStyle.copyWith(fontSize: 10.o,
                                    color: mTheme.textTheme.bodyMedium!.color,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            // SvgPicture.asset(SVGIcons.share),
                          ],
                        ),
                        Gap(10.o),
                        SizedBox(
                          width: double.infinity,
                          height: 30.h,
                          child: Text(
                            maxLines: 3,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            news.title,
                            style:
                                theme.hintTextFieldStyle.copyWith(fontSize: 10.o,color: mTheme.textTheme.bodyMedium!.color),
                          ),
                        ),
                        // const Divider(),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     Gap(12.o),
                        //     SvgPicture.asset(SVGIcons.thumbsUp),
                        //     Gap(10.o),
                        //     Text(
                        //       '25',
                        //       style: theme.primaryTextStyle.copyWith(color: mTheme.textTheme.bodyMedium!.color),
                        //     ),
                        //     Gap(10.o),
                        //     const Spacer(),
                        //     GestureDetector(
                        //       onTap: () {
                        //         // setState(() {
                        //         //   isClicked = !isClicked;
                        //         // });
                        //       },
                        //       child: Container(
                        //         padding: EdgeInsets.all(8.o),
                        //         decoration: BoxDecoration(
                        //             color: theme.purpleColor.withOpacity(0.1),
                        //             borderRadius:
                        //                 BorderRadius.all(Radius.circular(8.o))),
                        //         child: SvgPicture.asset(SVGIcons.outLinedHeart),
                        //       ),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
