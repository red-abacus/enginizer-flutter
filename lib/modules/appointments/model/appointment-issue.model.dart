class AppointmentIssue {
  int id;
  String name;

  AppointmentIssue({this.id, this.name});

  factory AppointmentIssue.fromJson(Map<String, dynamic> json) {
    return AppointmentIssue(id: json["id"], name: json["name"]);
  }
}
