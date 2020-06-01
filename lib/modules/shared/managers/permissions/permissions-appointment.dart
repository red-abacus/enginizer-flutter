import 'package:app/modules/authentication/models/roles.model.dart';

class PermissionsAppointment {
  static final String CREATE_APPOINTMENT = 'APPOINTMENT.CREATE_APPOINTMENT';

  Map<String, List<String>> permissionsMap = Map();

  PermissionsAppointment() {
    for (String role in Roles.roles) {
      List<String> permissions = [];

      switch (role) {
        case Roles.Super:
          break;
        case Roles.Client:
          permissions = [CREATE_APPOINTMENT];
          break;
        case Roles.ProviderAccountant:
          break;
        case Roles.ProviderPersonnel:
          break;
        case Roles.ProviderConsultant:
          break;
        case Roles.ProviderAdmin:
          break;
      }

      permissionsMap[role] = permissions;
    }
  }

  bool hasAccess(String userRole, String permission) {
    return permissionsMap[userRole].contains(permission);
  }
}
