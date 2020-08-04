import 'app_config.dart';

class Environment {
  static String prefix = '';

  static void initialise(Enviroment enviroment) {
    switch (enviroment) {
      case Enviroment.Dev:
        prefix = 'dev';
        break;
      case Enviroment.Staging:
        prefix = 'staging';
        break;
      case Enviroment.Production:
        prefix = 'production';
        break;
    }
  }

  static String get AUTH_BASE_URL {
    return 'https://$prefix-caas.autowass.ro/api';
  }

  static String get CARS_BASE_API {
    return 'https://$prefix-car.autowass.ro/api';
  }

  static String get APPOINTMENTS_BASE_API {
    return 'https://$prefix-appointment.autowass.ro/api';
  }

  static const String APPOINTMENTS_SCHEME = 'https';

  static String get APPOINTMENTS_HOST {
    return '$prefix-appointment.autowass.ro';
  }

  static String get PROVIDERS_BASE_API {
    return 'https://$prefix-provider.autowass.ro/api';
  }

  static String PROVIDERS_SCHEME = 'https';

  static String get PROVIDERS_HOST {
    return '$prefix-provider.autowass.ro';
  }

  static String get BIDS_BASE_API {
    return 'https://$prefix-bid.autowass.ro/api';
  }

  static String BIDS_SCHEME = 'https';

  static String get BIDS_HOST {
    return '$prefix-bid.autowass.ro';
  }

  static String get WORK_ESTIMATES_BASE_API {
    return 'https://$prefix-workestimate.autowass.ro/api';
  }

  static String get USERS_BASE_API {
    return 'https://$prefix-user.autowass.ro/api';
  }

  static const String CAMERA_CONVERT_API = "http://34.78.165.120:8091/api";

  static String get ROLES_BASE_API {
    return 'https://$prefix-role.autowass.ro/api';
  }

  static String get NOTIFICATIONS_BASE_API {
    return 'https://$prefix-notification.autowass.ro/api';
  }

  static String NOTIFICATIONS_SCHEME = 'https';

  static String get NOTIFICATIONS_HOST {
    return '$prefix-notification.autowass.ro';
  }

  static String get PROMOTIONS_BASE_API {
    return 'https://$prefix-store.autowass.ro/api';
  }

  static String get REPORTS_BASE_API {
    return 'https://$prefix-reporting.autowass.ro/api';
  }
}
