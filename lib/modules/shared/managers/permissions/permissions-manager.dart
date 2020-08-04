import 'package:app/modules/authentication/models/jwt-user.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-appointment.dart';
import 'package:app/modules/shared/managers/permissions/permissions-auction.dart';
import 'package:app/modules/shared/managers/permissions/permissions-car.dart';
import 'package:app/modules/shared/managers/permissions/permissions-order.dart';
import 'package:app/modules/shared/managers/permissions/permissions-profile.dart';
import 'package:app/modules/shared/managers/permissions/permissions-promotions.dart';
import 'package:app/modules/shared/managers/permissions/permissions-side-bar.dart';

class PermissionsManager {
  static var manager = PermissionsManager();

  PermissionsSideBar _permissionsSideBar;
  PermissionsAuction _permissionsAuction;
  PermissionsOrder _permissionsOrder;
  PermissionsAppointment _permissionsAppointment;
  PermissionsCar _permissionsCar;
  PermissionsPromotion _permissionsPromotion;
  PermissionsProfile _permissionsProfile;

  String userRole;

  static PermissionsManager getInstance() {
    return manager;
  }

  static PermissionsManager removeInstance() {
    manager = PermissionsManager();
  }

  initialise(JwtUser jwtUser) {
    _permissionsSideBar = PermissionsSideBar(jwtUser);
    _permissionsAuction = PermissionsAuction(jwtUser);
    _permissionsOrder = PermissionsOrder(jwtUser);
    _permissionsAppointment = PermissionsAppointment(jwtUser);
    _permissionsCar = PermissionsCar(jwtUser);
    _permissionsPromotion = PermissionsPromotion(jwtUser);
    _permissionsProfile = PermissionsProfile(jwtUser);
  }

  bool hasAccess(MainPermissions mainPermission, String permission) {
    switch (mainPermission) {
      case MainPermissions.Sidebar:
        return _permissionsSideBar.hasAccess(userRole, permission);
      case MainPermissions.Auctions:
        return _permissionsAuction.hasAccess(userRole, permission);
      case MainPermissions.Orders:
        return _permissionsOrder.hasAccess(userRole, permission);
      case MainPermissions.Appointments:
        return _permissionsAppointment.hasAccess(userRole, permission);
      case MainPermissions.Cars:
        return _permissionsCar.hasAccess(userRole, permission);
      case MainPermissions.Promotions:
        return _permissionsPromotion.hasAccess(userRole, permission);
      case MainPermissions.Profile:
        return _permissionsProfile.hasAccess(userRole, permission);
    }

    return false;
  }
}

enum MainPermissions {
  Sidebar,
  Auctions,
  Orders,
  Appointments,
  Cars,
  Promotions,
  Profile
}

enum ConsultantServiceType {
  Service,
  PartShop,
  DismantlingShop,
  PickUpAndReturn,
  Sell,
  Rent,
  Painter
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
      case 'SELLER_SERVICE':
        return ConsultantServiceType.Sell;
      case 'RENT_SERVICE':
        return ConsultantServiceType.Rent;
      case 'PAINT_SHOP':
        return ConsultantServiceType.Painter;
    }

    return null;
  }
}
