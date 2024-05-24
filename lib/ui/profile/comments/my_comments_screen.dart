import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/providers/user_provider.dart';
import 'package:hostels/ui/custom/profile_appbar.dart';
import 'package:hostels/ui/home/detail_room/order/choosing_room/loading_choosing_room_item.dart';
import 'package:hostels/ui/profile/comments/my_comment_item.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';


class MyCommentScreen extends StatefulWidget {
  const MyCommentScreen({super.key});

  @override
  State<MyCommentScreen> createState() => _MyCommentScreenState();
}

class _MyCommentScreenState extends State<MyCommentScreen> {
  @override
  void initState() {
    userCounter.getUserAllComment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: mTheme.colorScheme.background,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.o),
          child: ProfileAppbar(
            titleAppbar: comments.tr,
            color: mTheme.colorScheme.background,
          )),
      body: Consumer(
        builder: (context, ref, child) {
          var userNotifier = ref.watch(userProvider);

          if(userNotifier.userCommentList == null) {
            return const LoadingChoosingRoomItem();
          }
          if(userNotifier.userCommentList!.isEmpty) {
            return Center(child: Text(dataIsNotExist.tr,style: theme.primaryTextStyle.copyWith(color: mTheme.colorScheme.primary),),);
          }
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: userNotifier.userCommentList!.length,
            itemBuilder: (context, index) {
              
              return  MyCommentItem(userComment: userNotifier.userCommentList![index],);
            },
          );
        },
      ),
    );
  }
}
