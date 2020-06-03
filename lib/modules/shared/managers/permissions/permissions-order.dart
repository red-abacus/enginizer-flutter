import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';

class PermissionsOrder {
  static final String CREATE_ORDER = 'CREATE_ORDER';
  static final String VIEW_ORDER = 'VIEW_ORDER';

  Map<String, List<String>> permissionsMap = Map();
  Map<String, List<String>> serviceItemsPermissionsMap = Map();

  PermissionsOrder(ServiceProviderItemsResponse serviceProviderItemsResponse) {
    for (String role in Roles.roles) {
      List<String> permissions = [];

      switch (role) {
        case Roles.Super:
          break;
        case Roles.Client:
          break;
        case Roles.ProviderAccountant:
          break;
        case Roles.ProviderPersonnel:
          break;
        case Roles.ProviderConsultant:
          if (serviceProviderItemsResponse != null) {
            for(ServiceProviderItem item in serviceProviderItemsResponse.items) {
              ConsultantServiceType serviceType = ConsultantServiceTypeUtils.serviceTypeFromString(item.name);

              if (serviceType != null) {
                switch (serviceType) {
                  case ConsultantServiceType.PickUpAndReturn:
                    break;
                  case ConsultantServiceType.Service:
                    permissions.add(VIEW_ORDER);
                    break;
                  case ConsultantServiceType.PartShop:
                    permissions.add(CREATE_ORDER);
                    break;
                  case ConsultantServiceType.DismantlingShop:
                    permissions.add(CREATE_ORDER);
                    break;
                }
              }
            }
          }
          break;
        case Roles.ProviderAdmin:
          break;
      }

      permissionsMap[role] = permissions;
    }
  }

  bool hasAccess(String userRole, String permission) {
    return permissionsMap[userRole].contains(permission);
  }
}

enum OrderPermission {
  Order
}
