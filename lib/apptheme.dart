
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

_ThemeApp? _appTheme;

_ThemeApp get theme {
  _appTheme ??= _ThemeApp();
  return _appTheme!;
}

void updateTheme() {
  _appTheme = _ThemeApp();
  //updateNav();
}

class _ThemeApp {
  /// Color primaryColor = const Color(0xff3675D4);
  Color primaryColor = const Color(0xff002270);
  Color white = const Color.fromARGB(255, 255, 255, 255);
  Color textFieldBackgroundColor = const Color(0xffF5F6F9);
  Color textFieldHintColor = const Color(0xff808080);
  Color appTitleColor = const Color(0xff0A0434);
  Color purpleColor = const Color(0x4cfc1282);
  Color purpleColorClear = const Color(0xfffc1282);
  Color backgroundGrey = const Color(0xffF5F6F9);
  Color iconColor = const Color(0xff0768FD);



  TextStyle primaryTextStyle = GoogleFonts.poppins(
      textStyle: const TextStyle(
        color: Color(0xFF000000),
        overflow: TextOverflow.ellipsis,
      ));
  TextStyle hintTextFieldStyle = GoogleFonts.poppins(
      textStyle: const TextStyle(
        color: Color(0xff808080),
        overflow: TextOverflow.ellipsis,
      ));

  MaskTextInputFormatter numberMaskFormatter = MaskTextInputFormatter(
    mask: '+998(##)-###-##-##',
    filter: {"#": RegExp(r'\d')},
    type: MaskAutoCompletionType.eager,
  );



}
