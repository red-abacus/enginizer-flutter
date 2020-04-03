import 'package:app/modules/appointments/widgets/cards/appointment-car-card.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentCreateSelectCarList extends StatelessWidget {
  List<Car> cars = [];
  Function selectCar;
  final Car selectedCar;

  AppointmentCreateSelectCarList({this.cars, this.selectCar, this.selectedCar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: TextField(
                key: Key('searchBar'),
                autofocus: false,
                decoration: InputDecoration(labelText: 'Find car'),
                onChanged: (val) {
                  print(val);
                },
              ),
            ),
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return AppointmentCarCard(
                      car: this.cars[index],
                      selectCar: this.selectCar,
                      selectedCar: this.selectedCar,
                    );
                  },
                  itemCount: this.cars.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
