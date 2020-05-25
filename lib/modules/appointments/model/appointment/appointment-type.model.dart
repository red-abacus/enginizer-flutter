class AppointmentType {
  int id;
  String name;

  AppointmentType({this.id, this.name});

  factory AppointmentType.fromJson(Map<String, dynamic> json) {
    return AppointmentType(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {'name': name};

    if (id != null) {
      propMap.putIfAbsent('id', () => id);
    }

    return propMap;
  }
}
