import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/providers/payment_provider.dart';
import 'package:hostels/ui/home/detail_room/order/choosing_room/loading_choosing_room_item.dart';
import 'package:hostels/ui/travel/order_item.dart';
import 'package:hostels/ui/travel/travel_appbar.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';


class TravelScreen extends StatefulWidget {
  const TravelScreen({super.key});


  @override
  State<TravelScreen> createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
  @override
  void initState() {
    paymentCounter.getAllOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: mTheme.colorScheme.background,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(110.o), child: const TravelAppbar()),
      body: Consumer(
        builder: (context, ref, child) {
          var orderNotifier = ref.watch(paymentProvider);

          if (orderNotifier.statusList == null) {

            print('list is null');
            return const LoadingChoosingRoomItem();
          }
          if (orderNotifier.statusList!.isEmpty) {
            return Center(
              child: Text(
                dataIsNotExist.tr,
                style: theme.primaryTextStyle
                    .copyWith(color: mTheme.colorScheme.primary),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: orderNotifier.getAllOrder,
            child: ListView.builder(
              itemCount: orderNotifier.statusList!.length,
              itemBuilder: (context, index) {
                return OrderItem(
                  status: orderNotifier.statusList![index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
