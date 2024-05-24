import 'package:flutter/material.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/providers/news_provider.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';
import 'package:flutter_html/flutter_html.dart';

import '../detail_room/order/order_appbar.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key, required this.news});

  final News news;

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.o),
          child: OrderAppBar(
            titleAppbar: news.type,
            onBackPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.o),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Gap(20.o),
              Text(
                maxLines: 5, textAlign: TextAlign.start,
                softWrap: true,
                news.title,
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    fontWeight: FontWeight.bold),
                // style: theme.primaryTextStyle.copyWith(color: mTheme.textTheme.bodyMedium!.color,fontSize: mTheme.textTheme.headlineMedium!.fontSize),
              ),
              Gap(10.h),
              Html(data: news.content),
            ],
          ),
        ),
      ),
    );
  }
}
