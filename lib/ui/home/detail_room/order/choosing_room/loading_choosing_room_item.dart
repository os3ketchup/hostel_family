import 'package:flutter/material.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:shimmer/shimmer.dart';


class LoadingChoosingRoomItem extends StatelessWidget {
  const LoadingChoosingRoomItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for(final item in [1,2])
          Shimmer.fromColors(
            baseColor: Colors.black26,
            highlightColor: Colors.white60,
            child: Container(
              height: 130.o,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 12.o, vertical: 6.o),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 4,
                        spreadRadius: 1,
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(1, 4))
                  ],
                  color: Colors.white60,
                  border: Border.all(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.o),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
