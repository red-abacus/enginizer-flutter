import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/authentication/models/jwt-user.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';

class PermissionsCar {
  static final String CREATE_CAR_EXTRA = 'CAR.CREATE_CAR_EXTRA'; // TODO
  static final String APPOINTMENT_CAR = 'CAR.APPOINTMENT_CAR'; // TODO
  static final String SELL_CAR = 'SELL_CARS';
  static final String RENT_CAR = 'RENT_CARS';

  Map<String, List<String>> permissionsMap = Map();

  PermissionsCar(JwtUser jwtUser, ServiceProviderItemsResponse serviceProviderItemsResponse) {
    for (String role in Roles.roles) {
      List<String> permissions = List<String>();
      permissions.addAll(jwtUser.permissions);

      switch (role) {
        case Roles.Super:
          break;
        case Roles.Client:
          permissions.addAll([APPOINTMENT_CAR, CREATE_CAR_EXTRA, RENT_CAR, SELL_CAR]);
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
