import 'package:flutter/material.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/ui/register/upperCaseTextFormatter.dart';
import 'package:hostels/variables/util_variables.dart';

class DataTextFieldWidget extends StatefulWidget {
  const DataTextFieldWidget(
      {super.key,
      required this.onChanged,
      required this.labelText, required this.textEditingController,
      });

  final Function(String value) onChanged;
  final String labelText;
  final TextEditingController textEditingController;


  @override
  State<DataTextFieldWidget> createState() => _DataTextFieldWidgetState();
}

class _DataTextFieldWidgetState extends State<DataTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.o, horizontal: 12.o),
      padding: EdgeInsets.symmetric(horizontal: 16.o),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.o)),
          color: mTheme.colorScheme.primary.withOpacity(0.05)),
      child: TextField(
        maxLength: 30,
        controller: widget.textEditingController,
          onChanged: widget.onChanged,
          inputFormatters: [UpperCaseTextFormatter()],
          keyboardType: TextInputType.name,
          style: theme.primaryTextStyle.copyWith(color: mTheme.colorScheme.primary),
          cursorColor: theme.primaryColor,
          decoration: InputDecoration(
            counterText: '',
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              labelStyle: theme.hintTextFieldStyle.copyWith(color: mTheme.colorScheme.surface),
              labelText: widget.labelText)),
    );
  }
}
