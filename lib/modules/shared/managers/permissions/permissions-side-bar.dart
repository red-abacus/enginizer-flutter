import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';

class PermissionsSideBar {
  static final String PROFILE = 'SIDEBAR.PROFILE';
  static final String APPOINTMENT = 'SIDEBAR.APPOINTMENT';
  static final String AUCTION = 'SIDEBAR.AUCTION';
  static final String WORK_ESTIMATE = 'SIDEBAR.WORK_ESTIMATE';
  static final String NOTIFICATIONS = 'SIDEBAR.NOTIFICATIONS';
  static final String PARTS = 'SIDEBAR.PARTS';
  static final String ORDERS = 'SIDEBAR.ORDERS';
  static final String PROMOTIONS = 'SIDEBAR.PROMOTIONS';

  Map<String, List<String>> _permissionsMap = Map();

  PermissionsSideBar(ServiceProviderItemsResponse serviceProviderItemsResponse) {
    for (String role in Roles.roles) {
      List<String> permissions = [];

      switch (role) {
        case Roles.Super:
          permissions = [PROFILE];
          break;
        case Roles.Client:
          permissions = [PROFILE, APPOINTMENT, AUCTION, NOTIFICATIONS];
          break;
        case Roles.ProviderAccountant:
          permissions = [PROFILE];
          break;
        case Roles.ProviderPersonnel:
          permissions = [PROFILE, APPOINTMENT, NOTIFICATIONS];
          break;
        case Roles.ProviderConsultant:
          permissions = [PROFILE];

          if (serviceProviderItemsResponse != null) {
            for(ServiceProviderItem item in serviceProviderItemsResponse.items) {
              ConsultantServiceType serviceType = ConsultantServiceTypeUtils.serviceTypeFromString(item.name);

              if (serviceType != null) {
                switch (serviceType) {
                  case ConsultantServiceType.PickUpAndReturn:
                    permissions.add(APPOINTMENT);
                    permissions.add(AUCTION);
                    permissions.add(WORK_ESTIMATE);
                    permissions.add(NOTIFICATIONS);
                    break;
                  case ConsultantServiceType.Service:
                    permissions.add(PROFILE);
                    permissions.add(APPOINTMENT);
                    permissions.add(AUCTION);
                    permissions.add(WORK_ESTIMATE);
                    permissions.add(NOTIFICATIONS);
                    permissions.add(ORDERS);
                    break;
                  case ConsultantServiceType.PartShop:
                    permissions.add(PROFILE);
                    permissions.add(AUCTION);
                    permissions.add(NOTIFICATIONS);
                    permissions.add(ORDERS);
                    break;
                  case ConsultantServiceType.DismantlingShop:
                    permissions.add(PROFILE);
                    permissions.add(AUCTION);
                    permissions.add(NOTIFICATIONS);
                    permissions.add(PARTS);
                    permissions.add(ORDERS);
                    break;
                }
              }
            }
          }
          break;
        case Roles.ProviderAdmin:
          permissions = [PROFILE, PROMOTIONS];
          break;
      }

      _permissionsMap[role] = permissions;
    }
  }

  bool hasAccess(String userRole, String permission) {
    return _permissionsMap[userRole].contains(permission);
  }
}