import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/authentication/models/jwt-user.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';

class PermissionsCar {
  static final String SELL_CAR = 'SELL_CARS';
  static final String RENT_CAR = 'RENT_CARS';
  static final String MANAGE_CARS = 'MANAGE_CARS';
  static final String VIEW_CAR_TECHNICAL_DOCUMENTATION = 'VIEW_CAR_TECHNICAL_DOCUMENTATION';
  static final String VIEW_CAR_HISTORY = 'VIEW_CAR_HISTORY';

  Map<String, List<String>> permissionsMap = Map();

  PermissionsCar(JwtUser jwtUser, ServiceProviderItemsResponse serviceProviderItemsResponse) {
    for (String role in Roles.roles) {
      List<String> permissions = List<String>();
      permissions.addAll(jwtUser.permissions);

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
            for (ServiceProviderItem item
                in serviceProviderItemsResponse.items) {
              ConsultantServiceType serviceType =
                  ConsultantServiceTypeUtils.serviceTypeFromString(item.name);

              if (serviceType != null) {
                switch (serviceType) {
                  case ConsultantServiceType.Sell:
                    break;
                  case ConsultantServiceType.Rent:
                    break;
                  default:
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
