import 'package:flutter/material.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/ui/custom/profile_appbar.dart';
import 'package:hostels/ui/profile/privacy_sharing/connecting/connecting_screen.dart';
import 'package:hostels/ui/profile/privacy_sharing/deleting/delete_screen.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';

class PrivacySharingScreen extends StatefulWidget {
  const PrivacySharingScreen({super.key});

  @override
  State<PrivacySharingScreen> createState() => _PrivacySharingScreenState();
}

class _PrivacySharingScreenState extends State<PrivacySharingScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.o),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              style:
              theme.primaryTextStyle.copyWith(fontWeight: FontWeight.w700,color: mTheme.textTheme.bodyMedium!.color),
              controlAccount.tr,
              textAlign: TextAlign.start,
            ),
            Gap(10.o),
            Text(
                style: theme.hintTextFieldStyle.copyWith(color: mTheme.colorScheme.secondary),
                maxLines: 4,
                titleControlAccount.tr),
            Gap(20.o),
            _buildPrivacyItem(mTheme,connectWithUs.tr, connectWithUsTitle.tr, const ConnectingScreen()),
            Gap(20.o),
            _buildPrivacyItem(mTheme,deleteAccount.tr, titleControlAccount.tr, const DeletingScreen()),
            Gap(20.o),
            // _buildPrivacyItem(mTheme,deleteAccount.tr, deleteAccountTitle.tr, const DeletingScreen()),
          ],
        ),
      ),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.o),
          child: ProfileAppbar(titleAppbar: privacySharing.tr, color: mTheme.colorScheme.background,)),
    );
  }

  Widget _buildPrivacyItem(ThemeData mTheme,
      String title, String subtitle, Widget navigatorWidget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textAlign: TextAlign.start,
          title,
          style: theme.primaryTextStyle
              .copyWith(color: mTheme.colorScheme.primary, fontWeight: FontWeight.w700),
        ),
        Gap(10.o),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => navigatorWidget,
                ));
          },
          child: Row(
            children: [
              Expanded(
                child: Text(
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  subtitle,
                  style: theme.hintTextFieldStyle.copyWith(color: mTheme.colorScheme.secondary),
                ),
              ),
              Gap(20.o),
              const Icon(Icons.navigate_next)
            ],
          ),
        ),
      ],
    );
  }
}
