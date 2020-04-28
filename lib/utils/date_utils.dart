import 'package:intl/intl.dart';

class DateUtils {
  static DateTime firstDayOfWeek(DateTime date) {
    return date.subtract(new Duration(days: date.weekday));
  }

  static DateTime lastDayOfWeek(DateTime date) {
    return date.add(new Duration(days: date.weekday));
  }

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 0);
  }

  static DateTime addDayToDate(DateTime date, int days) {
    return date.add(new Duration(days: days));
  }

  static DateTime addHourToDate(DateTime date, int hour) {
    return date.add(new Duration(hours: hour));
  }

  static DateTime addMinutesToDate(DateTime date, int minutes) {
    return date.add(new Duration(minutes: minutes));
  }

  static String getWeekDayName(DateTime date) {
    String formattedDate = DateFormat('EEE').format(date);
    return formattedDate;
  }

  static DateTime dateFromString(String dateString, String format) {
    try {
      return DateFormat(format).parse(dateString);
    }
    catch (_) {
      return null;
    }
  }

  static String stringFromDate(DateTime date, String format) {
    try {
      return DateFormat(format).format(date);
    }
    catch (_) {
      return '';
    }
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return DateUtils.stringFromDate(date1, "dd-MM-yyyy") ==
        DateUtils.stringFromDate(date2, "dd-MM-yyyy");
  }
}
