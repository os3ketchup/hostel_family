import 'package:flutter/material.dart';
import 'package:hostels/variables/util_variables.dart';

import '../../apptheme.dart';

class DaterTextField extends StatefulWidget {
  const DaterTextField({
    super.key,
    required this.onChanged,
    required this.title,
    required this.onCalendarClicked,
  });

  final String title;
  final Function(String value) onChanged;
  final Function() onCalendarClicked;

  @override
  State<DaterTextField> createState() => _DaterTextFieldState();
}

class _DaterTextFieldState extends State<DaterTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.o),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.o)),
          color: theme.textFieldBackgroundColor),
      child: TextField(
          onChanged: widget.onChanged,
          keyboardType: TextInputType.text,
          style: theme.primaryTextStyle,
          cursorColor: theme.primaryColor,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: widget.onCalendarClicked,
                icon: const Icon(Icons.edit_calendar_rounded),
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              labelStyle: theme.hintTextFieldStyle,
              labelText: widget.title)),
    );
  }
}
