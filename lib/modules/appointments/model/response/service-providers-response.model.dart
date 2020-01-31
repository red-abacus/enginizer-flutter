import 'package:enginizer_flutter/modules/appointments/model/service-provider.model.dart';

class ServiceProviderResponse {
  int totalPages;
  int total;
  List<ServiceProvider> items;

  ServiceProviderResponse({this.total, this.totalPages, this.items});

  factory ServiceProviderResponse.fromJson(Map<String, dynamic> json) {
    return ServiceProviderResponse(
        total: json['total'],
        totalPages: json['totalPages'],
        items: _mapProviders(json['items']));
  }

  static _mapProviders(List<dynamic> response) {
    List<ServiceProvider> providerServices = [];
    response.forEach((item) {
      providerServices.add(ServiceProvider.fromJson(item));
    });
    return providerServices;
  }
}
