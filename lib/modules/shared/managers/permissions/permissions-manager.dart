import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-auction.dart';
import 'package:app/modules/shared/managers/permissions/permissions-side-bar.dart';

class PermissionsManager {
  static var manager = PermissionsManager();

  PermissionsAuction _permissionsAuction = PermissionsAuction();
  PermissionsSideBar _permissionsSideBar = PermissionsSideBar();

  ServiceProviderItemsResponse serviceItemsResponse;
  String userRole;

  static PermissionsManager getInstance() {
    return manager;
  }

  bool hasAccess(MainPermissions permission,
      {ConsultantSideBarPermission sideBarPermission, AuctionPermission auctionPermission}) {
    switch (userRole) {
      case Roles.Super:
        return true;
      case Roles.Client:
        return true;
      case Roles.ProviderAdmin:
        return true;
      case Roles.ProviderConsultant:
        switch (permission) {
          case MainPermissions.Sidebar:
            if (sideBarPermission != null) {
              return _permissionsSideBar.consultantHasAccess(
                  serviceItemsResponse, sideBarPermission);
            }
            break;
          case MainPermissions.Auctions:
            return _permissionsAuction.consultantHasAccess(
                serviceItemsResponse, auctionPermission);
            break;
        }
        break;
      case Roles.ProviderPersonnel:
        return true;
      default:
        return false;
    }

    return false;
  }
}

enum MainPermissions {
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
