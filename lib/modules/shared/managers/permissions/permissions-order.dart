import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';

class PermissionsOrder {
  List<ConsultantServiceType> orderPermission = [
    ConsultantServiceType.PartShop,
    ConsultantServiceType.DismantlingShop,
  ];

  bool consultantHasAccess(
      ServiceProviderItemsResponse serviceProviderItemsResponse,
      OrderPermission permission) {
    if (serviceProviderItemsResponse != null) {
      switch (permission) {
        case OrderPermission.Order:
          return serviceProviderItemsResponse.containsServiceType(orderPermission);
        default:
          break;
      }
    }

    return false;
  }
}

enum OrderPermission {
  Order
}
