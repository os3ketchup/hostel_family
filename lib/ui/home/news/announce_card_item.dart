import 'package:flutter/material.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/ui/home/news/news_screen.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';
import 'package:transparent_image/transparent_image.dart';


import '../../../providers/news_provider.dart';

class AnnounceCardItem extends StatefulWidget {
  const AnnounceCardItem({super.key, required this.news});

  final News news;

  @override
  State<AnnounceCardItem> createState() => _AnnounceCardItemState();
}

class _AnnounceCardItemState extends State<AnnounceCardItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return NewsScreen(news: widget.news);
          },
        ));
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        width: 253.o,
        height: 120.o,
        decoration: BoxDecoration(
            color: mTheme.colorScheme.onPrimary,
            borderRadius: BorderRadius.all(
              Radius.circular(12.o),
            ),
            border: Border.all(width: 0.4, color: Colors.grey)),
        margin: EdgeInsets.symmetric(horizontal: 12.o),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(widget.news.imageUrl),
                height: 120.o,
                fit: BoxFit.cover,
              ),
/*          SizedBox(
            width: 253.o,
            height: 120.o,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    12.o,
                  ),
                  topRight: Radius.circular(12.o)),
              child: Image.network(
                widget.news.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          )*/
              Container(
                height: 105.o,
                margin: EdgeInsets.symmetric(horizontal: 12.o),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(10.o),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4.o,horizontal: 8.o),
                        decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.o))),
                        child: Text(
                          widget.news.type,
                          style: theme.primaryTextStyle
                              .copyWith(color: Colors.green,fontSize: 10.o),
                        )),
                    Gap(10.o),
                    Text(
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      widget.news.title,
                      style: theme.primaryTextStyle
                          .copyWith(fontWeight: FontWeight.w700,color: mTheme.textTheme.bodyMedium!.color,fontSize: 10.o),
                    ),
                    // Gap(10.o),
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
                    //             color: theme.purpleColor,
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
      ),
    );
  }
}
