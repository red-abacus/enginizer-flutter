import 'package:enginizer_flutter/modules/appointments/screens/appointments.dart';
import 'package:enginizer_flutter/modules/auctions/screens/auctions.dart';
import 'package:enginizer_flutter/modules/authentication/models/jwt-user-details.model.dart';
import 'package:enginizer_flutter/modules/authentication/models/jwt-user.model.dart';
import 'package:enginizer_flutter/modules/authentication/models/roles.model.dart';
import 'package:enginizer_flutter/modules/authentication/providers/auth.provider.dart';
import 'package:enginizer_flutter/modules/authentication/providers/user.provider.dart';
import 'package:enginizer_flutter/modules/cars/screens/cars.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/screens/appointments-consultant.dart';
import 'package:enginizer_flutter/modules/consultant-user-details/provider/user-consultant.provider.dart';
import 'package:enginizer_flutter/modules/consultant-user-details/screens/user-details-consultant.dart';
import 'package:enginizer_flutter/modules/user-details/screens/user-details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modules/auctions/screens/auctions.dart';
import '../modules/cars/screens/dashboard.dart';

class DrawerItem {
  String title;
  String route;
  IconData icon;

  DrawerItem(this.title, this.route, this.icon);
}

class NavigationApp extends StatefulWidget {
  final JwtUser authUser;
  final JwtUserDetails authUserDetails;

  static final List<DrawerItem> adminDrawerItems = [];

  static final List<DrawerItem> userDrawerItems = [
    new DrawerItem("Dashboard", Dashboard.route, Icons.dashboard),
    new DrawerItem("Cars", Cars.route, Icons.directions_car),
    new DrawerItem("Appointments", Appointments.route, Icons.event_available),
    new DrawerItem("Auctions", Auctions.route, Icons.dashboard)
  ];

  static final List<DrawerItem> providerDrawerItems = [];

  static final List<DrawerItem> consultantDrawerItems = [
    new DrawerItem(
        "Appointments", AppointmentsConsultant.route, Icons.event_available),
    new DrawerItem("Auctions", Auctions.route, Icons.dashboard)
  ];

  NavigationApp({this.authUser, this.authUserDetails});

  String get activeDrawerRoute {
    switch (this.authUser.role) {
      case Roles.Super:
        return Dashboard.route;
      case Roles.Client:
        return Cars.route;
      case Roles.ProviderAdmin:
        // TODO: Replace Dashboard with Profile when the profile screen is implemented
        return Dashboard.route;
      case Roles.ProviderConsultant:
        return AppointmentsConsultant.route;
      default:
        return '/';
    }
  }

  List<DrawerItem> get activeDrawerItems {
    switch (this.authUser.role) {
      case Roles.Super:
        return NavigationApp.adminDrawerItems;
      case Roles.Client:
        return NavigationApp.userDrawerItems;
      case Roles.ProviderAdmin:
        return NavigationApp.providerDrawerItems;
      case Roles.ProviderConsultant:
        return NavigationApp.consultantDrawerItems;
      default:
        return [];
    }
  }

  @override
  _NavigationAppState createState() => _NavigationAppState();
}

class _NavigationAppState extends State<NavigationApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _selectedDrawerRoute;

  @override
  Widget build(BuildContext context) {
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
      case AppointmentsConsultant.route:
        return AppointmentsConsultant();
      case UserDetailsConsultant.route:
        return UserDetailsConsultant();
      default:
        return new Text("Error");
    }
  }

  List<Widget> _buildDrawerOptions() {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.activeDrawerItems.length; i++) {
      var d = widget.activeDrawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: d.route == _selectedDrawerRoute,
        onTap: () => _onSelectItem(d.route),
      ));
    }
    return drawerOptions;
  }

  _showUserDetails() {
    switch (widget.authUser.role) {
      case Roles.Client:
        Provider.of<UserProvider>(context, listen: false).userDetails =
            Provider.of<Auth>(context).authUserDetails;

        setState(() => _selectedDrawerRoute = UserDetails.route);
        Navigator.of(context).pop(); // close the drawer
        break;
      case Roles.ProviderConsultant:
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
