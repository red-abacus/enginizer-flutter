import 'package:enginizer_flutter/modules/appointments/model/service-item.model.dart';

class ProviderServiceResponse {
  int totalPages;
  int total;
  List<ServiceItem> items;

  ProviderServiceResponse({this.total, this.totalPages, this.items});

  factory ProviderServiceResponse.fromJson(Map<String, dynamic> json) {
    return ProviderServiceResponse(
        total: json['total'],
        totalPages: json['totalPages'],
        items: _mapProviderServices(json['items']));
  }

  static _mapProviderServices(List<dynamic> response) {
    List<ServiceItem> providerServices = [];
    response.forEach((item) {
      providerServices.add(ServiceItem.fromJson(item));
    });
    return providerServices;
  }
}
