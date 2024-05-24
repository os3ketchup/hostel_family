
import 'package:flutter/material.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:shimmer/shimmer.dart';

class LoadingItem extends StatelessWidget {
  const LoadingItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.o,
      width: 200.o,
      child: Shimmer.fromColors(
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
          height: 200.o,
          width: 180.o,
        ),
      ),
    );
  }
}
