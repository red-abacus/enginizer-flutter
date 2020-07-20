import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/screens/appointments.dart';
import 'package:app/modules/auctions/screens/auctions.dart';
import 'package:app/modules/authentication/models/jwt-user.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/authentication/models/user-provider.model.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/cars/screens/cars.dart';
import 'package:app/modules/consultant-user-details/screens/user-details-consultant.dart';
import 'package:app/modules/extra-services/screens/extra-services.dart';
import 'package:app/modules/invoices/screens/invoices.dart';
import 'package:app/modules/notifications/screens/notifications.dart';
import 'package:app/modules/orders/screens/orders.dart';
import 'package:app/modules/parts/screens/parts.dart';
import 'package:app/modules/promotions/screens/promotions.screen.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:app/modules/shared/managers/permissions/permissions-side-bar.dart';
import 'package:app/modules/shared/widgets/notifications-manager.dart';
import 'package:app/modules/shop/screens/shop.dart';
import 'package:app/modules/user-details/screens/user-details.dart';
import 'package:app/modules/work-estimates/screens/work-estimates.dart';
import 'package:app/utils/app_config.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/firebase/firebase_manager.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../modules/auctions/screens/auctions.dart';
import '../modules/dashboard/screens/dashboard.dart';

class DrawerItem {
  String title;
  String route;
  IconData icon;
  SvgPicture svgPicture;

  DrawerItem(this.title, this.route, this.icon, {this.svgPicture});
}

class NavigationApp extends StatefulWidget {
  final JwtUser authUser;

  List<DrawerItem> _drawerItems;

  List<DrawerItem> getDrawerItems(BuildContext context) {
    if (_drawerItems != null) {
      return _drawerItems;
    }

    List<DrawerItem> items = [];

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Sidebar, PermissionsSideBar.DASHBOARD)) {
      items.add(new DrawerItem(
          S.of(context).dashboard_dashboard, Dashboard.route, Icons.dashboard));
    }

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Sidebar, PermissionsSideBar.CARS)) {
      items.add(new DrawerItem(
          S.of(context).dashboard_cars, Cars.route, Icons.directions_car));
    }

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Sidebar, PermissionsSideBar.APPOINTMENT)) {
      items.add(new DrawerItem(S.of(context).dashboard_appointments,
          Appointments.route, Icons.event_available));
    }

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Sidebar, PermissionsSideBar.AUCTION)) {
      items.add(new DrawerItem(
          S.of(context).dashboard_auctions, Auctions.route, Icons.dashboard));
    }

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Sidebar, PermissionsSideBar.SHOP)) {
      items.add(new DrawerItem(
          S.of(context).dashboard_shop, Shop.route, Icons.shopping_cart));
    }

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Sidebar, PermissionsSideBar.PARTS)) {
      items.add(new DrawerItem(
          S.of(context).dashboard_parts, Parts.route, Parts.icon));
    }

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Sidebar, PermissionsSideBar.ORDERS)) {
      items.add(new DrawerItem(
          S.of(context).dashboard_orders, Orders.route, Orders.icon));
    }

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Sidebar, PermissionsSideBar.PROMOTIONS)) {
      items.add(new DrawerItem(S.of(context).dashboard_promotions,
          Promotions.route, Promotions.icon));
    }

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Sidebar, PermissionsSideBar.INVOICES)) {
      items.add(new DrawerItem(
          S.of(context).dashboard_invoices, Invoices.route, Invoices.icon));
    }

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Sidebar, PermissionsSideBar.WORK_ESTIMATE)) {
      items.add(new DrawerItem(S.of(context).dashboard_work_estimate_history,
          WorkEstimates.route, WorkEstimates.icon));
    }

    if (PermissionsManager.getInstance().hasAccess(
        MainPermissions.Sidebar, PermissionsSideBar.EXTRA_SERVICES)) {
      items.add(new DrawerItem(S.of(context).dashboard_extra_services,
          ExtraServices.route, ExtraServices.icon));
    }

    items.add(new DrawerItem(
        S.of(context).dashboard_notifications,
        Notifications.route,
        NotificationsManager.notificationsCount == 0
            ? Icons.notifications
            : Icons.notifications_active));

    return items;
  }

  NavigationApp({this.authUser});

  String _activeDrawerRoute;

  String getActiveDrawerRoute(BuildContext context) {
    if (_activeDrawerRoute != null) {
      return _activeDrawerRoute;
    }
    switch (this.authUser.role) {
      case Roles.Super:
        _activeDrawerRoute = Dashboard.route;
        break;
      case Roles.Client:
        _activeDrawerRoute = Cars.route;
        break;
      case Roles.ProviderAdmin:
        _activeDrawerRoute = Promotions.route;
        break;
      case Roles.ProviderConsultant:
        if (getDrawerItems(context).isNotEmpty) {
          _activeDrawerRoute = getDrawerItems(context).first.route;
        } else {
          _activeDrawerRoute = '/';
        }
        break;
      case Roles.ProviderPersonnel:
        _activeDrawerRoute = Appointments.route;
        break;
      default:
        _activeDrawerRoute = '/';
    }

    return _activeDrawerRoute;
  }

  List<DrawerItem> activeDrawerItems;

  @override
  NavigationAppState createState() => NavigationAppState();
}

class NavigationAppState extends State<NavigationApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _selectedDrawerRoute;

  @override
  Widget build(BuildContext context) {
    FirebaseManager.getInstance().setContext(context);
    NotificationsManager.navigationAppState = this;

    if (widget.activeDrawerItems == null) {
      widget.activeDrawerItems = widget.getDrawerItems(context);
    }

    var auth = Provider.of<Auth>(context);
    if (_selectedDrawerRoute == null || _selectedDrawerRoute == '/') {
      _selectedDrawerRoute = widget.getActiveDrawerRoute(context);
    }

    List<Widget> drawerOptions = _buildDrawerOptions();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('App'),
        iconTheme: new IconThemeData(color: Colors.white),
        actions: <Widget>[],
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 40),
          child: Column(children: [
            FlatButton(
              padding: EdgeInsets.all(0.0),
              child: UserAccountsDrawerHeader(
                accountEmail: Text(widget.authUser?.sub),
                accountName: Text(widget.authUser?.given_name),
                currentAccountPicture: ClipOval(
                  child: FadeInImage.assetNetwork(
                    image: widget.authUser?.profilePicture ?? '',
                    placeholder:
                        'assets/images/defaults/default_profile_icon.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              onPressed: () {
                _showUserDetails();
              },
            ),
            Column(
              children: drawerOptions,
            ),
            Divider(
              height: 1,
            ),
            Column(
              children: <Widget>[
                if (PermissionsManager.getInstance().hasAccess(
                    MainPermissions.Sidebar, PermissionsSideBar.TICKETS))
                  ListTile(
                      title: new Text(
                        S.of(context).dashboard_tax,
                        style: TextHelper.customTextStyle(),
                        textAlign: TextAlign.left,
                      ),
                      leading: new Icon(Icons.payment),
                      onTap: () async {
                        const url = "https://www.ghiseul.ro";
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          FlushBarHelper.showFlushBar(
                              S.of(context).general_error,
                              S.of(context).exception_open_url,
                              context);
                        }
                      }),
                ListTile(
                    title: new Text(
                      "Logout",
                      style: new TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    leading: new Icon(
                      Icons.power_settings_new,
                      color: Colors.red,
                    ),
                    onTap: () => auth.logout()),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            ),
          ]),
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerRoute),
    );
  }

  _onSelectItem(String route) {
    setState(() => _selectedDrawerRoute = route);
    Navigator.of(context).pop(); // close the drawer
  }

  _getDrawerItemWidget(String route) {
    switch (route) {
      case UserDetails.route:
        return UserDetails();
      case Dashboard.route:
        return Dashboard();
      case Cars.route:
        return Cars();
      case Appointments.route:
        return Appointments();
      case Auctions.route:
        return Auctions();
      case Shop.route:
        return Shop();
      case UserDetailsConsultant.route:
        return UserDetailsConsultant();
      case WorkEstimates.route:
        return WorkEstimates();
      case Notifications.route:
        return Notifications();
      case Parts.route:
        return Parts();
      case Orders.route:
        return Orders();
      case Promotions.route:
        return Promotions();
      case ExtraServices.route:
        return ExtraServices();
      case Invoices.route:
        return Invoices();
      default:
        return new Container();
    }
  }

  List<Widget> _buildDrawerOptions() {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.activeDrawerItems.length; i++) {
      var d = widget.activeDrawerItems[i];

      if (d.route == Notifications.route &&
          NotificationsManager.notificationsCount != 0) {
        drawerOptions.add(new ListTile(
          leading: new Icon(d.icon),
          title: new Row(
            children: <Widget>[
              Text(d.title),
              Container(
                margin: EdgeInsets.only(left: 4),
                decoration: new BoxDecoration(
                  color: red,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                width: 20,
                height: 20,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('${NotificationsManager.notificationsCount}',
                        style: TextHelper.customTextStyle(
                            color: Colors.white,
                            weight: FontWeight.bold,
                            size: 12))
                  ],
                ),
              )
            ],
          ),
          selected: d.route == _selectedDrawerRoute,
          onTap: () => _onSelectItem(d.route),
        ));
      } else {
        drawerOptions.add(new ListTile(
          leading: new Icon(d.icon),
          title: new Text(d.title),
          selected: d.route == _selectedDrawerRoute,
          onTap: () => _onSelectItem(d.route),
        ));
      }
    }
    return drawerOptions;
  }

  selectNotifications() {
    setState(() {
      _selectedDrawerRoute = Notifications.route;
    });
  }

  updateNotifications() {
    setState(() {
      widget.activeDrawerItems = null;
    });
  }

  _showUserDetails() {
    switch (widget.authUser.role) {
      case Roles.Client:
        if (AppConfig.of(context).enviroment == Enviroment.Dev) {
          setState(() => _selectedDrawerRoute = UserDetails.route);
          Navigator.of(context).pop(); // close the drawer
        }
        break;
      case Roles.ProviderConsultant:
        // TODO
//        Provider.of<UserConsultantProvider>(context, listen: false)
//            .userDetails = Provider.of<Auth>(context).authUserDetails;
//
//        setState(() => _selectedDrawerRoute = UserDetailsConsultant.route);
//        Navigator.of(context).pop(); // close the drawer
        break;
      case Roles.ProviderPersonnel:
        // TODO
//        Provider.of<UserConsultantProvider>(context, listen: false)
//            .userDetails = Provider.of<Auth>(context).authUserDetails;
//
//        setState(() => _selectedDrawerRoute = UserDetailsConsultant.route);
//        Navigator.of(context).pop(); // close the drawer
        break;
      case Roles.ProviderAdmin:
        // TODO
//        Provider.of<UserConsultantProvider>(context, listen: false)
//            .userDetails = Provider.of<Auth>(context).authUserDetails;
//
//        setState(() => _selectedDrawerRoute = UserDetailsConsultant.route);
//        Navigator.of(context).pop(); // close the drawer
        break;
      default:
        return '/';
    }
  }
}
