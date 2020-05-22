import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-auction.dart';
import 'package:app/modules/shared/managers/permissions/permissions-side-bar.dart';
import 'package:app/modules/shared/managers/permissions/permissions-user-profile.dart';

class PermissionsManager {
  static var manager = PermissionsManager();

  PermissionsAuction _permissionsAuction = PermissionsAuction();
  PermissionsSideBar _permissionsSideBar = PermissionsSideBar();
  PermissionsUserProfile _permissionsUserProfile = PermissionsUserProfile();

  ServiceProviderItemsResponse serviceItemsResponse;
  String userRole;

  static PermissionsManager getInstance() {
    return manager;
  }

  bool hasAccess(MainPermissions permission,
      {ConsultantSideBarPermission sideBarPermission,
      AuctionPermission auctionPermission,
      UserProfilePermission userProfilePermission}) {
    switch (userRole) {
      case Roles.Super:
        if (userProfilePermission != null) {
          return _permissionsUserProfile.hasAccess(
              userRole, userProfilePermission);
        }
        return true;
      case Roles.Client:
        if (userProfilePermission != null) {
          return _permissionsUserProfile.hasAccess(
              userRole, userProfilePermission);
        }
        return true;
      case Roles.ProviderAdmin:
        if (userProfilePermission != null) {
          return _permissionsUserProfile.hasAccess(
              userRole, userProfilePermission);
        }
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
          case MainPermissions.UserProfile:
            return _permissionsUserProfile.hasAccess(
                userRole, userProfilePermission);
          default:
            break;
        }
        break;
      case Roles.ProviderPersonnel:
        if (userProfilePermission != null) {
          return _permissionsUserProfile.hasAccess(
              userRole, userProfilePermission);
        }
        return true;
      default:
        return false;
    }

    return false;
  }
}

enum MainPermissions { Sidebar, Auctions, UserProfile }

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
