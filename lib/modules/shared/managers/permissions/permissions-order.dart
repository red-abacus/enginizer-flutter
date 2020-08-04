import 'package:app/modules/authentication/models/jwt-user.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';

class PermissionsOrder {
  static final String CREATE_ORDER = 'CREATE_ORDERS';
  static final String VIEW_ORDER = 'VIEW_ORDERS'; // TODO
  static final String EXECUTE_ORDERS = 'EXECUTE_ORDERS'; // TODO
  static final String CONFIRM_ORDERS = 'CONFIRM_ORDERS'; // TODO

  Map<String, List<String>> permissionsMap = Map();
  Map<String, List<String>> serviceItemsPermissionsMap = Map();

  PermissionsOrder(JwtUser jwtUser) {
    for (String role in Roles.roles) {
      List<String> permissions = List<String>();
      permissions.addAll(jwtUser.permissions);

      permissionsMap[role] = permissions;
    }
  }

  bool hasAccess(String userRole, String permission) {
    return permissionsMap[userRole].contains(permission);
  }
}

enum OrderPermission { Order }
