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
    return 'https://dev-caas.autowass.ro/api';
  }

  static String get CARS_BASE_API {
    return 'https://dev-car.autowass.ro/api';
  }

  static String get APPOINTMENTS_BASE_API {
    return 'https://dev-appointment.autowass.ro/api';
  }

  static const String APPOINTMENTS_SCHEME = 'https';

  static String get APPOINTMENTS_HOST {
    return 'dev-appointment.autowass.ro';
  }

  static String get PROVIDERS_BASE_API {
    return 'https://dev-provider.autowass.ro/api';
  }

  static String PROVIDERS_SCHEME = 'https';

  static String get PROVIDERS_HOST {
    return 'dev-provider.autowass.ro';
  }

  static String get BIDS_BASE_API {
    return 'https://dev-bid.autowass.ro/api';
  }

  static String BIDS_SCHEME = 'https';

  static String get BIDS_HOST {
    return 'dev-bid.autowass.ro';
  }

  static String get WORK_ESTIMATES_BASE_API {
    return 'https://dev-workestimate.autowass.ro/api';
  }

  static String get USERS_BASE_API {
    return 'https://dev-user.autowass.ro/api';
  }

  static const String CAMERA_CONVERT_API = "http://34.78.165.120:8091/api";

  static String get ROLES_BASE_API {
    return 'https://dev-role.autowass.ro/api';
  }

  static String get NOTIFICATIONS_BASE_API {
    return 'https://dev-notification.autowass.ro/api';
  }

  static String NOTIFICATIONS_SCHEME = 'https';

  static String get NOTIFICATIONS_HOST {
    return 'dev-notification.autowass.ro';
  }

  static String get PROMOTIONS_BASE_API {
    return 'https://dev-store.autowass.ro/api';
  }
}
