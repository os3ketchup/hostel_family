import 'package:flutter/material.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/variables/util_variables.dart';


class DateTextField extends StatefulWidget {
  const DateTextField({super.key, required this.date, required this.onIconTapped, required this.birthDay, required this.onTextFieldTapped,});

  final String date;
  final Function() onIconTapped;
  final Function() onTextFieldTapped;
  final String birthDay;
  @override
  State<DateTextField> createState() => _DateTextFieldState();
}

class _DateTextFieldState extends State<DateTextField> {


  TextEditingController name = TextEditingController(),
      surname = TextEditingController(),
      date = TextEditingController();

  @override
  Widget build(BuildContext context) {

    ThemeData mTheme = Theme.of(context);
    date.text = widget.birthDay;
    return GestureDetector(
      onTap: widget.onIconTapped,
      child: Container(
        // margin: EdgeInsets.symmetric(vertical: 8.o, horizontal: 12.o),
        padding: EdgeInsets.symmetric(horizontal: 16.o,vertical: 2.o),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.o)),
            color: mTheme.colorScheme.onSurfaceVariant),
        child: TextField(
            // onTap: () => widget.birthDay.isEmpty ? date.text = '-- -- --' : widget.birthDay,
          onTap: widget.onTextFieldTapped,
            readOnly: true,
            controller: date,
            keyboardType: TextInputType.phone,
            style: theme.primaryTextStyle.copyWith(color: mTheme.colorScheme.primary),
            cursorColor: theme.primaryColor,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: widget.onIconTapped,
                  icon:  Icon(Icons.edit_calendar_rounded,color: mTheme.colorScheme.secondary,),
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                labelStyle: theme.hintTextFieldStyle.copyWith(color: mTheme.colorScheme.surface),
                labelText: widget.date)),
      ),
    );
  }

}
