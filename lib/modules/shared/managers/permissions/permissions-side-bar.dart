import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/authentication/models/jwt-user.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';

class PermissionsSideBar {
  static final String DASHBOARD = 'VIEW_DASHBOARD';
  static final String PROFILE = 'MANAGE_PERSONAL_PROFILE';
  static final String APPOINTMENT = 'VIEW_APPOINTMENTS';
  static final String AUCTION = 'VIEW_AUCTIONS';
  static final String WORK_ESTIMATE = 'VIEW_WORK_ESTIMATES';
  static final String PARTS = 'MANAGE_PARTS';
  static final String ORDERS = 'VIEW_ORDERS';
  static final String PROMOTIONS = 'VIEW_PROMOTIONS';
  static final String CARS = 'VIEW_CARS';
  static final String SHOP = 'VIEW_ONLINE_STORE';
  static final String TICKETS = 'EXTRA_SERVICES';
  static final String EXTRA_SERVICES = 'EXTRA_SERVICES';
  static final String INVOICES = 'VIEW_INVOICES';

  Map<String, List<String>> _permissionsMap = Map();

  PermissionsSideBar(JwtUser jwtUser) {
    for (String role in Roles.roles) {
      List<String> permissions = List<String>();
      permissions.addAll(jwtUser.permissions);

      _permissionsMap[role] = permissions;
    }
  }

  bool hasAccess(String userRole, String permission) {
    return _permissionsMap[userRole].contains(permission);
  }
}
