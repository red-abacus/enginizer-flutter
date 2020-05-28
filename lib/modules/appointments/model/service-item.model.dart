import 'package:app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

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
      case 'RENT_SERVICE':
        return S.of(context).RENT_SERVICE;
      default:
        return name;
    }
  }

  bool isPickUpAndReturnService() {
    return name == 'PICKUP_RETURN';
  }

  bool isTowService() {
    return name == 'TOW_SERVICE';
  }
}
