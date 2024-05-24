import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/network/client.dart';
import 'package:hostels/providers/notification_provider.dart';
import 'package:hostels/providers/user_provider.dart';
import 'package:hostels/ui/home/notification_item_screen.dart';
import 'package:hostels/variables/icons.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/links.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    userCounter.getNotificationList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: mTheme.colorScheme.outline,
      appBar: AppBar(

        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          notification.tr,
          style: theme.primaryTextStyle
              .copyWith(color: mTheme.colorScheme.surface),
        ),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: mTheme.colorScheme.primary,
            )),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          var notifier = ref.watch(userProvider);
          return ListView.builder(
            itemCount: notifier.hostelNotificationList!.length,
            itemBuilder: (context, index) {
              return InkWell(
                splashColor:Colors.transparent,
                highlightColor:Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  getDefinedItem(
                      int.parse(notifier.hostelNotificationList![index].id));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationItemScreen(
                          hostelNotification:
                              notifier.hostelNotificationList![index],
                        ),
                      ));
                  userCounter.getNotificationList();
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: notifier.hostelNotificationList![index].status ==
                              'unread'
                          ? Border.all(width: 1.o, color: mTheme.primaryColor)
                          : Border.all(
                              width: 1.o, color: mTheme.colorScheme.background),
                      color: mTheme.colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(12.o)),
                  margin: EdgeInsets.symmetric(vertical: 4.o, horizontal: 12.o),
                  child: ListTile(
                    leading: notifier.hostelNotificationList![index].status ==
                            'unread'
                        ? SvgPicture.asset(width: 25.o,height: 25.o,
                            SVGIcons.info,
                            color: mTheme.colorScheme.primary,
                          )
                        : SvgPicture.asset(
                            SVGIcons.read,
                            color: mTheme.colorScheme.primary,
                          ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notifier.hostelNotificationList![index].title,
                          style: theme.primaryTextStyle.copyWith(
                              color: mTheme.textTheme.bodyMedium!.color,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                            notifier.hostelNotificationList![index].description,
                            style: theme.primaryTextStyle
                                .copyWith(color: mTheme.colorScheme.surface)),
                        Text(notifier.hostelNotificationList![index].createdAt,
                            style: theme.primaryTextStyle.copyWith(
                              color: mTheme.textTheme.bodyMedium!.color,
                            )),
                      ],
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: mTheme.colorScheme.primary,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<dynamic> getDefinedItem(int index) async {
    await client.get('${Links.getDefinedNotification}$index');
  }
}
