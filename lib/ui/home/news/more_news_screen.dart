import 'package:flutter/material.dart';
import 'package:hostels/ui/home/news/vertical_anounce_card_item.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';

import '../../../providers/news_provider.dart';
import '../detail_room/order/order_appbar.dart';

class MoreNewsScreen extends StatelessWidget {
  const MoreNewsScreen({super.key, required this.newsList});

  final List<News> newsList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.o),
          child: OrderAppBar(
            titleAppbar: more.tr,
            onBackPressed: () {
              Navigator.pop(context);
            },
          )),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          return VerticalAnnounceCardItem(
            news:newsList[index],
          );
        },
      ),
    );
  }
}
