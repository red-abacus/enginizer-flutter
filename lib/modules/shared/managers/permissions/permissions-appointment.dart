import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';

class PermissionsAppointment {
  static final String VIEW_APPOINTMENT_DETAILS_CLIENT = 'APPOINTMENT.VIEW_APPOINTMENT_DETAILS_CLIENT';
  static final String VIEW_APPOINTMENT_DETAILS_SERVICE_PROVIDER = 'APPOINTMENT.SERVICE_PROVIDER';
  static final String VIEW_APPOINTMENT_DETAILS_PERSONNEL = 'APPOINTMENT.VIEW_APPOINTMENT_DETAILS_PERSONNEL';
  static final String VIEW_APPOINTMENT_DETAILS_PR = 'APPOINTMENT.VIEW_APPOINTMENT_DETAILS_PR';
  static final String CREATE_APPOINTMENT = 'APPOINTMENT.CREATE_APPOINTMENT';

  Map<String, List<String>> permissionsMap = Map();

  PermissionsAppointment(ServiceProviderItemsResponse serviceProviderItemsResponse) {
    for (String role in Roles.roles) {
      List<String> permissions = [];

      switch (role) {
        case Roles.Super:
          break;
        case Roles.Client:
          permissions = [CREATE_APPOINTMENT, VIEW_APPOINTMENT_DETAILS_CLIENT];
          break;
        case Roles.ProviderAccountant:
          break;
        case Roles.ProviderPersonnel:
          permissions = [VIEW_APPOINTMENT_DETAILS_PERSONNEL];
          break;
        case Roles.ProviderConsultant:
          if (serviceProviderItemsResponse != null) {
            for(ServiceProviderItem item in serviceProviderItemsResponse.items) {
              ConsultantServiceType serviceType = ConsultantServiceTypeUtils.serviceTypeFromString(item.name);

              if (serviceType != null) {
                switch (serviceType) {
                  case ConsultantServiceType.PickUpAndReturn:
                    permissions.add(VIEW_APPOINTMENT_DETAILS_PR);
                    break;
                  case ConsultantServiceType.Service:
                    permissions.add(VIEW_APPOINTMENT_DETAILS_SERVICE_PROVIDER);
                    break;
                  case ConsultantServiceType.PartShop:
                    break;
                  case ConsultantServiceType.DismantlingShop:
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
