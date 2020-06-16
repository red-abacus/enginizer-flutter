import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';

class PermissionsCar {
  static final String CREATE_CAR_EXTRA = 'CAR.CREATE_CAR_EXTRA';
  static final String APPOINTMENT_CAR = 'CAR.APPOINTMENT_CAR';
  static final String SELL_CAR = 'CAR.SELL_CAR';
  static final String RENT_CAR = 'CAR.RENT_CAR';

  Map<String, List<String>> permissionsMap = Map();

  PermissionsCar(ServiceProviderItemsResponse serviceProviderItemsResponse) {
    for (String role in Roles.roles) {
      List<String> permissions = [];

      switch (role) {
        case Roles.Super:
          break;
        case Roles.Client:
          permissions = [APPOINTMENT_CAR, SELL_CAR];
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
                    permissions.add(CREATE_CAR_EXTRA);
                    permissions.add(SELL_CAR);
                    break;
                  case ConsultantServiceType.Rent:
                    permissions.add(CREATE_CAR_EXTRA);
                    permissions.add(RENT_CAR);
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
