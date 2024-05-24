import 'package:flutter/material.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/providers/hotels_provider.dart';
import 'package:hostels/ui/favorite/hotel/hotel_item.dart';

import '../../../variables/language.dart';

class HotelScreen extends StatefulWidget {
  const   HotelScreen({super.key, required this.hotels, required this.onNavigate});

  final List<Hostels> hotels;
  final Function(int selectedPage) onNavigate;

  @override
  State<HotelScreen> createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: mTheme.colorScheme.background,
      body: Builder(builder: (context) {
        var filteredList = widget.hotels.where((element) {
          return element.liked == true;
        }).toList();
        return filteredList.isNotEmpty
            ? ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            return HotelItemScreen(
              hostels: filteredList[index],
              onNavigate: widget.onNavigate,
            );
          },
        )
            : Center(
          child: Text(
            dataIsNotExist.tr,
            style: theme.primaryTextStyle
                .copyWith(color: mTheme.colorScheme.primary),
          ),
        );
      }
        // },
      ),
    );
  }
}
