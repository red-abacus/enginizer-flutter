import 'package:app/modules/appointments/screens/appointments.dart';
import 'package:app/modules/auctions/screens/auctions.dart';
import 'package:app/modules/authentication/models/jwt-user-details.model.dart';
import 'package:app/modules/authentication/models/jwt-user.model.dart';
import 'package:app/modules/authentication/models/roles.model.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/authentication/providers/user.provider.dart';
import 'package:app/modules/cars/screens/cars.dart';
import 'package:app/modules/consultant-user-details/provider/user-consultant.provider.dart';
import 'package:app/modules/consultant-user-details/screens/user-details-consultant.dart';
import 'package:app/modules/invoices/screens/invoices.dart';
import 'package:app/modules/notifications/screens/notifications.dart';
import 'package:app/modules/orders/screens/orders.dart';
import 'package:app/modules/promotions/screens/promotions.screen.dart';
import 'package:app/modules/shared/widgets/notifications-manager.dart';
import 'package:app/modules/shop/screens/shop.dart';
import 'package:app/modules/user-details/screens/user-details-consultant.dart';
import 'package:app/modules/user-details/screens/user-details.dart';
import 'package:app/modules/work-estimates/screens/work-estimates.dart';
import 'package:app/utils/app_config.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/firebase/firebase_manager.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modules/auctions/screens/auctions.dart';
import '../modules/dashboard/screens/dashboard.dart';
import 'navigation.app.dart';

class BottomBarItem {
  String title;
  String route;
  IconData icon;

  BottomBarItem(this.title, this.route, this.icon);
}

class NavigationToolbarApp extends StatefulWidget {
  final JwtUser authUser;
  final JwtUserDetails authUserDetails;

  NavigationToolbarApp({this.authUser, this.authUserDetails});

  String get activeDrawerRoute {
    switch (this.authUser.role) {
      case Roles.Super:
        return Dashboard.route;
      case Roles.Client:
        return Cars.route;
      case Roles.ProviderAdmin:
        return Promotions.route;
      case Roles.ProviderConsultant:
        return Appointments.route;
      case Roles.ProviderPersonnel:
        return Appointments.route;
      default:
        return '/';
    }
  }

  List<DrawerItem> activeDrawerItems;

  @override
  NavigationToolbarAppState createState() => NavigationToolbarAppState();
}

class NavigationToolbarAppState extends State<NavigationToolbarApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _selectedDrawerRoute;

  @override
  Widget build(BuildContext context) {
    FirebaseManager.getInstance().setContext(context);
    NotificationsManager.navigationToolbarAppState = this;

    if (widget.activeDrawerItems == null) {
      widget.activeDrawerItems = [];
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
      bottomNavigationBar: bottomBarApp,
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
      case Orders.route:
        return Orders();
      case Notifications.route:
        return Notifications();
      case Promotions.route:
        return Promotions();
      case Invoices.route:
        return Invoices();
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
                            color: Colors.white, weight: FontWeight.bold, size: 12))
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
          // TODO
//          Provider.of<UserProvider>(context).userDetails =
//              Provider.of<Auth>(context).authUserDetails;
//
//          setState(() => _selectedDrawerRoute = UserDetails.route);
//          Navigator.of(context).pop(); // close the drawer
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
      default:
        return '/';
    }
  }

  //region Bottom bar
  static final List<BottomBarItem> mechanicBarItems = [
    BottomBarItem(
        'Appointments', Appointments.route, Icons.event_available),
    BottomBarItem('Notifications', Notifications.route, Icons.notifications),
  ];

  static final BottomAppBar bottomBarApp = new BottomAppBar(
    child: Container(
      height: 50,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buildBottomBarOptions(),
      ),
    ),
    shape: CircularNotchedRectangle(),
    color: red,
  );

  static List<Widget> _buildBottomBarOptions() {
    List<Widget> items = [];
    for (BottomBarItem item in mechanicBarItems) {
      items.add(
        Expanded(
          flex: 1,
          child: FlatButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  item.icon,
                  color: Colors.white,
                ),
                Text(
                  item.title,
                  style:
                      TextHelper.customTextStyle(color: Colors.white),
                )
              ],
            ),
            onPressed: () {
              NotificationsManager.navigationToolbarAppState
                  ._onSelectItem(item.route);
            },
          ),
        ),
      );
    }
    return items;
  }
//endregion
}
