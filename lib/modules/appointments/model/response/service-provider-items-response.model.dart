import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';

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

  bool containsServiceType(List<ConsultantServiceType> consultantServiceType) {
    for (ServiceProviderItem item in items) {
      ConsultantServiceType serviceType =
          ConsultantServiceTypeUtils.serviceTypeFromString(item.name);

      if (consultantServiceType.contains(serviceType)) {
        return true;
      }
    }

    return false;
  }
}
