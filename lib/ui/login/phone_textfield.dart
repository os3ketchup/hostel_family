import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostels/variables/util_variables.dart';

import '../../apptheme.dart';
import '../../variables/language.dart';

class PhoneTextField extends StatefulWidget {
  const PhoneTextField({
    super.key,
    required this.onChanged,
  });

  final Function(String value) onChanged;

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.o),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.o)),
          color: mTheme.colorScheme.primary.withOpacity(0.05)),
      child: TextField(
        maxLength: 9,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          onChanged: widget.onChanged,
          keyboardType: TextInputType.number,
          style: theme.primaryTextStyle.copyWith(fontSize: mTheme.textTheme.bodyMedium!.fontSize,color: mTheme.colorScheme.primary,fontWeight: FontWeight.bold),
          cursorColor: mTheme.colorScheme.primary,
          decoration: InputDecoration(
            counterText: '',
              prefixText: '+998',
              prefixStyle: theme.primaryTextStyle.copyWith(color: mTheme.colorScheme.primary,fontWeight: FontWeight.bold),
              icon: Icon(
                Icons.phone,
                color: mTheme.colorScheme.primary,
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              labelStyle: theme.hintTextFieldStyle.copyWith(color: mTheme.colorScheme.surface),
              labelText: phoneNumber.tr)),
    );
  }
}
