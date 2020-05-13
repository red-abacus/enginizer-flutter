import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/authentication/models/jwt-user-details.model.dart';
import 'package:app/modules/shared/managers/permissions-manager.dart';

class PermissionsAuction {
  List<ConsultantServiceType> appointmentDetailsPermissions = [
    ConsultantServiceType.Service,
    ConsultantServiceType.PartShop,
    ConsultantServiceType.DismantlingShop
  ];
  List<ConsultantServiceType> carDetailsPermissions = [
    ConsultantServiceType.Service
  ];
  List<ConsultantServiceType> createWorkEstimatePermissions = [
    ConsultantServiceType.Service,
    ConsultantServiceType.PartShop,
    ConsultantServiceType.DismantlingShop
  ];
  List<ConsultantServiceType> createPartWorkEstimatePermission = [
    ConsultantServiceType.Service
  ];

  bool consultantHasAccess(ServiceProviderItemsResponse serviceProviderItemsResponse,
      ConsultantAuctionPermission permission) {
    if (serviceProviderItemsResponse != null) {
      switch (permission) {
        case ConsultantAuctionPermission.AppointmentDetails:
          return serviceProviderItemsResponse.containsServiceType(
              appointmentDetailsPermissions);
        case ConsultantAuctionPermission.CreateWorkEstimate:
          return serviceProviderItemsResponse
              .containsServiceType(carDetailsPermissions);
          break;
        case ConsultantAuctionPermission.CarDetails:
          return serviceProviderItemsResponse
              .containsServiceType(createWorkEstimatePermissions);
          break;
        case ConsultantAuctionPermission.CreatePartWorkEstimate:
          return serviceProviderItemsResponse
              .containsServiceType(createPartWorkEstimatePermission);
          break;
      }
    }

    return false;
  }
}

enum ConsultantAuctionPermission {
  AppointmentDetails,
  CarDetails,
  CreateWorkEstimate,
  CreatePartWorkEstimate
}