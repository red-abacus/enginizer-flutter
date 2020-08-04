import 'dart:collection';

import 'package:app/utils/date_utils.dart';

class MechanicWorkEstimatePeriod {
  static const String timeFormat = 'dd-MM-yyyy HH:mm:ss';

  DateTime startDate;
  DateTime endDate;

  MechanicWorkEstimatePeriod({this.startDate, this.endDate});

  factory MechanicWorkEstimatePeriod.fromJson(Map<String, dynamic> json) {
    return MechanicWorkEstimatePeriod(
        startDate: DateUtils.dateFromString(json['start_date'], timeFormat),
        endDate: json['end_date'] != null
            ? DateUtils.dateFromString(json['end_date'], timeFormat)
            : null);
  }

  HashMap<String, dynamic> toJson() {
    HashMap<String, dynamic> map = new HashMap();
    map['start_date'] = DateUtils.stringFromDate(startDate, timeFormat);

    if (endDate != null) {
      map['end_date'] = DateUtils.stringFromDate(endDate, timeFormat);
    }
    return map;
  }

  int period() {
    if (startDate != null && endDate != null) {
      return endDate.difference(startDate).inSeconds;
    }
    else {
      return DateTime.now().difference(startDate).inSeconds;
    }
  }
}
