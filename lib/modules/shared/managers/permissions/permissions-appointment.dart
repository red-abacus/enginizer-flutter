import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/authentication/models/jwt-user.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';

class PermissionsAppointment {
  static final String VIEW_APPOINTMENT_DETAILS_CLIENT =
      'APPOINTMENT.VIEW_APPOINTMENT_DETAILS_CLIENT'; // TODO
  static final String VIEW_APPOINTMENT_DETAILS_SERVICE_PROVIDER =
      'APPOINTMENT.SERVICE_PROVIDER'; // TODO
  static final String VIEW_APPOINTMENT_DETAILS_PERSONNEL =
      'APPOINTMENT.VIEW_APPOINTMENT_DETAILS_PERSONNEL'; // TODO
  static final String VIEW_APPOINTMENT_DETAILS_PR =
      'APPOINTMENT.VIEW_APPOINTMENT_DETAILS_PR'; // TODO
  static final String CREATE_APPOINTMENT = 'CREATE_APPOINTMENTS';
  static final String SHARE_APPOINTMENT_LOCATION =
      'APPOINTMENT.SHARE_APPOINTMENT_LOCATION'; // TODO

  Map<String, List<String>> permissionsMap = Map();

  PermissionsAppointment(JwtUser user,
      ServiceProviderItemsResponse serviceProviderItemsResponse) {
    for (String role in Roles.roles) {
      List<String> permissions = user.permissions;

      switch (role) {
        case Roles.Super:
          break;
        case Roles.Client:
          permissions = [VIEW_APPOINTMENT_DETAILS_CLIENT];
          break;
        case Roles.ProviderAccountant:
          break;
        case Roles.ProviderPersonnel:
          permissions = [VIEW_APPOINTMENT_DETAILS_PERSONNEL];
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
                    permissions.add(VIEW_APPOINTMENT_DETAILS_PR);
                    permissions.add(SHARE_APPOINTMENT_LOCATION);
                    break;
                  case ConsultantServiceType.Service:
                    permissions.add(VIEW_APPOINTMENT_DETAILS_SERVICE_PROVIDER);
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
