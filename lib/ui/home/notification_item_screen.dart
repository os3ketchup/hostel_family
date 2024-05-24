import 'package:flutter/material.dart';
import 'package:hostels/apptheme.dart';
import 'package:gap/gap.dart';
import 'package:hostels/providers/user_provider.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:transparent_image/transparent_image.dart';

class NotificationItemScreen extends StatelessWidget {
  const NotificationItemScreen({super.key, required this.hostelNotification});
  final HostelNotification hostelNotification;
  @override
  Widget build(BuildContext context) {
    String src =
        'https://miro.medium.com/v2/resize:fit:4800/format:webp/0*SQy-aKEXu_WSoRd-.png';
    ThemeData mTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: mTheme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: mTheme.colorScheme.background,
        centerTitle: true,
        title: Text(
          notification.tr,
          style: theme.primaryTextStyle.copyWith(color: mTheme.textTheme.bodyMedium!.color),
        ),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(hostelNotification.image),
              height: 200.o,
              fit: BoxFit.fill,
            ),
            Gap(20.o),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12.o),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hostelNotification.createdAt,
                    style: theme.primaryTextStyle.copyWith(color: mTheme.colorScheme.surface,
                        fontSize: mTheme.textTheme.bodyMedium!.fontSize),
                  ),
                  Gap(5.o),
                  Row(
                    children: [
                      const Icon(Icons.add_alert),
                      Gap(8.o),
                      Text(hostelNotification.title,
                          style: theme.primaryTextStyle.copyWith(color: mTheme.textTheme.bodyMedium!.color,
                              fontSize: mTheme.textTheme.bodyMedium!.fontSize,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Gap(8.o),
                  Text(softWrap: true,maxLines: 100,style: theme.primaryTextStyle.copyWith(color: mTheme.textTheme.bodyMedium!.color,fontSize: mTheme.textTheme.bodyMedium!.fontSize),
                      hostelNotification.description),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
