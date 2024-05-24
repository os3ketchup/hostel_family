import 'package:flutter/material.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';
import '../../../../../apptheme.dart';

class FilterContainer extends StatelessWidget {
  const FilterContainer(
      {super.key,
      required this.leadingIcon,
      required this.title,
      required this.subtitle, required this.onTap});

  final IconData leadingIcon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.o),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.o),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.o, vertical: 9.o),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 0.5.o, color: mTheme.colorScheme.primary),
              borderRadius: BorderRadius.all(Radius.circular(12.o))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(leadingIcon),
              Gap(10.o),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [Text(title,style: theme.primaryTextStyle.copyWith(color: mTheme.textTheme.bodyMedium!.color),), Text(subtitle,style: theme.primaryTextStyle.copyWith(color: mTheme.textTheme.bodyMedium!.color))],
              )
            ],
          ),
        ),
      ),
    );
  }
}
