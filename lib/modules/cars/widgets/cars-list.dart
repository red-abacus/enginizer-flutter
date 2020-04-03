import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/widgets/car-card.dart';
import 'package:flutter/material.dart';

class CarList extends StatelessWidget {
  List<Car> cars = [];
  Function filterCars;
  Function selectCar;
  Function openAppointmentCreateModal;

  CarList({this.cars, this.filterCars, this.selectCar, this.openAppointmentCreateModal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      width: MediaQuery.of(context).size.width * .9,
      height: MediaQuery.of(context).size.height * .9,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: MediaQuery.of(context).size.height * .1,
                child: Container(
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
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return CarCard(
                    car: this.cars.elementAt(index),
                    selectCar: this.selectCar,
                    openAppointmentCreateModal: this.openAppointmentCreateModal,
                  );
                },
                itemCount: this.cars.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
