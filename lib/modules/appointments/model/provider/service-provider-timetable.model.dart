class ServiceProviderTimetable {
  String localDate;
  String hour;
  String slotStatus;
  int id;

  ServiceProviderTimetable({this.localDate, this.hour, this.slotStatus, this.id});

  factory ServiceProviderTimetable.fromJson(Map<String, dynamic> json, String localDate) {
    return ServiceProviderTimetable(
      localDate: localDate,
      hour: json["hour"] != null ? json["hour"] : "",
      slotStatus: json["slotStatus"] != null ? json["slotStatus"] : "",
      id: json["id"] != null ? json["hour"] : 0
    );
  }

  String date() {
    return "$localDate $hour";
  }
}
