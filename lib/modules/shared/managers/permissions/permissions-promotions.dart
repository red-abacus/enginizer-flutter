import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';

class PermissionsPromotion {
  static final String CREATE_PROMOTION = 'MANAGE_PROMOTIONS';
  static final String SELLER_PROMOTION = 'PROMOTION.SELLER_PROMOTION'; // TODO

  Map<String, List<String>> permissionsMap = Map();
  Map<String, List<String>> serviceItemsPermissionsMap = Map();

  PermissionsPromotion(ServiceProviderItemsResponse serviceProviderItemsResponse) {
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
                    break;
                  case ConsultantServiceType.PartShop:
                    break;
                  case ConsultantServiceType.DismantlingShop:
                    break;
                  case ConsultantServiceType.Sell:
                    permissions = [SELLER_PROMOTION];
                    break;
                  case ConsultantServiceType.Rent:
                    break;
                  case ConsultantServiceType.Painter:
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
