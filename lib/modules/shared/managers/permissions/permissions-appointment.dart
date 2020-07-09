import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/authentication/models/jwt-user.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';

class PermissionsAppointment {
  static final String CREATE_APPOINTMENT = 'CREATE_APPOINTMENTS';
  static final String SHARE_APPOINTMENT_LOCATION =
      'APPOINTMENT.SHARE_APPOINTMENT_LOCATION'; // TODO
  static final String MANAGE_APPOINTMENTS = 'MANAGE_APPOINTMENTS';
  static final String EXECUTE_APPOINTMENTS = 'EXECUTE_APPOINTMENTS';
  static final String EXECUTE_RECEIVE_CAR_PROCEDURE = 'EXECUTE_RECEIVE_CAR_PROCEDURE';
  static final String EXECUTE_RETURN_CAR_PROCEDURE = 'EXECUTE_RETURN_CAR_PROCEDURE';
  static final String MANAGE_WORK_ESTIMATES = 'MANAGE_WORK_ESTIMATES';
  static final String WORK_ESTIMATE_IMPORT_PARTS = 'WORK_ESTIMATE_IMPORT_PARTS';

  Map<String, List<String>> permissionsMap = Map();

  PermissionsAppointment(JwtUser user,
      ServiceProviderItemsResponse serviceProviderItemsResponse) {
    for (String role in Roles.roles) {
      List<String> permissions = List<String>();
      permissions.addAll(user.permissions);

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
                  case ConsultantServiceType.PickUpAndReturn:
                    permissions.add(SHARE_APPOINTMENT_LOCATION);
                    break;
                  case ConsultantServiceType.Service:
                    break;
                  case ConsultantServiceType.PartShop:
                    break;
                  case ConsultantServiceType.DismantlingShop:
                    break;
                  case ConsultantServiceType.Sell:
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
