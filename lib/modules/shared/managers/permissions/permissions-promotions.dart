import 'package:app/modules/authentication/models/jwt-user.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';

class PermissionsPromotion {
  static final String CREATE_PROMOTION = 'MANAGE_PROMOTIONS';

  Map<String, List<String>> permissionsMap = Map();
  Map<String, List<String>> serviceItemsPermissionsMap = Map();

  PermissionsPromotion(JwtUser jwtUser) {
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

enum OrderPermission {
  Order
}
