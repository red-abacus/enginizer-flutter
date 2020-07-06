import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';

class PermissionsAuction {
  static final String AUCTION_DETAILS = 'AUCTION.AUCTION_DETAILS'; // TODO
  static final String AUCTION_MAP_DETAILS = 'AUCTION.AUCTION_MAP_DETAILS'; // TODO
  static final String CONSULTANT_AUCTION_DETAILS =
      'AUCTION.CONSULTANT_AUCTION_DETAILS'; // TODO
  static final String APPOINTMENT_DETAILS = 'AUCTION.APPOINTMENT_DETAILS'; // TODO
  static final String CAR_DETAILS = 'AUCTION.CAR_DETAILS'; // TODO

  Map<String, List<String>> permissionsMap = Map();
  Map<String, List<String>> serviceItemsPermissionsMap = Map();

  PermissionsAuction(ServiceProviderItemsResponse serviceProviderItemsResponse) {
    for (String role in Roles.roles) {
      List<String> permissions = [];

      switch (role) {
        case Roles.Super:
          break;
        case Roles.Client:
          permissions.add(AUCTION_DETAILS);
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
                    permissions.add(AUCTION_MAP_DETAILS);
                    break;
                  case ConsultantServiceType.Service:
                    permissions.add(APPOINTMENT_DETAILS);
                    permissions.add(CONSULTANT_AUCTION_DETAILS);
                    break;
                  case ConsultantServiceType.PartShop:
                    permissions.add(CAR_DETAILS);
                    permissions.add(CONSULTANT_AUCTION_DETAILS);
                    break;
                  case ConsultantServiceType.DismantlingShop:
                    permissions.add(CAR_DETAILS);
                    permissions.add(CONSULTANT_AUCTION_DETAILS);
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
