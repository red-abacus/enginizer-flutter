import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-item.dart';

class ServiceProviderItemsResponse {
  int totalPages;
  int total;
  List<ServiceProviderItem> items;

  ServiceProviderItemsResponse({this.total, this.totalPages, this.items});

  factory ServiceProviderItemsResponse.fromJson(Map<String, dynamic> json) {
    return ServiceProviderItemsResponse(
        total: json['total'],
        totalPages: json['totalPages'],
        items: _mapProviderServices(json['items']));
  }

  static _mapProviderServices(List<dynamic> response) {
    List<ServiceProviderItem> items = [];
    response.forEach((item) {
      items.add(ServiceProviderItem.fromJson(item));
    });
    return items;
  }
}