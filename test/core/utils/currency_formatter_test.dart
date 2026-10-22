import 'package:erpeace_app/core/utils/currency_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrencyFormatter.format', () {
    test('formats rupiah values', () {
      final formatted = CurrencyFormatter.format(1500000);
      expect(formatted, startsWith('Rp'));
      expect(formatted, contains('1.500.000'));
    });

    test('formats large values in compact form', () {
      final formatted = CurrencyFormatter.formatCompact(1500000);
      expect(formatted, contains('Rp'));
      expect(formatted, isNot(contains('1.500.000')));
    });

    test('formats editable values and hides zero', () {
      expect(CurrencyFormatter.formatEditable(0), '');
      expect(CurrencyFormatter.formatNumber(1250), '1.250');
    });
  });

  group('CurrencyFormatter.tryParse', () {
    test('parses thousand separators', () {
      expect(CurrencyFormatter.tryParse('1.500.000'), 1500000);
      expect(CurrencyFormatter.tryParse('Rp 1.500.000'), 1500000);
    });

    test('parses a comma as decimal separator', () {
      expect(CurrencyFormatter.tryParse('1.500,50'), 1500.5);
      expect(CurrencyFormatter.tryParse('0,75'), 0.75);
    });

    test('returns null for invalid input', () {
      expect(CurrencyFormatter.tryParse(''), isNull);
      expect(CurrencyFormatter.tryParse('abc'), isNull);
      expect(CurrencyFormatter.tryParse('-'), isNull);
    });
  });

  group('CurrencyFormatter.tryParseQuantity', () {
    test('treats the dot as a decimal separator', () {
      expect(CurrencyFormatter.tryParseQuantity('1.5'), 1.5);
      expect(CurrencyFormatter.tryParseQuantity('2'), 2);
      expect(CurrencyFormatter.tryParseQuantity('0.25'), 0.25);
    });

    test('accepts a comma as decimal separator too', () {
      expect(CurrencyFormatter.tryParseQuantity('1,5'), 1.5);
    });

    test('returns null for invalid input', () {
      expect(CurrencyFormatter.tryParseQuantity(''), isNull);
      expect(CurrencyFormatter.tryParseQuantity('abc'), isNull);
    });
  });
}
