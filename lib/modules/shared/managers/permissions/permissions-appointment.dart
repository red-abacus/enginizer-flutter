import 'package:app/modules/authentication/models/jwt-user.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';

class PermissionsAppointment {
  static final String CREATE_APPOINTMENT = 'CREATE_APPOINTMENTS';
  static final String SHARE_APPOINTMENT_LOCATION = 'SHARE_LOCATION';
  static final String MANAGE_APPOINTMENTS = 'MANAGE_APPOINTMENTS';
  static final String EXECUTE_APPOINTMENTS = 'EXECUTE_APPOINTMENTS';
  static final String EXECUTE_RECEIVE_CAR_PROCEDURE =
      'EXECUTE_RECEIVE_CAR_PROCEDURE';
  static final String EXECUTE_RETURN_CAR_PROCEDURE =
      'EXECUTE_RETURN_CAR_PROCEDURE';
  static final String MANAGE_WORK_ESTIMATES = 'MANAGE_WORK_ESTIMATES';
  static final String WORK_ESTIMATE_IMPORT_PARTS = 'WORK_ESTIMATE_IMPORT_PARTS';

  Map<String, List<String>> permissionsMap = Map();

  PermissionsAppointment(
      JwtUser user) {
    for (String role in Roles.roles) {
      List<String> permissions = List<String>();
      permissions.addAll(user.permissions);

      permissionsMap[role] = permissions;
    }
  }

  bool hasAccess(String userRole, String permission) {
    return permissionsMap[userRole].contains(permission);
  }
}
