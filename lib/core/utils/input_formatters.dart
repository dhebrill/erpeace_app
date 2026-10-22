import 'package:flutter/services.dart';

/// Formats a numeric text field as a thousands separated number while typing.
///
/// The formatter keeps the caret at the end of the text which is good enough
/// for the quantity / price inputs used across ERPeace.
class RupiahTextInputFormatter extends TextInputFormatter {
  const RupiahTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(text: '');
    }
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Allows only digits and a single decimal separator.
class DecimalTextInputFormatter extends TextInputFormatter {
  const DecimalTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    final normalized = text.replaceAll(',', '.');
    final matches = RegExp(r'^\d{0,12}(\.\d{0,4})?$');
    if (!matches.hasMatch(normalized)) return oldValue;
    final selection = normalized.length == text.length
        ? newValue.selection
        : TextSelection.collapsed(offset: normalized.length);
    return TextEditingValue(text: normalized, selection: selection);
  }
}

/// Restricts the input to digits only (used for phone numbers).
class DigitsOnlyTextInputFormatter extends TextInputFormatter {
  const DigitsOnlyTextInputFormatter({this.maxLength = 20});

  final int maxLength;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final capped = digits.length > maxLength
        ? digits.substring(0, maxLength)
        : digits;
    return TextEditingValue(
      text: capped,
      selection: TextSelection.collapsed(offset: capped.length),
    );
  }
}
