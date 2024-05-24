import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/ui/favorite/article/article_screen.dart';
import 'package:hostels/ui/favorite/custom_tab_indicator.dart';
import 'package:hostels/ui/favorite/hotel/hotel_screen.dart';
import 'package:hostels/ui/favorite/hotel/loading_favourite_hotel_item.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';

import '../../providers/hotels_provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key, required this.onNavigate});
  final Function(int selectedPage) onNavigate;

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.backgroundGrey,
        appBar: AppBar(
          backgroundColor: mTheme.colorScheme.background,
          automaticallyImplyLeading: false,
          title: Text(
            favorites.tr,
            style: theme.primaryTextStyle.copyWith(
                fontWeight: FontWeight.w700,
                color: mTheme.colorScheme.primary,
                fontSize: 18.o),
          ),
          // bottom: TabBar(
          //     onTap: (value) {
          //       // _currentIndex = value;
          //     },
          //     labelStyle: theme.primaryTextStyle.copyWith(
          //         color: mTheme.colorScheme.primary,
          //         fontWeight: FontWeight.w600,
          //         fontSize: 16.o),
          //     unselectedLabelColor: Colors.grey,
          //     indicator: CustomTabIndicator(mThem: mTheme),
          //     tabs: [
          //       Tab(
          //         text: hotel.tr,
          //       ),
          //       // Tab(
          //       //   text: article.tr,
          //       // )
          //     ]),
        ),
        body: Consumer(
          builder: (context, ref, child) {
            final notifier = ref.watch(hostelsProvider);
            if (notifier.hostelsList == null) {
              return const LoadingFavouriteHotelItem();
            }
            return TabBarView(children: [
              HotelScreen(
                hotels: notifier.hostelsList!,
                onNavigate: widget.onNavigate,
              ),
              // const ArticleScreen()
            ]);
          },
        ),
      ),
    );
  }
}
