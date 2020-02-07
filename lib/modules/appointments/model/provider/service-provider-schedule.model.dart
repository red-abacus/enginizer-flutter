class ServiceProviderSchedule {
  int id;
  String dayOfWeek;
  String startTime;
  String endTime;

  ServiceProviderSchedule(
      {this.id,
        this.dayOfWeek,
        this.startTime,
        this.endTime});

  factory ServiceProviderSchedule.fromJson(Map<String, dynamic> json) {
    return ServiceProviderSchedule(
        id: json['id'],
        dayOfWeek: json['dayOfWeek'],
        startTime: json['startTime'],
        endTime: json['endTime']
    );
  }
}