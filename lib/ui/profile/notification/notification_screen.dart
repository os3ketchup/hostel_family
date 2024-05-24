import 'package:flutter/material.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/ui/custom/profile_appbar.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _pushNotificationEnabled = false;

  Widget _buildSwitchButton() {
    return Container(
      child: Switch(
        activeTrackColor: theme.primaryColor,
        thumbColor:  MaterialStateProperty.resolveWith ((Set  states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.green;
          }
          return theme.white;
        }),
        value: _pushNotificationEnabled,
        onChanged: (bool value) {
         setState(() {
           _pushNotificationEnabled = !_pushNotificationEnabled;
         });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.o),
        child: ProfileAppbar(titleAppbar: notification.tr, color: mTheme.colorScheme.background,),
      ),
      body: _buildSwitchButton(),
    );
  }
}
