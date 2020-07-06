import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';

class PermissionAppointmentsStatuses {
  static final String ALL_STATUSES = 'APPOINTMENT_STATUSES.ALL_PERMISSIONS'; // TODO
  static final String PARTS_STATUSES = 'APPOINTMENT_STATUSES.PARTS_STATUSES'; // TODO
  static final String PERSONNEL_STATUSES =
      'APPOINTMENT_STATUSES.PERSONNEL_STATUSES'; // TODO
  static final String PR_STATUSES = 'APPOINTMENT_STATUSES.PR_STATUSES'; // TODO

  Map<String, List<String>> permissionsMap = Map();
  Map<String, List<String>> serviceItemsPermissionsMap = Map();

  PermissionAppointmentsStatuses(
      ServiceProviderItemsResponse serviceProviderItemsResponse) {
    for (String role in Roles.roles) {
      List<String> permissions = [];

      switch (role) {
        case Roles.Super:
          break;
        case Roles.Client:
          permissions = [ALL_STATUSES];
          break;
        case Roles.ProviderAccountant:
          break;
        case Roles.ProviderPersonnel:
          permissions = [PERSONNEL_STATUSES];
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
                    permissions.add(PR_STATUSES);
                    break;
                  case ConsultantServiceType.Service:
                  case ConsultantServiceType.Painter:
                    permissions.add(ALL_STATUSES);
                    break;
                  case ConsultantServiceType.PartShop:
                    permissions.add(PARTS_STATUSES);
                    break;
                  case ConsultantServiceType.DismantlingShop:
                    permissions.add(PARTS_STATUSES);
                    break;
                  case ConsultantServiceType.Sell:
                    break;
                  case ConsultantServiceType.Rent:
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
