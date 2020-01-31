class AppointmentStatus {
  int id;
  String name;

  AppointmentStatus(status) {
    if (status is String) {
      this.name = status;
    } else {
      this.id = status.id;
      this.name = status.name;
    }
  }

  factory AppointmentStatus.fromJson(dynamic json) {
    return AppointmentStatus(json);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {'name': name};

    if (id != null) {
      propMap.putIfAbsent('id', () => id);
    }

    return propMap;
  }
}
