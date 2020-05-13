import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/shared/managers/permissions-manager.dart';

class PermissionsSideBar {
  List<ConsultantServiceType> profilePermissions = [
    ConsultantServiceType.Service,
    ConsultantServiceType.PartShop,
    ConsultantServiceType.DismantlingShop
  ];
  List<ConsultantServiceType> appointmentPermissions = [
    ConsultantServiceType.Service
  ];
  List<ConsultantServiceType> auctionPermissions = [
    ConsultantServiceType.Service,
    ConsultantServiceType.PartShop,
    ConsultantServiceType.DismantlingShop
  ];
  List<ConsultantServiceType> workEstimatePermissions = [
    ConsultantServiceType.Service
  ];
  List<ConsultantServiceType> notificationPermissions = [
    ConsultantServiceType.Service,
    ConsultantServiceType.PartShop,
    ConsultantServiceType.DismantlingShop
  ];

  bool consultantHasAccess(ServiceProviderItemsResponse serviceItemResponse,
      ConsultantSideBarPermission permission) {
    if (serviceItemResponse != null) {
      switch (permission) {
        case ConsultantSideBarPermission.UserProfile:
          return true;
        case ConsultantSideBarPermission.Appointments:
          return serviceItemResponse
              .containsServiceType(appointmentPermissions);
          break;
        case ConsultantSideBarPermission.Auctions:
          return serviceItemResponse.containsServiceType(auctionPermissions);
          break;
        case ConsultantSideBarPermission.WorkEstimates:
          return serviceItemResponse
              .containsServiceType(workEstimatePermissions);
          break;
        case ConsultantSideBarPermission.Notifications:
          return serviceItemResponse
              .containsServiceType(notificationPermissions);
          break;
      }
    }

    return false;
  }
}

enum ConsultantSideBarPermission {
  UserProfile,
  Appointments,
  Auctions,
  WorkEstimates,
  Notifications
}
