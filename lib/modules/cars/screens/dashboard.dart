import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  static const String route = '/dashboard';
  static final IconData icon = Icons.dashboard;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return new Center(child: CircularProgressIndicator());
  }
}
