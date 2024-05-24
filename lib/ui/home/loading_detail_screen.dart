import 'package:flutter/material.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gap/gap.dart';

class LoadingDetailScreen extends StatelessWidget {
  const LoadingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black26,
      highlightColor: Colors.white60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 300.h,
            color: Colors.white60,
          ),
          Gap(20.o),
          Container(
            margin: EdgeInsets.only(left: 20.w),
            width: 200.w,
            color: Colors.white60,
            height: 20.h,
          ),
          Gap(20.o),
          Container(
            margin: EdgeInsets.only(left: 20.w),
            width: 150.w,
            color: Colors.white60,
            height: 20.h,
          ),
          Gap(20.o),
          Container(
            margin: EdgeInsets.only(left: 20.w),
            child: Row(
              children: [
                Container(
                  width: 150.w,
                  color: Colors.white60,
                  height: 20.h,
                ),
                Gap(50.o),
                Container(
                  width: 100.w,
                  color: Colors.white60,
                  height: 20.h,
                ),
              ],
            ),
          ),
          Gap(20.o),
          Container(
            margin: EdgeInsets.only(left: 20.w),
            width: 100.w,
            color: Colors.white60,
            height: 20.h,
          ),
          Gap(20.o),
          Container(
            margin: EdgeInsets.only(left: 20.w,right: 20.w),
            width: double.infinity,
            color: Colors.white60,
            height: 20.h,
          ),
          Gap(20.o),
          Container(
            margin: EdgeInsets.only(left: 20.w,right: 20.w),
            width: double.infinity,
            color: Colors.white60,
            height: 20.h,
          ),
          Gap(20.o),
          Container(
            margin: EdgeInsets.only(left: 20.w),
            width: 100.w,
            color: Colors.white60,
            height: 20.h,
          ),
        ],
      ),
    );
  }
}
