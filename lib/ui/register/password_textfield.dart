import 'package:flutter/material.dart';
import 'package:hostels/variables/util_variables.dart';

import '../../apptheme.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.title,
    required this.onChanged,
  });

  final String title;
  final Function(String value) onChanged;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.o),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.o)),
          color: theme.textFieldBackgroundColor),
      child: TextField(
          onChanged: widget.onChanged,
          obscureText: _obscureText,
          keyboardType: TextInputType.text,
          style: theme.primaryTextStyle,
          cursorColor: theme.primaryColor,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              labelStyle: theme.hintTextFieldStyle,
              labelText: widget.title)),
    );
  }
}
