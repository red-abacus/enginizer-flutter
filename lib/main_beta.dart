import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/layout/navigation.app.dart';
import 'package:enginizer_flutter/modules/appointments/providers/appointment.provider.dart';
import 'package:enginizer_flutter/modules/appointments/providers/appointments.provider.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';
import 'package:enginizer_flutter/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:enginizer_flutter/modules/auctions/providers/work-estimates.provider.dart';
import 'package:enginizer_flutter/modules/auctions/screens/auction-details.dart';
import 'package:enginizer_flutter/modules/auctions/screens/bid-details.dart';
import 'package:enginizer_flutter/modules/authentication/providers/auth.provider.dart';
import 'package:enginizer_flutter/modules/authentication/providers/user.provider.dart';
import 'package:enginizer_flutter/modules/authentication/screens/auth.screen.dart';
import 'package:enginizer_flutter/modules/cars/providers/car.provider.dart';
import 'package:enginizer_flutter/modules/cars/providers/cars-make.provider.dart';
import 'package:enginizer_flutter/modules/cars/providers/cars.provider.dart';
import 'package:enginizer_flutter/modules/cars/screens/car.dart';
import 'package:enginizer_flutter/modules/cars/screens/cars.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/screens/appointments-consultant.dart';
import 'package:enginizer_flutter/modules/consultant-auctions/providers/create-work-estimate.provider.dart';
import 'package:enginizer_flutter/modules/consultant-auctions/screens/auction-consultant.dart';
import 'package:enginizer_flutter/modules/consultant-auctions/screens/auctions-consultant.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/screens/create-work-estimate-consultant.dart';
import 'package:enginizer_flutter/modules/consultant-estimators/providers/work-estimates-consultant.provider.dart';
import 'package:enginizer_flutter/modules/consultant-estimators/screens/work-estimates-consultant.dart';
import 'package:enginizer_flutter/modules/consultant-user-details/screens/user-details-consultant.dart';
import 'package:enginizer_flutter/screens/splash.screen.dart';
import 'package:enginizer_flutter/utils/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/injection.dart';
import 'generated/l10n.dart';
import 'layout/navigation.app.dart';
import 'modules/appointments/providers/appointment.provider.dart';
import 'modules/appointments/providers/appointments.provider.dart';
import 'modules/appointments/providers/provider-service.provider.dart';
import 'modules/appointments/screens/appointment-details.dart';
import 'modules/appointments/screens/appointments.dart';
import 'modules/auctions/providers/auction-provider.dart';
import 'modules/auctions/providers/auctions-provider.dart';
import 'modules/auctions/screens/auctions.dart';
import 'modules/authentication/providers/auth.provider.dart';
import 'modules/authentication/providers/user.provider.dart';
import 'modules/authentication/screens/auth.screen.dart';
import 'modules/cars/providers/car.provider.dart';
import 'modules/cars/providers/cars-make.provider.dart';
import 'modules/cars/providers/cars.provider.dart';
import 'modules/cars/screens/car.dart';
import 'modules/cars/screens/cars.dart';
import 'modules/consultant-appointments/providers/appointment-consultant.provider.dart';
import 'modules/consultant-appointments/providers/appointments-consultant.provider.dart';
import 'modules/consultant-appointments/providers/pick-up-car-form-consultant.provider.dart';
import 'modules/consultant-appointments/screens/appointments-details-consultant.dart';
import 'modules/consultant-auctions/providers/auction-consultant.provider.dart';
import 'modules/consultant-auctions/providers/auctions-consultant.provider.dart';
import 'modules/mechanic-appointments/providers/appointment-mechanic.provider.dart';
import 'modules/mechanic-appointments/providers/appointments-mechanic.provider.dart';
import 'modules/mechanic-appointments/screens/appointment-details-mechanic.dart';
import 'modules/mechanic-appointments/screens/appointments-mechanic.dart';
import 'modules/consultant-user-details/provider/user-consultant.provider.dart';
import 'modules/user-details/screens/user-details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final prefs = await SharedPreferences.getInstance();
  setupDependencyInjection(prefs);

  var configuredApp = AppConfig(
    enviroment: Enviroment.Beta,
    child: App(),
  );
  runApp(configuredApp);
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AppState();
  }
}

class AppState extends State<App> {
  AppState();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProvider.value(value: CarsProvider()),
          ChangeNotifierProvider.value(value: CarProvider()),
          ChangeNotifierProvider.value(value: CarsMakeProvider()),
          ChangeNotifierProvider.value(value: ProviderServiceProvider()),
          ChangeNotifierProvider.value(value: AppointmentsProvider()),
          ChangeNotifierProvider.value(value: UserProvider()),
          ChangeNotifierProvider.value(value: UserConsultantProvider()),
          ChangeNotifierProvider.value(value: AppointmentProvider()),
          ChangeNotifierProvider.value(value: AuctionsProvider()),
          ChangeNotifierProvider.value(value: AuctionsConsultantProvider()),
          ChangeNotifierProvider.value(value: AuctionProvider()),
          ChangeNotifierProvider.value(value: AuctionConsultantProvider()),
          ChangeNotifierProvider.value(value: CreateWorkEstimateProvider()),
          ChangeNotifierProvider.value(value: WorkEstimatesProvider()),
          ChangeNotifierProvider.value(value: AppointmentsConsultantProvider()),
          ChangeNotifierProvider.value(value: AppointmentConsultantProvider()),
          ChangeNotifierProvider.value(value: AppointmentsMechanicProvider()),
          ChangeNotifierProvider.value(value: AppointmentMechanicProvider()),
          ChangeNotifierProvider.value(value: ServiceProviderDetailsProvider()),
          ChangeNotifierProvider.value(
              value: WorkEstimatesConsultantProvider()),
          ChangeNotifierProvider.value(
              value: PickUpCarFormConsultantProvider()),
        ],
        child: Consumer<Auth>(builder: (context, authProvider, _) {
          return MaterialApp(
            home: authProvider.isAuth
                ? NavigationApp(
                    authUser: authProvider.authUser,
                    authUserDetails: authProvider.authUserDetails)
                : FutureBuilder(
                    future: authProvider.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            theme: ThemeData(
              primaryColor: Color.fromRGBO(153, 0, 0, 1),
              accentColor: Color.fromRGBO(206, 49, 47, 1),
              primaryColorLight: Color.fromRGBO(193, 193, 193, 1),
              primaryColorDark: Color.fromRGBO(80, 80, 70, 1),
              cardColor: Colors.white,
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                },
              ),
              textTheme: TextTheme(
                headline: TextStyle(fontFamily: 'Lato', color: Colors.black54),
                title: TextStyle(fontFamily: 'Lato', color: Colors.black54),
                body1: TextStyle(
                    fontSize: 16, fontFamily: 'Lato', color: Colors.black54),
              ),
            ),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate
            ],
            supportedLocales: S.delegate.supportedLocales,
            routes: {
              '/auth': (context) => AuthScreen(),
              '/cars': (context) => Cars(),
              '/cars/details': (context) => CarDetails(),
              Appointments.route: (context) => Appointments(),
              AppointmentDetails.route: (context) => AppointmentDetails(),
              Auctions.route: (context) => Auctions(),
              AuctionsConsultant.route: (context) => AuctionsConsultant(),
              AuctionDetails.route: (context) => AuctionDetails(),
              AuctionConsultant.route: (context) => AuctionConsultant(),
              BidDetails.route: (context) => BidDetails(),
              AppointmentsConsultant.route: (context) =>
                  AppointmentsConsultant(),
              AppointmentDetailsConsultant.route: (context) =>
                  AppointmentDetailsConsultant(),
              AppointmentsMechanic.route: (context) => AppointmentsMechanic(),
              AppointmentDetailsMechanic.route: (context) =>
                  AppointmentDetailsMechanic(),
              UserDetails.route: (context) => UserDetails(),
              UserDetailsConsultant.route: (context) => UserDetailsConsultant(),
              WorkEstimatesConsultant.route: (context) =>
                  WorkEstimatesConsultant(),
              CreateWorkEstimateConsultant.route: (context) =>
                  CreateWorkEstimateConsultant()
            },
          );
        }));
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.settings.isInitialRoute) {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
