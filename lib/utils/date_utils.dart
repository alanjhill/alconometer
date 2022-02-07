class DateUtils {
  static DateTime get today => DateTime.now().toUtc();

  static DateTime get yesterday => DateTime.now().toUtc().subtract(const Duration(days: 1));

  static DateTime daysAgo(int days) => DateTime.now().toUtc().subtract(Duration(days: days));

  static DateTime mostRecentSunday(DateTime date) => DateTime(date.year, date.month, date.day - date.weekday % 7);

  static DateTime mostRecentMonday(DateTime date) => DateTime(date.year, date.month, date.day - (date.weekday - 1));
}
