import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/authentication/models/user-role.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';

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
