import 'package:flutter/material.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/providers/hotels_provider.dart';
import 'package:hostels/providers/news_provider.dart';
import 'package:hostels/providers/notification_provider.dart';
import 'package:hostels/providers/user_provider.dart';
import 'package:hostels/ui/custom/custom_button.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageBottomSheet extends StatefulWidget {
  final Function(String key) onSave;

  const LanguageBottomSheet({super.key, required this.onSave});

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  String selectedLan = '';

  @override
  void initState() {
    selectedLan = pref.getString(PrefKeys.language) ?? languages.keys.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(top: 10.o, bottom: 18.o, left: 17.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(18.o),
              ),
              boxShadow: [
                BoxShadow(
                  color: mTheme.colorScheme.background,
                  blurRadius: 4,
                  offset: const Offset(0, 6),
                ),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 6.o,
                  width: 52.w,
                  decoration: BoxDecoration(
                    color: mTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(650.o),
                  ),
                ),
              ),
              Gap(15.o),
              Text(
                language.tr,
                style: theme.primaryTextStyle
                    .copyWith(color: mTheme.textTheme.labelMedium!.color),
              ),
            ],
          ),
        ),
        Gap(12.o),
        ...List.generate(
          languages.values.length,
          (index) => InkWell(
            onTap: () => setState(() {
              selectedLan = languages.keys.elementAt(index);
            }),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.o),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    languages.values.elementAt(index),
                    style: theme.primaryTextStyle.copyWith(
                        color: selectedLan == languages.keys.elementAt(index)
                            ? mTheme.colorScheme.primary
                            : mTheme.textTheme.labelMedium!.color),
                  ),
                  if (selectedLan == languages.keys.elementAt(index))
                    Icon(Icons.check,
                        color: mTheme.colorScheme.primary, size: 24.o),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 6.o, 16.w, 26.o),
          child: CustomButton(
            title: Text(save.tr,style: theme.primaryTextStyle.copyWith(color: mTheme.colorScheme.background),),
            onPressed: () {
              widget.onSave(selectedLan);
              Navigator.pop(context);
              _setLanguage();
              hostelsCounter.getHostelsList();
              hostelsCounter.getCategoryList();
              homeCounter.getNewsList();
              hostelsCounter.postFavourite();
              userCounter.getNotificationList();
            },
          ),
        ),
      ],
    );
  }
  Future<void> _setLanguage() async {
    pref.setString(PrefKeys.language, selectedLan);
    print(selectedLan);
    setState(() {
      // var localizationDelegate = LocalizedApp.of(context).delegate;
      // localizationDelegate.changeLocale(Locale(selectedLan));
      changeLocale(context, selectedLan);
    });
  }
}
