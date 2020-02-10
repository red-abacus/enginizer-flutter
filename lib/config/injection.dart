import 'package:dio/dio.dart';
import 'package:enginizer_flutter/modules/appointments/providers/appointment.provider.dart';
import 'package:enginizer_flutter/modules/appointments/providers/appointments.provider.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';
import 'package:enginizer_flutter/modules/appointments/services/appointments.service.dart';
import 'package:enginizer_flutter/modules/appointments/services/provider.service.dart';
import 'package:enginizer_flutter/modules/auctions/providers/auctions-provider.dart';
import 'package:enginizer_flutter/modules/authentication/providers/auth.provider.dart';
import 'package:enginizer_flutter/modules/authentication/providers/user.provider.dart';
import 'package:enginizer_flutter/modules/authentication/services/auth.service.dart';
import 'package:enginizer_flutter/modules/authentication/services/user.service.dart';
import 'package:enginizer_flutter/modules/cars/providers/cars-make.provider.dart';
import 'package:enginizer_flutter/modules/cars/services/car-make.service.dart';
import 'package:enginizer_flutter/modules/cars/services/car.service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt inject = GetIt.instance;

void setupDependencyInjection(SharedPreferences s) async {
  inject.registerLazySingleton(() {
    Dio dio = new Dio(BaseOptions(headers: {
      Headers.contentTypeHeader: 'application/json', // set content-length
    }));

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      options.headers['Authorization'] = 'Bearer ${s.getString('token')}';
      return options;
    }));

    return dio;
  });

  inject.registerLazySingleton(() => AuthService());
  inject.registerLazySingleton(() => CarMakeService());
  inject.registerLazySingleton(() => CarService());
  inject.registerLazySingleton(() => AppointmentsService());
  inject.registerLazySingleton(() => ProviderService());
  inject.registerLazySingleton(() => UserService());

  inject.registerFactory(() => Auth());
  inject.registerFactory(() => CarsMakeProvider());
  inject.registerFactory(() => ProviderServiceProvider());
  inject.registerFactory(() => AppointmentsProvider());
  inject.registerFactory(() => UserProvider());
  inject.registerFactory(() => AppointmentProvider());
  inject.registerFactory(() => AuctionsProvider());
}
