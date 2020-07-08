import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/authentication/models/jwt-user.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';

class PermissionsSideBar {
  static final String DASHBOARD = 'VIEW_DASHBOARD';
  static final String PROFILE = 'MANAGE_PERSONAL_PROFILE';
  static final String APPOINTMENT = 'VIEW_APPOINTMENTS';
  static final String AUCTION = 'VIEW_AUCTIONS';
  static final String WORK_ESTIMATE = 'VIEW_WORK_ESTIMATES';
  static final String NOTIFICATIONS = 'SIDEBAR.NOTIFICATIONS'; // TODO
  static final String PARTS = 'SIDEBAR.PARTS'; // TODO
  static final String ORDERS = 'VIEW_ORDERS';
  static final String PROMOTIONS = 'VIEW_PROMOTIONS';
  static final String CARS = 'VIEW_CARS'; // TODO - this need to be updated on backend. Service providers with sell or rent car needs this permission
  static final String SHOP = 'VIEW_ONLINE_STORE';
  static final String TICKETS = 'SIDEBAR.TICKETS'; // TODO
  static final String EXTRA_SERVICES = 'SIDEBAR.EXTRA_SERVICES'; // TODO
  static final String INVOICES = 'VIEW_INVOICES';

  Map<String, List<String>> _permissionsMap = Map();

  PermissionsSideBar(JwtUser jwtUser,
      ServiceProviderItemsResponse serviceProviderItemsResponse) {
    for (String role in Roles.roles) {
      List<String> permissions = List<String>();
      permissions.addAll(jwtUser.permissions);

      switch (role) {
        case Roles.Super:
          break;
        case Roles.Client:
          permissions.addAll([
            NOTIFICATIONS,
            EXTRA_SERVICES,
          ]);
          break;
        case Roles.ProviderAccountant:
          break;
        case Roles.ProviderPersonnel:
          permissions.add(NOTIFICATIONS);
          break;
        case Roles.ProviderConsultant:
          if (serviceProviderItemsResponse != null) {
            for (ServiceProviderItem item
                in serviceProviderItemsResponse.items) {
              ConsultantServiceType serviceType =
                  ConsultantServiceTypeUtils.serviceTypeFromString(item.name);

              if (serviceType != null) {
                switch (serviceType) {
                  case ConsultantServiceType.PickUpAndReturn:
                    permissions.add(NOTIFICATIONS);
                    break;
                  case ConsultantServiceType.Service:
                    permissions.add(NOTIFICATIONS);
                    break;
                  case ConsultantServiceType.PartShop:
                    permissions.add(NOTIFICATIONS);
                    break;
                  case ConsultantServiceType.DismantlingShop:
                    permissions.add(NOTIFICATIONS);
                    permissions.add(PARTS);
                    break;
                  case ConsultantServiceType.Sell:
                    break;
                  case ConsultantServiceType.Rent:
                    break;
                  case ConsultantServiceType.Painter:
                    break;
                }
              }
            }
          }
          break;
        case Roles.ProviderAdmin:
          break;
      }

      _permissionsMap[role] = permissions;
    }
  }

  bool hasAccess(String userRole, String permission) {
    return _permissionsMap[userRole].contains(permission);
  }
}
