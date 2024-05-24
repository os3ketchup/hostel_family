import 'package:flutter/services.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Capitalize the first letter of each word
    return TextEditingValue(
      text: _capitalizeEachWord(newValue.text),
      selection: newValue.selection,
    );
  }

  String _capitalizeEachWord(String value) {
    List<String> words = value.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }
    return words.join(' ');
  }
}
