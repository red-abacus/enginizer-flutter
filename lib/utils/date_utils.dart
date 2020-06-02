import 'package:app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
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

  static DateTime addSecondsToDate(DateTime date, int seconds) {
    return date.add(new Duration(seconds: seconds));
  }

  static String getWeekDayName(DateTime date) {
    String formattedDate = DateFormat('EEE').format(date);
    return formattedDate;
  }

  static DateTime dateFromTimestamp(int timestamp) {
    return new DateTime.fromMillisecondsSinceEpoch(timestamp);
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

  static String periodFromDate(BuildContext context, DateTime dateTime) {
    Duration duration = DateTime.now().difference(dateTime);
    if (duration.inMinutes < 1) {
      return S.of(context).general_just_now;
    }

    if (duration.inMinutes == 1) {
      return '${duration.inMinutes} ${S.of(context).general_minute_ago}';
    }

    if (duration.inMinutes < 60) {
      return '${duration.inMinutes} ${S.of(context).general_minutes_ago}';
    }

    if (duration.inHours == 1) {
      return '${duration.inHours} ${S.of(context).general_hour_ago}';
    }

    if (duration.inHours < 24) {
      return '${duration.inHours} ${S.of(context).general_hours_ago}';
    }

    if (duration.inDays == 1) {
      return '${duration.inDays} ${S.of(context).general_day_ago}';
    }

    if (duration.inDays <= 14) {
      return '${duration.inDays} ${S.of(context).general_days_ago}';
    }

    return DateUtils.stringFromDate(dateTime, 'dd-MM-yyyy HH:mm');
  }
}
