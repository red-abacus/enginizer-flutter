import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/screens/appointments.dart';
import 'package:app/modules/auctions/screens/auctions.dart';
import 'package:app/modules/authentication/models/jwt-user-details.model.dart';
import 'package:app/modules/authentication/models/jwt-user.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/authentication/providers/user.provider.dart';
import 'package:app/modules/cars/screens/cars.dart';
import 'package:app/modules/consultant-estimators/screens/work-estimates-consultant.dart';
import 'package:app/modules/consultant-user-details/provider/user-consultant.provider.dart';
import 'package:app/modules/consultant-user-details/screens/user-details-consultant.dart';
import 'package:app/modules/notifications/screens/notifications.dart';
import 'package:app/modules/orders/screens/orders.dart';
import 'package:app/modules/parts/screens/parts.dart';
import 'package:app/modules/promotions/screens/promotions.screen.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:app/modules/shared/managers/permissions/permissions-side-bar.dart';
import 'package:app/modules/shared/widgets/notifications-manager.dart';
import 'package:app/modules/shop/screens/shop.dart';
import 'package:app/modules/user-details/screens/user-details.dart';
import 'package:app/utils/app_config.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/firebase/firebase_manager.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
  final JwtUserDetails authUserDetails;

  static final List<DrawerItem> adminDrawerItems = [];

  static List<DrawerItem> userDrawerItems(BuildContext context) {
    return AppConfig.of(context).enviroment == Enviroment.Dev
        ? [
            new DrawerItem("Dashboard", Dashboard.route, Icons.dashboard),
            new DrawerItem("Cars", Cars.route, Icons.directions_car),
            new DrawerItem(
                "Appointments", Appointments.route, Icons.event_available),
            new DrawerItem("Auctions", Auctions.route, Icons.dashboard),
            new DrawerItem(S.of(context).online_shop_title, Shop.route,
                Icons.shopping_cart),
            new DrawerItem(
                'Notifications',
                Notifications.route,
                NotificationsManager.notificationsCount == 0
                    ? Icons.notifications
                    : Icons.notifications_active)
          ]
        : [new DrawerItem("Cars", Cars.route, Icons.directions_car)];
  }

  static final List<DrawerItem> providerAdminDrawerItems = [
    new DrawerItem("Promotions", Promotions.route, Promotions.icon)
  ];

  List<DrawerItem> get consultantDrawerItems {
    List<DrawerItem> items = [];

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Sidebar, PermissionsSideBar.APPOINTMENT)) {
      items.add(
          new DrawerItem("Appointments", Appointments.route, Icons.dashboard));
    }

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Sidebar, PermissionsSideBar.AUCTION)) {
      items.add(new DrawerItem("Auctions", Auctions.route, Icons.dashboard));
    }

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Sidebar, PermissionsSideBar.WORK_ESTIMATE)) {
      items.add(new DrawerItem(
          "Work Estimates", WorkEstimatesConsultant.route, Icons.dashboard));
    }

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Sidebar, PermissionsSideBar.PARTS)) {
      items.add(new DrawerItem('Parts', Parts.route, Parts.icon));
    }

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Sidebar, PermissionsSideBar.ORDERS)) {
      items.add(new DrawerItem('Orders', Orders.route, Orders.icon));
    }

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Sidebar, PermissionsSideBar.NOTIFICATIONS)) {
      items.add(new DrawerItem(
          'Notifications', Notifications.route, Icons.notifications));
    }

    return items;
  }

  static final List<DrawerItem> mechanicDrawerItems = [
    new DrawerItem("Appointments", Appointments.route, Icons.event_available),
    new DrawerItem('Notifications', Notifications.route, Icons.notifications)
  ];

  NavigationApp({this.authUser, this.authUserDetails});

  String get activeDrawerRoute {
    switch (this.authUser.role) {
      case Roles.Super:
        return Dashboard.route;
      case Roles.Client:
        return Cars.route;
      case Roles.ProviderAdmin:
        return Promotions.route;
      case Roles.ProviderConsultant:
        return consultantDrawerItems.first.route;
      case Roles.ProviderPersonnel:
        return Appointments.route;
      default:
        return '/';
    }
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
      widget.activeDrawerItems = _initActiveDrawerItems();
    }

    var auth = Provider.of<Auth>(context);
    if (_selectedDrawerRoute == null) {
      _selectedDrawerRoute = widget.activeDrawerRoute;
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
        child: Column(children: [
          FlatButton(
            padding: EdgeInsets.all(0.0),
            child: UserAccountsDrawerHeader(
              accountEmail: Text(widget.authUserDetails.email),
              accountName: Text(widget.authUserDetails.name),
              currentAccountPicture: CircleAvatar(),
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
      body: _getDrawerItemWidget(_selectedDrawerRoute),
    );
  }

  _initActiveDrawerItems() {
    switch (widget.authUser.role) {
      case Roles.Super:
        return NavigationApp.adminDrawerItems;
      case Roles.Client:
        return NavigationApp.userDrawerItems(context);
      case Roles.ProviderAdmin:
        return NavigationApp.providerAdminDrawerItems;
      case Roles.ProviderConsultant:
        return widget.consultantDrawerItems;
      case Roles.ProviderPersonnel:
        return NavigationApp.mechanicDrawerItems;
      default:
        return [];
    }
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
      case WorkEstimatesConsultant.route:
        return WorkEstimatesConsultant();
      case Notifications.route:
        return Notifications();
      case Parts.route:
        return Parts();
      case Orders.route:
        return Orders();
      case Promotions.route:
        return Promotions();
      default:
        return new Text("Error");
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
                            null, Colors.white, FontWeight.bold, 12))
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
          Provider.of<UserProvider>(context, listen: false).userDetails =
              Provider.of<Auth>(context).authUserDetails;

          setState(() => _selectedDrawerRoute = UserDetails.route);
          Navigator.of(context).pop(); // close the drawer
        }
        break;
      case Roles.ProviderConsultant:
        Provider.of<UserConsultantProvider>(context, listen: false)
            .userDetails = Provider.of<Auth>(context).authUserDetails;

        setState(() => _selectedDrawerRoute = UserDetailsConsultant.route);
        Navigator.of(context).pop(); // close the drawer
        break;
      case Roles.ProviderPersonnel:
        Provider.of<UserConsultantProvider>(context, listen: false)
            .userDetails = Provider.of<Auth>(context).authUserDetails;

        setState(() => _selectedDrawerRoute = UserDetailsConsultant.route);
        Navigator.of(context).pop(); // close the drawer
        break;
      case Roles.ProviderAdmin:
        Provider.of<UserConsultantProvider>(context, listen: false)
            .userDetails = Provider.of<Auth>(context).authUserDetails;

        setState(() => _selectedDrawerRoute = UserDetailsConsultant.route);
        Navigator.of(context).pop(); // close the drawer
        break;
      default:
        return '/';
    }
  }
}
