class UserProviderScheduleSlot {
  String startTime;
  String endTime;

  UserProviderScheduleSlot({this.startTime, this.endTime});

  factory UserProviderScheduleSlot.fromJson(Map<String, dynamic> json) {
    return UserProviderScheduleSlot(
        startTime: json['startTime'], endTime: json['endTime']);
  }
}
