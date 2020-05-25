import 'package:app/modules/authentication/models/roles.model.dart';

class PermissionsUserProfile {
  bool hasAccess(String userRole, UserProfilePermission permission) {
    switch (userRole) {
      case Roles.ProviderAdmin:
        switch (permission) {
          case UserProfilePermission.ActivePersonel:
            return true;
          default:
            break;
        }
        break;
      default:
        break;
    }
    return false;
  }
}

enum UserProfilePermission {
  ActivePersonel,
}
