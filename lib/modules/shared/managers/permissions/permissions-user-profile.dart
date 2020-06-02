import 'package:app/modules/authentication/models/roles.model.dart';

class PermissionsUserProfile {
  static final String ACTIVE_PERSONNEL = 'ACTIVE_PERSONNEL';

  Map<String, List<String>> permissionsMap = Map();

  PermissionsUserProfile() {
    for (String role in Roles.roles) {
      List<String> permissions = [];

      switch (role) {
        case Roles.Super:
          break;
        case Roles.Client:
          break;
        case Roles.ProviderAccountant:
          break;
        case Roles.ProviderPersonnel:
          break;
        case Roles.ProviderConsultant:
          break;
        case Roles.ProviderAdmin:
          permissions = [ACTIVE_PERSONNEL];
          break;
      }

      permissionsMap[role] = permissions;
    }
  }

  bool hasAccess(String userRole, String permission) {
    return permissionsMap[userRole].contains(permission);
  }
}