class ProviderScheduleSlot {
  String startTime;
  String endTime;

  ProviderScheduleSlot({this.startTime, this.endTime});

  factory ProviderScheduleSlot.fromJson(Map<String, dynamic> json) {
    return ProviderScheduleSlot(
        startTime: json['startTime'], endTime: json['endTime']);
  }
}
