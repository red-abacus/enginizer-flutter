import 'package:app/modules/dashboard/providers/dashboard.provider.dart';
import 'package:app/modules/parts/providers/part-create.provider.dart';
import 'package:app/modules/parts/providers/parts.provider.dart';
import 'package:app/modules/shop/providers/shop-appointment.provider.dart';
import 'package:app/modules/shop/providers/shop.provider.dart';
import 'package:app/modules/shop/services/shop.service.dart';
import 'package:dio/dio.dart';
import 'package:app/modules/appointments/providers/appointment.provider.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/providers/auction-provider.dart';
import 'package:app/modules/auctions/providers/auctions-provider.dart';
import 'package:app/modules/auctions/services/auction.service.dart';
import 'package:app/modules/auctions/services/bid.service.dart';
import 'package:app/modules/work-estimate-form/services/work-estimates.service.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/authentication/providers/user.provider.dart';
import 'package:app/modules/authentication/services/auth.service.dart';
import 'package:app/modules/authentication/services/user.service.dart';
import 'package:app/modules/cars/providers/cars-make.provider.dart';
import 'package:app/modules/cars/services/car-make.service.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/consultant-appointments/providers/appointment-consultant.provider.dart';
import 'package:app/modules/consultant-appointments/providers/appointments-consultant.provider.dart';
import 'package:app/modules/consultant-appointments/providers/pick-up-car-form-consultant.provider.dart';
import 'package:app/modules/auctions/providers/auction-consultant.provider.dart';
import 'package:app/modules/consultant-estimators/providers/work-estimates-consultant.provider.dart';
import 'package:app/modules/mechanic-appointments/providers/appointment-mechanic.provider.dart';
import 'package:app/modules/mechanic-appointments/providers/appointments-mechanic.provider.dart';
import 'package:app/modules/consultant-user-details/provider/user-consultant.provider.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt inject = GetIt.instance;

void setupDependencyInjection(SharedPreferences s) async {
  inject.registerLazySingleton(() {
    Dio dio = new Dio(BaseOptions(headers: {
      Headers.contentTypeHeader: 'application/json', // set content-length
    }));

    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          options.headers['Authorization'] = 'Bearer ${s.getString('token')}';
          return options;
        },
        onError: (DioError e) async {
          if (e?.response?.statusCode == 401 && s.getString('token') != null) {
            s.remove('token');
            s.clear();
          }
          return e;
        }
    ));

    return dio;
  });

  inject.registerLazySingleton(() => AuthService());
  inject.registerLazySingleton(() => CarMakeService());
  inject.registerLazySingleton(() => CarService());
  inject.registerLazySingleton(() => AppointmentsService());
  inject.registerLazySingleton(() => ProviderService());
  inject.registerLazySingleton(() => UserService());
  inject.registerLazySingleton(() => AuctionsService());
  inject.registerLazySingleton(() => BidsService());
  inject.registerLazySingleton(() => WorkEstimatesService());
  inject.registerLazySingleton(() => ShopService());

  inject.registerFactory(() => Auth());
  inject.registerFactory(() => CarsMakeProvider());
  inject.registerFactory(() => ProviderServiceProvider());
  inject.registerFactory(() => ServiceProviderDetailsProvider());
  inject.registerFactory(() => AppointmentsProvider());
  inject.registerFactory(() => UserProvider());
  inject.registerFactory(() => UserConsultantProvider());
  inject.registerFactory(() => AppointmentProvider());
  inject.registerFactory(() => AuctionsProvider());
  inject.registerFactory(() => AuctionProvider());
  inject.registerFactory(() => AuctionConsultantProvider());
  inject.registerFactory(() => WorkEstimateProvider());
  inject.registerFactory(() => AppointmentsConsultantProvider());
  inject.registerFactory(() => AppointmentConsultantProvider());
  inject.registerFactory(() => AppointmentsMechanicProvider());
  inject.registerFactory(() => AppointmentMechanicProvider());
  inject.registerFactory(() => WorkEstimatesConsultantProvider());
  inject.registerFactory(() => PickUpCarFormConsultantProvider());
  inject.registerFactory(() => DashboardProvider());
  inject.registerFactory(() => ShopProvider());
  inject.registerFactory(() => ShopAppointmentProvider());
  inject.registerFactory(() => PartsProvider());
  inject.registerFactory(() => PartCreateProvider());

}
