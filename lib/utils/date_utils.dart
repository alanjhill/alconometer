class DateUtils {
  static DateTime get today => DateTime.now();
  static DateTime get yesterday => DateTime.now().subtract(const Duration(days: 1));
  static DateTime daysAgo(int days) => DateTime.now().subtract(Duration(days: days));
}
