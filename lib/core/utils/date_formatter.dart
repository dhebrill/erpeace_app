import 'package:intl/intl.dart';

/// Date helpers using the Indonesian (`id_ID`) locale.
abstract final class DateFormatter {
  const DateFormatter._();

  static const String locale = 'id_ID';

  static final DateFormat _date = DateFormat('d MMM yyyy', locale);
  static final DateFormat _dateTime = DateFormat('d MMM yyyy, HH:mm', locale);
  static final DateFormat _dayMonth = DateFormat('d MMM', locale);
  static final DateFormat _monthYear = DateFormat('MMMM yyyy', locale);
  static final DateFormat _isoDate = DateFormat('yyyy-MM-dd', locale);
  static final DateFormat _time = DateFormat('HH:mm', locale);

  static String date(DateTime value) => _date.format(value.toLocal());

  static String dateTime(DateTime value) => _dateTime.format(value.toLocal());

  static String dayMonth(DateTime value) => _dayMonth.format(value.toLocal());

  static String monthYear(DateTime value) => _monthYear.format(value.toLocal());

  static String isoDate(DateTime value) => _isoDate.format(value.toLocal());

  static String time(DateTime value) => _time.format(value.toLocal());

  /// `Hari ini`, `Kemarin` or a formatted date.
  static String relativeDay(DateTime value) {
    final now = DateTime.now();
    final local = value.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(local.year, local.month, local.day);
    final diff = today.difference(target).inDays;
    if (diff == 0) return 'Hari ini';
    if (diff == 1) return 'Kemarin';
    if (diff == -1) return 'Besok';
    return date(local);
  }

  /// `3 jam lalu`, `2 hari lalu`, ...
  static String relativeTime(DateTime value) {
    final diff = DateTime.now().difference(value.toLocal());
    if (diff.inSeconds < 60) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 30) return '${diff.inDays} hari lalu';
    return date(value);
  }
}
