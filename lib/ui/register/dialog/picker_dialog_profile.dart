import 'package:flutter/material.dart';
import 'package:hostels/ui/register/dialog/PickerWidget.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';

import '../../../apptheme.dart';

/// Oy va kun husobi 1 dan boshlanadi va oyning maksimal qiymati 12
/// Sanaga tanlashda chegara maksimal va minimal chegaralarni o'rnatishingiz mumkin.
/// Agar maksimal yilning qiymati null bo'lsa maksimal oyning va maksimal kunning qiymati ishlamaydi.
/// Agar maksimal oyning qiymati null bo'lsa maksimal kunning qiymati ishlamaydi.
/// Agar minimal yilning qiymati null bo'lsa minimal oyning va minimal kunning qiymati ishlamaydi.
/// Agar minimal oyning qiymati null bo'lsa minimal kunning qiymati ishlamaydi.

class PickerDialogProfile extends StatefulWidget {
  final String title;
  final int? maxYear, minYear, maxMonth, minMonth, minDay, maxDay;
  final Function(int year, int mounth, int day) selected;

  const PickerDialogProfile({
    super.key,
    required this.selected,
    required this.title,
    this.maxYear,
    this.minYear,
    this.maxMonth,
    this.minMonth,
    this.minDay,
    this.maxDay, required this.initialDate,
  })  : assert(maxYear == null || minYear == null || maxYear > minYear),
        assert(maxMonth == null || minMonth == null || maxMonth > minMonth),
        assert(maxDay == null || minDay == null || maxDay > minDay);
    final String initialDate;
  @override
  _PickerDialogState createState() => _PickerDialogState();
}

class _PickerDialogState extends State<PickerDialogProfile> {
  DateTime date = DateTime.now();
  int currentMonth = 0;
  int year = 0;
  int mouth = 1;
  int day = 1;
  List<int> yearData = [];
  List<String> monthData = mounths();
  List<int> days = [];

  @override
  void initState() {

    extractDateComponents(widget.initialDate);
    date = DateTime(year, mouth, day);
    mouth = date.month;
    year = date.year;
    day = date.day;
    setDateTimeLimit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(
        top: 15.h,
        bottom: 15.h,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.h),
            topRight: Radius.circular(20.h),
          ),
          color: mTheme.colorScheme.background),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 20.h,
              bottom: 10.h,
            ),
            child: Text(
              widget.title,
              style: theme.primaryTextStyle.copyWith(
                  color: mTheme.textTheme.bodyMedium!.color,
                  fontSize: mTheme.textTheme.headlineSmall!.fontSize,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PickerWidet(
                    itemWidth: 100.w,
                    itemHeight: 40.h,
                    itemCount: days.length,
                    currentIndex: date.day,
                    builder: (context, index, isSelected) {
                      return Text(
                        days[index].toString(),
                        style: theme.primaryTextStyle.copyWith(
                          fontSize: isSelected ? 22.o : 16.o,
                          color: isSelected
                              ? mTheme.colorScheme.primary
                              : mTheme.colorScheme.secondary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      );
                    },
                    onChange: (index) {
                      setState(() {
                        day = days[index];
                        date = DateTime(date.year, date.month, days[index]);
                      });
                    },
                  ),
                  PickerWidet(
                    itemWidth: 130.w,
                    itemHeight: 40.h,
                    itemCount: mounths().length,
                    currentIndex: currentMonth,
                    builder: (context, index, isSelected) {
                      return Text(
                        mounths()[index],
                        style: theme.primaryTextStyle.copyWith(
                          fontSize: isSelected ? 22.o : 16.o,
                          color: isSelected
                              ? mTheme.colorScheme.primary
                              : mTheme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                    onChange: (index) {
                      date = DateTime(date.year, index + 1, date.day);
                      mouth = index + 1;
                      if (widget.minYear != null && widget.minMonth != null) {
                        mouth += widget.minMonth!;
                      }
                      final lastDay =
                          DateTime(date.year, date.month + 1, 0).day;
                      days = [for (var i = 1; i <= lastDay; i++) i];
                      setState(() {});
                    },
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  PickerWidet(
                    itemWidth: 120.w,
                    itemHeight: 40.h,
                    itemCount: yearData.length,
                    currentIndex: yearData.indexOf(year),
                    builder: (context, index, isSelected) {
                      return Text(
                        '${yearData[index]}',
                        style: theme.primaryTextStyle.copyWith(
                          fontSize: isSelected ? 22.o : 16.o,
                          color: isSelected
                              ? mTheme.colorScheme.primary
                              : mTheme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                    onChange: (index) {
                      setState(() {
                        date =
                            DateTime(yearData[index], date.month + 1, date.day);
                        year = yearData[index];
                        if (index == yearData.length - 1) {
                          setDateTimeLimit();
                        } else {
                          monthData = mounths();
                          final lastDay =
                              DateTime(date.year, date.month + 1, 0).day;
                          days = [for (var i = 1; i <= lastDay; i++) i];
                        }
                      });
                    },
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 1.h,
                    width: 520.w,
                    color: mTheme.colorScheme.primary,
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Container(
                    height: 1.h,
                    width: 520.w,
                    color: mTheme.colorScheme.primary,
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40.h,
                    margin: EdgeInsets.only(
                      top: 5.h,
                      left: 20.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.o),
                      color: mTheme.colorScheme.error,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Bekor qilish',
                      style: theme.primaryTextStyle.copyWith(
                        fontSize: mTheme.textTheme.bodyLarge!.fontSize,
                        color: mTheme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 30.w,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    widget.selected(year, mouth, day);
                    print('$day.$mouth.$year 2222');
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40.h,
                    margin: EdgeInsets.only(
                      top: 5.h,
                      right: 20.w,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.o),
                        color: mTheme.colorScheme.primary),
                    alignment: Alignment.center,
                    child: Text(
                      save.tr,
                      style: theme.primaryTextStyle.copyWith(
                          fontSize: mTheme.textTheme.bodyLarge!.fontSize,
                          color: mTheme.colorScheme.onPrimary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void setDateTimeLimit() {
    int maxYear = DateTime.now().year,
        maxMonth = 12,
        maxDay = 31,
        minYear = date.year - 120,
        minMonth = 1,
        minDay = 1;

    // final DateTime now = DateTime.now();
    // final DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
    //
    // // Update the maxYear, maxMonth, and maxDay variables to yesterday's date
    // int maxYear = yesterday.year,
    //     maxMonth = yesterday.month,
    //     maxDay = yesterday.day,
    //     minYear = maxYear - 120,
    //     minMonth = 1,
    //     minDay = 1;

    // Rest of your code...

    // Ensure that the date is within the specified range
    date = DateTime(
      date.year.clamp(minYear, maxYear),
      date.month.clamp(minMonth, maxMonth),
      date.day.clamp(minDay, maxDay),
    );

    if (widget.minYear != null) {
      minYear = widget.minYear! - 120;
      if (widget.minMonth != null) {
        if (widget.minMonth! > 0) {
          minMonth = widget.minMonth!;
          if (widget.minDay != null) {
            if (widget.minDay! > 0) {
              minDay = widget.minDay!;
            }
          }
        }
      }
      if (date.year <= minYear) {
        /// ushbu soha real holatda ishlamaydi.
        /// ammo vaqti noto'g'ri qurimalar uchun ehtiyot shart yozilmoqda
        int settedMonth = date.month + 1, settedDay = date.day;
        if (date.year == minYear && date.month <= minMonth) {
          settedMonth = minMonth;
          if (date.month == minMonth && date.day < minDay) {
            settedDay = minDay;
          }
        }
        date = DateTime(minYear, settedMonth, settedDay);
      }
    }
    if (widget.maxYear != null) {
      maxYear = widget.maxYear!;
      if (widget.maxMonth != null) {
        if (widget.maxMonth! <= 12) {
          maxMonth = widget.maxMonth!;
          if (widget.maxDay != null) {
            if (widget.maxDay! <= 31) {
              maxDay = widget.maxDay!;
            }
          }
        }
      }
      if (date.year >= maxYear) {
        int settedMonth = date.month + 1, settedDay = date.day;
        if (date.year == maxYear && date.month >= maxMonth) {
          settedMonth = maxMonth;
          if (date.month == maxMonth && date.day > maxDay) {
            settedDay = maxDay;
          }
        }
        date = DateTime(maxYear, settedMonth, settedDay);
      }
    }
    yearData = [for (var i = minYear; i <= maxYear; i++) i];
    monthData = [for (var i = minMonth; i <= maxMonth; i++) mounths()[i - 1]];
    final lastDay = DateTime(date.year, date.month + 1, 0).day;
    if (lastDay < maxDay) {
      maxDay = lastDay;
    }
    days = [for (var i = minDay; i <= maxDay; i++) i];
    setState(() {
      if (date.month > 1) {
        currentMonth = date.month;
      }
    });
  }
  void extractDateComponents(String dateString) {
    // Split the date string by '.' to get day, month, and year separately
    List<String> dateComponents = dateString.split('.');

    // Ensure that the date string has three components (day, month, and year)
    if (dateComponents.length == 3) {
      // Parse the date components into integers
       day = int.tryParse(dateComponents[0]) ?? 0;
       mouth = int.tryParse(dateComponents[1]) ?? 0;
       year = int.tryParse(dateComponents[2]) ?? 0;
      year = year+1;
      // Print the extracted components (you can store them in variables or use them as needed)
      print('Day: $day, Month: $mouth, Year: $year');
    } else {
      // Handle invalid date string (incorrect format)
      print('Invalid date string format');
    }
  }
}
