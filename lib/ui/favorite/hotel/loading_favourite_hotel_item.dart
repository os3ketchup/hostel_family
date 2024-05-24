import 'package:flutter/material.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:shimmer/shimmer.dart';


class LoadingFavouriteHotelItem extends StatelessWidget {
  const LoadingFavouriteHotelItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black26,
      highlightColor: Colors.white60,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.all(
              Radius.circular(12.o),
            ),
            border: Border.all(width: 1.o, color: Colors.grey)),
        margin: EdgeInsetsDirectional.symmetric(horizontal: 8.o),
        height: 119.o,
        width: double.infinity,
      ),
    );
  }
}
