/// Small date formatting helpers (English only, no extra package needed).
abstract final class AppDateFormat {
  static const List<String> _weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];
  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  /// "Sunday, 22 November"
  static String weekdayDayMonth(DateTime date) =>
      '${_weekdays[date.weekday - 1]}, ${date.day} ${_months[date.month - 1]}';

  /// "8 Nov 2026"
  static String shortDate(DateTime date) =>
      '${date.day} ${_months[date.month - 1].substring(0, 3)} ${date.year}';

  /// "Good morning" / "Good afternoon" / "Good evening"
  static String greeting(DateTime now) {
    if (now.hour < 12) return 'Good morning';
    if (now.hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  /// Whole years between [date] and [now].
  static int yearsAgo(DateTime date, DateTime now) {
    var years = now.year - date.year;
    if (now.month < date.month || (now.month == date.month && now.day < date.day)) years--;
    return years < 0 ? 0 : years;
  }
}
