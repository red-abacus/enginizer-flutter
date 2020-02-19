class EmployeeTimeSerie {
  String time;
  String status;

  EmployeeTimeSerie({this.time, this.status});

  factory EmployeeTimeSerie.fromJson(Map<String, dynamic> json) {
    return EmployeeTimeSerie(
        time: json['time'] != null ? json['time'] : "",
        status: json['status'] != null ? json["status"] : "");
  }
}
