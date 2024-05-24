import 'package:flutter/material.dart';
import 'package:hostels/ui/register/upperCaseTextFormatter.dart';
import 'package:hostels/variables/util_variables.dart';

import '../../apptheme.dart';

class NameTextField extends StatelessWidget {
  const NameTextField(
      {required this.firstName, required this.onChanged, super.key, required this.controller});

  final String firstName;
  final Function(String value) onChanged;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.o),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.o)),
          color: mTheme.colorScheme.onSurfaceVariant),
      child: TextField(
        inputFormatters: [UpperCaseTextFormatter()],
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
          maxLength: 30,
        textInputAction: TextInputAction.next,
        onChanged: onChanged,
          keyboardType: TextInputType.text,
          style: theme.primaryTextStyle.copyWith(color: mTheme.textTheme.bodyMedium!.color),
          cursorColor: mTheme.colorScheme.primary,
          decoration: InputDecoration(
            counterText: '',
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              labelStyle: theme.hintTextFieldStyle.copyWith(color: mTheme.textTheme.bodyMedium!.color),
              labelText: firstName)),
    );
  }
}
