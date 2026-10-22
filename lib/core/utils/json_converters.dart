/// Helpers used by `json_serializable` to safely convert dynamic values.
library;

/// Converts a dynamic JSON value into a `double`.
double jsonToDouble(Object? value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

/// Converts a `double` into a JSON friendly number.
double doubleToJson(double value) => value;

/// Converts a dynamic JSON value into an `int`.
int jsonToInt(Object? value) {
  if (value == null) return 0;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

/// Converts an `int` into a JSON friendly number.
int intToJson(int value) => value;

/// Converts a dynamic JSON value into a nullable `DateTime`.
DateTime? jsonToDateTime(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}

/// Converts a nullable `DateTime` into a JSON friendly value.
String? dateTimeToJson(DateTime? value) => value?.toIso8601String();
