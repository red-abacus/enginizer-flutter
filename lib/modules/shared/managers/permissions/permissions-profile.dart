import 'package:app/modules/authentication/models/jwt-user.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';

class PermissionsProfile {
  static final String MANAGE_PERSONAL_PROFILE = 'MANAGE_PERSONAL_PROFILE';
  static final String MANAGER_UNIT_PROFILE = 'MANAGE_UNIT_PROFILE';
  static final String VIEW_ACTIVE_WORKSTATIONS = 'VIEW_WORKSTATIONS';

  Map<String, List<String>> permissionsMap = Map();
  Map<String, List<String>> serviceItemsPermissionsMap = Map();

  PermissionsProfile(JwtUser jwtUser) {
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
