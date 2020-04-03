import 'package:app/modules/appointments/model/provider/service-provider-sub-item.model.dart';

class ServiceProviderItem {
  int id;
  String name;
  double rate;
  List<ServiceProviderSubItem> items;

  ServiceProviderItem({this.id, this.name, this.rate, this.items});

  factory ServiceProviderItem.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> serviceMap = json['service'];

    return ServiceProviderItem(
        id: serviceMap['id'],
        name: serviceMap['name'],
        rate: json['rate'],
        items: _mapItems(json['subServices']));
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'id': id,
      'name': name,
      'rate': rate,
    };

    return propMap;
  }

  static List<ServiceProviderSubItem> _mapItems(List<dynamic> list) {
    List<ServiceProviderSubItem> items = [];

    if (list != null) {
      list.forEach((item) {
        items.add(ServiceProviderSubItem.fromJson(item));
      });
    }

    return items;
  }
}
