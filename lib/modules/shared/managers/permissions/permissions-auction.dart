import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';

class PermissionsAuction {
  List<ConsultantServiceType> appointmentDetailsPermissions = [
    ConsultantServiceType.Service,
  ];
  List<ConsultantServiceType> carDetailsPermissions = [
    ConsultantServiceType.PartShop,
    ConsultantServiceType.DismantlingShop
  ];
  List<ConsultantServiceType> createWorkEstimatePermissions = [
    ConsultantServiceType.Service,
    ConsultantServiceType.PartShop,
    ConsultantServiceType.DismantlingShop
  ];
  List<ConsultantServiceType> createPartWorkEstimatePermission = [
    ConsultantServiceType.Service
  ];

  bool consultantHasAccess(
      ServiceProviderItemsResponse serviceProviderItemsResponse,
      AuctionPermission permission) {
    if (serviceProviderItemsResponse != null) {
      switch (permission) {
        case AuctionPermission.ConsultantAuctionDetails:
          return true;
        case AuctionPermission.AppointmentDetails:
          return serviceProviderItemsResponse
              .containsServiceType(appointmentDetailsPermissions);
        case AuctionPermission.CreateWorkEstimate:
          return serviceProviderItemsResponse
              .containsServiceType(carDetailsPermissions);
          break;
        case AuctionPermission.CarDetails:
          return serviceProviderItemsResponse
              .containsServiceType(createWorkEstimatePermissions);
          break;
        case AuctionPermission.CreatePartWorkEstimate:
          return serviceProviderItemsResponse
              .containsServiceType(createPartWorkEstimatePermission);
          break;
        default:
          break;
      }
    }

    return false;
  }
}

enum AuctionPermission {
  AuctionDetails,
  ConsultantAuctionDetails,
  AppointmentDetails,
  CarDetails,
  CreateWorkEstimate,
  CreatePartWorkEstimate
}
