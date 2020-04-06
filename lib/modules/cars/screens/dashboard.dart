import 'package:app/modules/cars/models/car-query.model.dart';
import 'package:app/modules/cars/providers/cars-make.provider.dart';
import 'package:app/utils/locale.manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  static const String route = '/dashboard';
  static final IconData icon = Icons.dashboard;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    Provider.of<CarsMakeProvider>(context).loadCarBrands(CarQuery(language: LocaleManager.language(context)));
    return new Center(child: CircularProgressIndicator());
  }
}
