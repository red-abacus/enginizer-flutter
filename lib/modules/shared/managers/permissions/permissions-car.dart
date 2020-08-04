import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/authentication/models/jwt-user.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';

class PermissionsCar {
  static final String SELL_CAR = 'SELL_CARS';
  static final String RENT_CAR = 'RENT_CARS';
  static final String MANAGE_CARS = 'MANAGE_CARS';
  static final String VIEW_CAR_TECHNICAL_DOCUMENTATION = 'VIEW_CAR_TECHNICAL_DOCUMENTATION';
  static final String VIEW_CAR_HISTORY = 'VIEW_CAR_HISTORY';

  Map<String, List<String>> permissionsMap = Map();

  PermissionsCar(JwtUser jwtUser) {
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
