class ServiceProviderItem {
  int id;
  String name;
  double rate;

  ServiceProviderItem(
      {this.id,
        this.name,
        this.rate});

  factory ServiceProviderItem.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> serviceMap = json['service'];

    return ServiceProviderItem(
        id: serviceMap['id'],
        name: serviceMap['name'],
        rate: json['rate']
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'id': id,
      'name': name,
      'rate': rate,
    };

    return propMap;
  }
}