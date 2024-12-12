import 'package:flutter/services.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class PersianNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueText = newValue.text;
    final formattedText = newValueText.seRagham(); // Apply the seRagham() method

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}