class ServiceProviderSubItem {
  int id;
  String name;

  ServiceProviderSubItem({this.id, this.name});

  factory ServiceProviderSubItem.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> serviceMap = json['service'];

    return ServiceProviderSubItem(
        id: serviceMap['id'], name: serviceMap['name']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {'id': id, 'name': name};

    return propMap;
  }
}
