import 'package:enginizer_flutter/modules/appointments/screens/appointments.dart';
import 'package:enginizer_flutter/modules/auctions/screens/auctions.dart';
import 'package:enginizer_flutter/modules/authentication/providers/auth.provider.dart';
import 'package:enginizer_flutter/modules/cars/screens/cars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modules/cars/screens/dashboard.dart';

class DrawerItem {
  String title;
  String route;
  IconData icon;

  DrawerItem(this.title, this.route, this.icon);
}

class NavigationApp extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Dashboard", Dashboad.route, Icons.rss_feed),
    new DrawerItem("Cars", Cars.route, Icons.local_pizza),
    new DrawerItem("Appointments", Appointments.route, Icons.account_balance_wallet),
    new DrawerItem("Auctions", Auctions.route, Icons.account_balance_wallet)
  ];

  @override
  _NavigationAppState createState() => _NavigationAppState();
}

class _NavigationAppState extends State<NavigationApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // TODO - remove this
  String _selectedDrawerRoute = Appointments.route;
//  String _selectedDrawerRoute = Cars.route;

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
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
          UserAccountsDrawerHeader(
            accountEmail: Text('Email'),
            accountName: Text('Name'),
            currentAccountPicture: CircleAvatar(),
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
      case Dashboad.route:
        return Dashboad();
      case Cars.route:
        return Cars();
      case Appointments.route:
        return Appointments();
      case Auctions.route:
        return Auctions();
      default:
        return new Text("Error");
    }
  }

  List<Widget> _buildDrawerOptions() {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: d.route == _selectedDrawerRoute,
        onTap: () => _onSelectItem(d.route),
      ));
    }
    return drawerOptions;
  }
}
