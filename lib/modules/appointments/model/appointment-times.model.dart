import 'package:app/utils/date_utils.dart';

class AppointmentTimes {
  DateTime pickupDateTime;
  DateTime returnDateTime;

  AppointmentTimes({this.pickupDateTime, this.returnDateTime});

  factory AppointmentTimes.fromJson(Map<String, dynamic> json) {
    return AppointmentTimes(
        pickupDateTime: json['pickupDateTime'] != null
            ? DateUtils.dateFromString(
                json['pickupDateTime'], 'dd/MM/yyyy HH:mm')
            : '',
        returnDateTime: json['returnDateTime'] != null
            ? DateUtils.dateFromString(
                json['returnDateTime'], 'dd/MM/yyyy HH:mm')
            : '');
  }
}
