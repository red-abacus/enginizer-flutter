import 'package:app/config/injection.dart';
import 'package:app/layout/navigation_toolbar.app.dart';
import 'package:app/modules/appointments/providers/appointment.provider.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/modules/auctions/screens/auction.dart';
import 'package:app/modules/auctions/screens/bid-details.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/authentication/providers/user.provider.dart';
import 'package:app/modules/authentication/screens/auth.screen.dart';
import 'package:app/modules/cars/providers/car.provider.dart';
import 'package:app/modules/cars/providers/cars-make.provider.dart';
import 'package:app/modules/cars/providers/cars.provider.dart';
import 'package:app/modules/cars/screens/car.dart';
import 'package:app/modules/cars/screens/cars.dart';
import 'package:app/modules/appointments/providers/select-parts-provider.provider.dart';
import 'package:app/modules/auctions/screens/auction-consultant.dart';
import 'package:app/modules/consultant-user-details/screens/user-details-consultant.dart';
import 'package:app/modules/notifications/screens/notifications.dart';
import 'package:app/modules/promotions/providers/promotions.provider.dart';
import 'package:app/modules/promotions/screens/promotions.screen.dart';
import 'package:app/screens/splash.screen.dart';
import 'package:app/utils/app_config.dart';
import 'package:app/utils/firebase/firebase_manager.dart';
import 'package:app/utils/firebase/firestore_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/injection.dart';
import 'generated/l10n.dart';
import 'modules/appointments/providers/appointment.provider.dart';
import 'modules/appointments/providers/appointments.provider.dart';
import 'modules/appointments/providers/camera.provider.dart';
import 'modules/appointments/providers/provider-service.provider.dart';
import 'modules/appointments/providers/car-reception-form.provider.dart';
import 'modules/appointments/screens/appointment-details-map.dart';
import 'modules/appointments/screens/appointment-details.dart';
import 'modules/appointments/screens/appointments.dart';
import 'modules/auctions/providers/auction-provider.dart';
import 'modules/auctions/providers/auctions-provider.dart';
import 'modules/auctions/screens/auction-consultant-map.dart';
import 'modules/auctions/screens/auctions.dart';
import 'modules/authentication/providers/auth.provider.dart';
import 'modules/authentication/providers/user.provider.dart';
import 'modules/authentication/screens/auth.screen.dart';
import 'modules/cars/providers/car.provider.dart';
import 'modules/cars/providers/cars-make.provider.dart';
import 'modules/cars/providers/cars.provider.dart';
import 'modules/cars/screens/car.dart';
import 'modules/cars/screens/cars.dart';
import 'modules/appointments/providers/appointment-consultant.provider.dart';
import 'modules/appointments/providers/pick-up-car-form-consultant.provider.dart';
import 'modules/appointments/screens/appointments-details-consultant.dart';
import 'modules/auctions/providers/auction-consultant.provider.dart';
import 'modules/dashboard/providers/dashboard.provider.dart';
import 'modules/appointments/providers/appointment-mechanic.provider.dart';
import 'modules/appointments/screens/appointment-details-mechanic.dart';
import 'modules/consultant-user-details/provider/user-consultant.provider.dart';
import 'modules/invoices/providers/invoice.provider.dart';
import 'modules/invoices/providers/invoices.provider.dart';
import 'modules/invoices/screens/invoice.dart';
import 'modules/invoices/screens/invoices.dart';
import 'modules/notifications/providers/notification.provider.dart';
import 'modules/orders/providers/order.provider.dart';
import 'modules/orders/providers/orders.provider.dart';
import 'modules/orders/screens/order.dart';
import 'modules/orders/screens/orders.dart';
import 'modules/parts/providers/part-create.provider.dart';
import 'modules/parts/providers/parts.provider.dart';
import 'modules/parts/screens/part.dart';
import 'modules/parts/screens/parts.dart';
import 'modules/promotions/providers/create-promotion.provider.dart';
import 'modules/shop/providers/shop-alert-make.provider.dart';
import 'modules/shop/providers/shop-appointment.provider.dart';
import 'modules/shop/providers/shop.provider.dart';
import 'modules/shop/screens/shop-alerts.dart';
import 'modules/shop/screens/shop-product-details.dart';
import 'modules/shop/screens/shop-service-details.dart';
import 'modules/shop/screens/shop.dart';
import 'modules/user-details/screens/user-details.dart';
import 'modules/work-estimate-form/providers/work-estimate-accept.provider.dart';
import 'modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'modules/work-estimates/providers/work-estimates.provider.dart';
import 'modules/work-estimates/screens/work-estimates.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final prefs = await SharedPreferences.getInstance();
  setupDependencyInjection(prefs);

  var configuredApp = AppConfig(
    enviroment: Enviroment.Dev_Toolbar,
    child: App(),
  );
  runApp(configuredApp);

  FirebaseManager.getInstance().initialise();
  FirestoreManager.getInstance().initialise();
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
          ChangeNotifierProvider.value(value: AuctionProvider()),
          ChangeNotifierProvider.value(value: AuctionConsultantProvider()),
          ChangeNotifierProvider.value(value: WorkEstimateProvider()),
          ChangeNotifierProvider.value(value: WorkEstimateAcceptProvider()),
          ChangeNotifierProvider.value(value: SelectPartsProviderProvider()),
          ChangeNotifierProvider.value(value: AppointmentConsultantProvider()),
          ChangeNotifierProvider.value(value: AppointmentMechanicProvider()),
          ChangeNotifierProvider.value(value: ServiceProviderDetailsProvider()),
          ChangeNotifierProvider.value(
              value: WorkEstimatesProvider()),
          ChangeNotifierProvider.value(
              value: PickUpCarFormConsultantProvider()),
          ChangeNotifierProvider.value(value: CarReceptionFormProvider()),
          ChangeNotifierProvider.value(value: DashboardProvider()),
          ChangeNotifierProvider.value(value: ShopProvider()),
          ChangeNotifierProvider.value(value: ShopAlertMakeProvider()),
          ChangeNotifierProvider.value(value: ShopAppointmentProvider()),
          ChangeNotifierProvider.value(value: PartsProvider()),
          ChangeNotifierProvider.value(value: PartCreateProvider()),
          ChangeNotifierProvider.value(value: OrdersProvider()),
          ChangeNotifierProvider.value(value: CameraProvider()),
          ChangeNotifierProvider.value(value: NotificationProvider()),
          ChangeNotifierProvider.value(value: OrderProvider()),
          ChangeNotifierProvider.value(value: PromotionsProvider()),
          ChangeNotifierProvider.value(value: CreatePromotionProvider()),
          ChangeNotifierProvider.value(value: InvoicesProvider()),
          ChangeNotifierProvider.value(value: InvoiceProvider()),
        ],
        child: Consumer<Auth>(builder: (context, authProvider, _) {
          return OverlaySupport(
            child: MaterialApp(
              home: authProvider.isAuth
                  ? NavigationToolbarApp(
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
                  headline:
                      TextStyle(fontFamily: 'Lato', color: Colors.black54),
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
                Shop.route: (context) => Shop(),
                ShopAlerts.route: (context) => ShopAlerts(),
                ShopServiceDetails.route: (context) => ShopServiceDetails(),
                ShopProductDetails.route: (context) => ShopProductDetails(),
                AuctionDetails.route: (context) => AuctionDetails(),
                AuctionConsultant.route: (context) => AuctionConsultant(),
                AuctionConsultantMap.route: (context) => AuctionConsultantMap(),
                AppointmentDetailsMap.route: (context) =>
                    AppointmentDetailsMap(),
                BidDetails.route: (context) => BidDetails(),
                AppointmentDetailsConsultant.route: (context) =>
                    AppointmentDetailsConsultant(),
                AppointmentDetailsMechanic.route: (context) =>
                    AppointmentDetailsMechanic(),
                UserDetails.route: (context) => UserDetails(),
                UserDetailsConsultant.route: (context) =>
                    UserDetailsConsultant(),
                WorkEstimates.route: (context) =>
                    WorkEstimates(),
                Notifications.route: (context) => Notifications(),
                Parts.route: (context) => Parts(),
                Part.route: (context) => Part(),
                Orders.route: (context) => Orders(),
                OrderDetails.route: (context) => OrderDetails(),
                Promotions.route: (context) => Promotions(),
                Invoices.route: (context) => Invoices(),
                InvoiceDetail.route: (context) => InvoiceDetail()
              },
            ),
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
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
