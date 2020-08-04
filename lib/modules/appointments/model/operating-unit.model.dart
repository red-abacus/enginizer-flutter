class OperatingUnit {
  int id;
  String name;

  OperatingUnit({this.id, this.name});

  factory OperatingUnit.fromJson(Map<String, dynamic> json) {
    return OperatingUnit(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {'name': name};

    if (id != null) {
      propMap.putIfAbsent('id', () => id);
    }

    return propMap;
  }
}
