class ServiceItem {
  int id;
  String name;

  ServiceItem({this.id, this.name});

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'id': id,
      'name': name,
    };

    return propMap;
  }
}
