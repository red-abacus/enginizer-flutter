import 'package:enginizer_flutter/modules/cars/providers/cars-make.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboad extends StatefulWidget {
  static const String route = '/dashboard';
  static final IconData icon = Icons.rss_feed;

  @override
  _DashboadState createState() => _DashboadState();
}

class _DashboadState extends State<Dashboad> {
  @override
  Widget build(BuildContext context) {
    Provider.of<CarsMakeProvider>(context).loadCarBrands();
    return new Center(child: CircularProgressIndicator());
  }
}
