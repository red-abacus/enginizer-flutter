import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-auction.dart';
import 'package:app/modules/shared/managers/permissions/permissions-side-bar.dart';
import 'package:app/modules/shared/managers/permissions/permissions-user-profile.dart';

class PermissionsManager {
  static var manager = PermissionsManager();

  PermissionsSideBar _permissionsSideBar;
  PermissionsAuction _permissionsAuction;
  PermissionsUserProfile _permissionsUserProfile;

  ServiceProviderItemsResponse _serviceItemsResponse;
  String userRole;

  static PermissionsManager getInstance() {
    return manager;
  }

  setServiceItemsResponse(
      ServiceProviderItemsResponse serviceProviderItemsResponse) {
    _permissionsSideBar = PermissionsSideBar(serviceProviderItemsResponse);
    _permissionsAuction = PermissionsAuction(serviceProviderItemsResponse);
    _permissionsUserProfile = PermissionsUserProfile();
  }

  bool hasAccess(MainPermissions mainPermission, String permission) {
    switch (mainPermission) {
      case MainPermissions.Sidebar:
        return _permissionsSideBar.hasAccess(userRole, permission);
        break;
      case MainPermissions.Auctions:
        return _permissionsAuction.hasAccess(userRole, permission);
        break;
      case MainPermissions.UserProfile:
        return _permissionsUserProfile.hasAccess(userRole, permission);
        break;
    }

    return false;
  }
}

enum MainPermissions { Sidebar, Auctions, UserProfile }

enum ConsultantServiceType {
  Service,
  PartShop,
  DismantlingShop,
  PickUpAndReturn
}

class ConsultantServiceTypeUtils {
  static serviceTypeFromString(String sender) {
    switch (sender) {
      case 'SERVICE':
        return ConsultantServiceType.Service;
      case 'PART_SHOP':
        return ConsultantServiceType.PartShop;
      case 'DISMANTLING_SHOP':
        return ConsultantServiceType.DismantlingShop;
      case 'PICKUP_RETURN':
        return ConsultantServiceType.PickUpAndReturn;
    }

    return null;
  }
}
