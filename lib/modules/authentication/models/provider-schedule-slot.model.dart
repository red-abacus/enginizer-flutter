class ProviderScheduleSlot {
  String startTime;
  String endTime;

  ProviderScheduleSlot({this.startTime, this.endTime});

  factory ProviderScheduleSlot.fromJson(Map<String, dynamic> json) {
    return ProviderScheduleSlot();
    // TODO
//        startTime: json['startTime'], endTime: json['endTime']);
  }
}
