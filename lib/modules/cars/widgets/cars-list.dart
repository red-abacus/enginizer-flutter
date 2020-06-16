import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/widgets/cards/car-card.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';

class CarList extends StatelessWidget {
  List<Car> cars = [];
  Function filterCars;
  Function selectCar;
  Function openAppointmentCreateModal;
  final Function sellCar;
  final Function rentCar;

  CarList(
      {this.cars,
      this.filterCars,
      this.selectCar,
      this.openAppointmentCreateModal,
      this.sellCar,
      this.rentCar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 60,
              margin: EdgeInsets.only(top: 10.0, bottom: 10),
              child: TextField(
                key: Key('searchBar'),
                autofocus: false,
                decoration: InputDecoration(
                    labelText: S.of(context).cars_list_search_hint),
                onChanged: (val) {
                  this.filterCars(context, val);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return CarCard(
                    car: this.cars.elementAt(index),
                    selectCar: this.selectCar,
                    openAppointmentCreateModal: this.openAppointmentCreateModal,
                    sellCar: this.sellCar,
                      rentCar: this.rentCar,
                  );
                },
                itemCount: this.cars.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
