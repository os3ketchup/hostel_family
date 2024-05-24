import 'package:flutter/material.dart';
import 'package:hostels/variables/util_variables.dart';



class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.title, required this.onPressed});

  final Widget title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: mTheme.colorScheme.primary.withOpacity(1),
         /* foregroundColor: theme.white.withOpacity(1)*/),
      onPressed: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: 50.o,
        width: double.infinity,
        child: title,
      ),
    );
  }
}
