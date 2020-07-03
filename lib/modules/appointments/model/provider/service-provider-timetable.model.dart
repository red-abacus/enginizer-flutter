import 'package:app/modules/appointments/enum/service-provider-timetable-status.enum.dart';

class ServiceProviderTimetable {
  String localDate;
  String hour;
  ServiceProviderTimetableStatus status;
  int id;

  ServiceProviderTimetable({this.localDate, this.hour, this.status, this.id});

  factory ServiceProviderTimetable.fromJson(
      Map<String, dynamic> json, String localDate) {
    return ServiceProviderTimetable(
        localDate: localDate,
        hour: json["hour"] != null ? json["hour"] : "",
        status: json["slotStatus"] != null
            ? ServiceProviderTimetableStatusUtils.status(json["slotStatus"])
            : null,
        id: json["id"] != null ? json["hour"] : 0);
  }

  String date() {
    return "$localDate $hour";
  }
}
