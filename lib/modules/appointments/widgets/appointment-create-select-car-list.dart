import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/widgets/cards/appointment-car-card.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/material.dart';

class AppointmentCreateSelectCarList extends StatelessWidget {
  List<Car> cars = [];
  Function selectCar;
  final Car selectedCar;

  AppointmentCreateSelectCarList({this.cars, this.selectCar, this.selectedCar});

  @override
  Widget build(BuildContext context) {
    return cars.isEmpty
        ? Center(
            child: Text(
              S.of(context).no_car_available_alert,
              style: TextHelper.customTextStyle(color: gray3, size: 16),
            ),
          )
        : Container(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 40),
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
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return AppointmentCarCard(
                      car: this.cars[index],
                      selectCar: this.selectCar,
                      selectedCar: this.selectedCar,
                    );
                  },
                  itemCount: this.cars.length,
                )
              ],
            ),
          );
  }
}
