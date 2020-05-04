import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/provider/service-provider-sub-item.model.dart';
import 'package:flutter/cupertino.dart';

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

  String getTranslatedServiceName(BuildContext context) {
    switch (name) {
      case 'SERVICE':
        return S.of(context).SERVICE;
      case 'CAR_WASHING':
        return S.of(context).CAR_WASHING;
      case 'PAINT_SHOP':
        return S.of(context).PAINT_SHOP;
      case 'TIRE_SHOP':
        return S.of(context).TIRE_SHOP;
      case 'TOW_SERVICE':
        return S.of(context).TOW_SERVICE;
      case 'PICKUP_RETURN':
        return S.of(context).PICKUP_RETURN;
      case 'TINWARE_SHOP':
        return S.of(context).TINWARE_SHOP;
      case 'ITP_SERVICE':
        return S.of(context).ITP_SERVICE;
      case 'TENANCY_SERVICE':
        return S.of(context).TENANCY_SERVICE;
      default:
        return name;
    }
  }
}
