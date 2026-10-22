import 'package:intl/intl.dart';

/// Rupiah friendly number formatting helpers.
abstract final class CurrencyFormatter {
  const CurrencyFormatter._();

  static const String locale = 'id_ID';

  static final NumberFormat _rupiah = NumberFormat.currency(
    locale: locale,
    symbol: 'Rp',
    decimalDigits: 0,
  );

  static final NumberFormat _compact = NumberFormat.compactCurrency(
    locale: locale,
    symbol: 'Rp',
    decimalDigits: 1,
  );

  static final NumberFormat _plain = NumberFormat.decimalPattern(locale)
    ..maximumFractionDigits = 2;

  /// Formats [value] as `Rp 1.500.000`.
  static String format(num value) => _rupiah.format(value);

  /// Formats [value] without the currency symbol, e.g. `1.500.000`.
  static String formatNumber(num value) => _plain.format(value);

  /// Formats [value] in a compact form, e.g. `Rp 1,5 jt`.
  static String formatCompact(num value) => _compact.format(value);

  /// Formats [value] as a plain input value (used inside text fields).
  static String formatEditable(num value) =>
      value == 0 ? '' : _plain.format(value);

  /// Parses a user supplied number, tolerating thousand separators and a
  /// comma as decimal separator. Returns `null` when the value is invalid.
  static double? tryParse(String raw) {
    var cleaned = raw.trim().replaceAll(RegExp(r'[^0-9,.\-]'), '');
    if (cleaned.isEmpty) return null;
    cleaned = cleaned.replaceAll('.', '');
    cleaned = cleaned.replaceAll(',', '.');
    final parsed = double.tryParse(cleaned);
    if (parsed == null || parsed.isNaN || parsed.isInfinite) return null;
    return parsed;
  }

  /// Parses a quantity, where the dot is a decimal separator.
  ///
  /// Quantities are typed without thousand separators, so a single dot
  /// always means "decimal" here.
  static double? tryParseQuantity(String raw) {
    var cleaned = raw.trim().replaceAll(',', '.');
    cleaned = cleaned.replaceAll(RegExp(r'[^0-9.\-]'), '');
    if (cleaned.isEmpty) return null;
    final parsed = double.tryParse(cleaned);
    if (parsed == null || parsed.isNaN || parsed.isInfinite) return null;
    return parsed;
  }
}
