import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:enginizer_flutter/modules/cars/providers/car.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarDetails extends StatefulWidget {
  final String route = '/car';

  Car model;

  @override
  State<StatefulWidget> createState() {
    return CarDetailsState();
  }
}

class CarDetailsState extends State<CarDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Car model;

  @override
  Widget build(BuildContext context) {
    return Consumer<CarProvider>(
      builder: (context, carProvider, _) => Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('${carProvider.selectedCar.brand.name}'),
            iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
          ),
          body: Center(
              child: Text('${carProvider.selectedCar.registrationNumber}')),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 1,
            child: Icon(Icons.add),
          )),
    );
  }
}
