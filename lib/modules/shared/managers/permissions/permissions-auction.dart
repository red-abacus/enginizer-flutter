import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/authentication/models/jwt-user.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';

class PermissionsAuction {
  static final String APPOINTMENT_DETAILS =
      'AUCTION.APPOINTMENT_DETAILS'; // TODO
  static final String CAR_DETAILS = 'AUCTION.CAR_DETAILS'; // TODO

  static final String BID_AUCTIONS = 'BID_AUCTIONS';
  static final String VIEW_BIDS = 'VIEW_BIDS';

  Map<String, List<String>> permissionsMap = Map();
  Map<String, List<String>> serviceItemsPermissionsMap = Map();

  PermissionsAuction(JwtUser jwtUser,
      ServiceProviderItemsResponse serviceProviderItemsResponse) {
    for (String role in Roles.roles) {
      List<String> permissions = List<String>();
      permissions.addAll(jwtUser.permissions);

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
                    break;
                  case ConsultantServiceType.Service:
                    permissions.add(APPOINTMENT_DETAILS);
                    break;
                  case ConsultantServiceType.PartShop:
                    permissions.add(CAR_DETAILS);
                    break;
                  case ConsultantServiceType.DismantlingShop:
                    permissions.add(CAR_DETAILS);
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
