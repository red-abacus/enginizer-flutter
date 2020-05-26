import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';

class PermissionAppointmentsStatuses {
  List<ConsultantServiceType> partsPermissions = [
    ConsultantServiceType.PartShop,
    ConsultantServiceType.DismantlingShop
  ];

  bool consultantHasAccess(
      ServiceProviderItemsResponse serviceProviderItemsResponse,
      AppointmentStatusesPermission permission) {
    if (serviceProviderItemsResponse != null) {
      switch (permission) {
        case AppointmentStatusesPermission.PartsStatuses:
          return serviceProviderItemsResponse
              .containsServiceType(partsPermissions);
        default:
          break;
      }
    }

    return false;
  }
}

enum AppointmentStatusesPermission { PartsStatuses }
