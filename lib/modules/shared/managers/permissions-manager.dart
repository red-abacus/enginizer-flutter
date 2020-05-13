import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/authentication/models/jwt-user-details.model.dart';
import 'package:app/modules/shared/managers/permissions-auction.dart';
import 'package:app/modules/shared/managers/permissions-side-bar.dart';

class PermissionsManager {
  static var manager = PermissionsManager();

  PermissionsAuction _permissionsAuction = PermissionsAuction();
  PermissionsSideBar _permissionsSideBar = PermissionsSideBar();

  ServiceProviderItemsResponse serviceItemsResponse;

  static PermissionsManager getInstance() {
    return manager;
  }

  bool consultantHasAccess(ConsultantMainPermissions permission,
      {ConsultantSideBarPermission sideBarPermission, ConsultantAuctionPermission auctionPermission}) {
    switch (permission) {
      case ConsultantMainPermissions.Sidebar:
        if (sideBarPermission != null) {
          return _permissionsSideBar.consultantHasAccess(
              serviceItemsResponse, sideBarPermission);
        }
        break;
      case ConsultantMainPermissions.Auctions:
        return _permissionsAuction.consultantHasAccess(
            serviceItemsResponse, auctionPermission);
        break;
    }

    return false;
  }
}

enum ConsultantMainPermissions {
  Sidebar,
  Auctions
}

enum ConsultantServiceType { Service, PartShop, DismantlingShop }

class ConsultantServiceTypeUtils {
  static serviceTypeFromString(String sender) {
    switch (sender) {
      case 'SERVICE':
        return ConsultantServiceType.Service;
      case 'PART_SHOP':
        return ConsultantServiceType.PartShop;
      case 'DISMANTLING_SHOP':
        return ConsultantServiceType.DismantlingShop;
    }

    return null;
  }
}
