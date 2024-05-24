import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hostels/variables/icons.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../apptheme.dart';

class CalendarBottomSheet extends StatefulWidget {
 const  CalendarBottomSheet({super.key, required this.onTap, required this.date});
  final String date;
 final Function(String date,String startedDate,String finishedDate) onTap;
  @override
  State<CalendarBottomSheet> createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  String _selectedDate = '';
  String _dateCount = '';

  String _range =
      '${DateFormat('MMMM d, y').format(DateTime.now())} - ${DateFormat('MMMM d, y').format(DateTime.now().add(const Duration(days: 1)))}';
  String _rangeCount = '';

  String startedDate = DateFormat('dd.MM.yyyy').format(DateTime.now());
  String finishedDate =
      DateFormat('dd.MM.yyyy').format(DateTime.now().add(const Duration(days: 1)));

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('MMMM d, y').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('MMMM d, y').format(args.value.endDate ?? args.value.startDate)}';
        startedDate = DateFormat('dd.MM.yyyy').format(args.value.startDate);
        finishedDate = DateFormat('dd.MM.yyyy')
            .format(args.value.endDate ?? args.value.startDate);
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }
@override
  void initState() {
    _range = widget.date;
    print(widget.date);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(top: 30.o,bottom: Platform.isIOS?15.o:1.o
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 20.o),
        child: Column(
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20.o),
                  alignment: Alignment.centerRight,
                  child: SvgPicture.asset(
                    SVGIcons.close,
                    color: Colors.red,
                  ),
                )),
            Gap(20.o),
            Container(
              padding: EdgeInsets.only(bottom: 20.o),
              margin: EdgeInsets.only(left: 20.o, right: 20.o),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dates.tr,
                    style: theme.primaryTextStyle
                        .copyWith(fontWeight: FontWeight.bold,color: mTheme.textTheme.bodyMedium!.color),
                  ),
                  Text(
                    _range,
                    style: theme.primaryTextStyle.copyWith(
                        color: ThemeMode.dark == ThemeMode.light
                            ? theme.primaryTextStyle.color
                            : mTheme.textTheme.bodyMedium!.color),
                  ),
                ],
              ),
            ),
            Gap(5.o),
            Container(
              padding: EdgeInsets.all(8.o),
              margin: EdgeInsets.symmetric(horizontal: 12.o),
              decoration: BoxDecoration(
                  color: mTheme.colorScheme.secondaryContainer,
                  boxShadow: [
                    BoxShadow(
                        color: mTheme.colorScheme.shadow.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(4, 4))
                  ],
                  // gradient: LinearGradient(colors: [
                  //  theme.primaryColor.withOpacity(0.1),
                  //  theme.primaryColor.withOpacity(0.1),
                  //
                  // ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.all(Radius.circular(12.o))),
              height: 250.o,
              child: SfDateRangePicker(
                initialSelectedDate: DateTime.now(),
                initialSelectedRanges: [
                  PickerDateRange(
                    DateTime.now(),
                    DateTime.now().add(const Duration(days: 1)),
                  )
                ],
                backgroundColor: mTheme.colorScheme.secondaryContainer,
                initialSelectedRange: _range.isNotEmpty
                    ? PickerDateRange(
                  DateFormat('MMMM d, y').parse(_range.split(' - ')[0]),
                  DateFormat('MMMM d, y').parse(_range.split(' - ')[1]),
                )
                    : null, // Ini
                enablePastDates: false,
                toggleDaySelection: true,
                selectionRadius: 20,
                startRangeSelectionColor: mTheme.colorScheme.primary,
                endRangeSelectionColor: mTheme.colorScheme.primary,
                todayHighlightColor: mTheme.colorScheme.primary,
                headerStyle: DateRangePickerHeaderStyle(
                    backgroundColor: mTheme.colorScheme.secondaryContainer,
                    textStyle: theme.primaryTextStyle.copyWith(
                        color: mTheme.colorScheme.primary,
                        fontWeight: FontWeight.w700)),
                monthCellStyle: DateRangePickerMonthCellStyle(
                    todayTextStyle: theme.primaryTextStyle,
                    textStyle: theme.primaryTextStyle.copyWith(
                        fontWeight: FontWeight.w700,
                        color: mTheme.textTheme.bodyMedium!.color)),
                rangeSelectionColor: mTheme.colorScheme.primary,

                rangeTextStyle: theme.primaryTextStyle
                    .copyWith(fontWeight: FontWeight.w700, color: theme.white),
                selectionTextStyle: theme.primaryTextStyle.copyWith(
                    color: mTheme.colorScheme.onSecondary,
                    fontWeight: FontWeight.w700),
                showNavigationArrow: true,
                monthViewSettings: DateRangePickerMonthViewSettings(
                    viewHeaderStyle: DateRangePickerViewHeaderStyle(
                        // backgroundColor: mTheme.colorScheme.onSecondary,
                        textStyle: theme.hintTextFieldStyle.copyWith(fontSize: mTheme.textTheme.bodySmall!.fontSize,
                            fontWeight: FontWeight.w700,
                            color: mTheme.colorScheme.secondary)),
                    firstDayOfWeek: 1,
                    showTrailingAndLeadingDates: true,
                    enableSwipeSelection: false),

                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
                // initialSelectedRange: PickerDateRange(
                //     DateTime.now().subtract(const Duration(days: 4)),
                //     DateTime.now().add(const Duration(days: 3))),
              ),
            ),
            Gap(20.o),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                widget.onTap(_range,startedDate,finishedDate);
              },
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.o),
                  padding: EdgeInsets.all(8.o),
                  width: double.infinity * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.o),
                    color: mTheme.colorScheme.primary,
                  ),
                  child: Text(
                    choose.tr,
                    textAlign: TextAlign.center,
                    style: theme.primaryTextStyle.copyWith(
                        color: mTheme.colorScheme.onPrimary,
                        fontSize: mTheme.textTheme.bodyMedium!.fontSize),
                  )),
            )
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Expanded(child: Container(decoration: Box,child: Text('Chiqish',textAlign: TextAlign.center,))),
            //
            //     Expanded(child: ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
