import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/generated/i18n.dart';
import 'package:enginizer_flutter/layout/navigation.app.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';
import 'package:enginizer_flutter/modules/appointments/providers/appointments.provider.dart';
import 'package:enginizer_flutter/modules/authentication/providers/auth.provider.dart';
import 'package:enginizer_flutter/modules/authentication/screens/auth.screen.dart';
import 'package:enginizer_flutter/modules/cars/providers/car.provider.dart';
import 'package:enginizer_flutter/modules/cars/providers/cars-make.provider.dart';
import 'package:enginizer_flutter/modules/cars/providers/cars.provider.dart';
import 'package:enginizer_flutter/modules/cars/screens/car.dart';
import 'package:enginizer_flutter/modules/cars/screens/cars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  setupDependencyInjection();
  runApp(App());
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
          ChangeNotifierProvider.value(value: AppointmentsProvider())
        ],
        child: Consumer<Auth>(builder: (context, authProvider, _) {
          authProvider.tryAutoLogin();
          return MaterialApp(
            home: authProvider.isAuth ? NavigationApp() : AuthScreen(),
            theme: ThemeData(
              primaryColor: Color.fromRGBO(153, 0, 0, 1),
              accentColor: Color.fromRGBO(206, 49, 47, 1),
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
            localeResolutionCallback:
                S.delegate.resolution(fallback: new Locale("ro", "")),
            routes: {
              '/auth': (context) => AuthScreen(),
              '/cars': (context) => Cars(),
              '/cars/details': (context) => CarDetails()
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
