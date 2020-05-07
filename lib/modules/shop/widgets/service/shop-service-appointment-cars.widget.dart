import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/shop/cards/shop-appointment-car.card.dart';
import 'package:app/modules/shop/providers/shop-appointment.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopServiceAppointmentCarsWidget extends StatefulWidget {
  final Function searchCars;
  final Function selectCar;

  ShopServiceAppointmentCarsWidget({this.searchCars, this.selectCar});

  @override
  _ShopServiceAppointmentCarsWidgetState createState() =>
      _ShopServiceAppointmentCarsWidgetState();
}

class _ShopServiceAppointmentCarsWidgetState
    extends State<ShopServiceAppointmentCarsWidget> {
  ShopAppointmentProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<ShopAppointmentProvider>(context);

    return Container(
      margin: EdgeInsets.only(bottom: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: TextField(
              key: Key('searchBar'),
              autofocus: false,
              decoration: InputDecoration(labelText: 'Find car'),
              onChanged: (val) {
                widget.searchCars(val);
              },
            ),
          ),
          _listContainer(),
        ],
      ),
    );
  }

  _listContainer() {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, index) {
          return ShopAppointmentCarCard(
            car: _provider.cars[index],
            selectCar: _selectCar,
            selectedCar: _provider.selectedCar,
          );
        },
        itemCount: _provider.cars.length,
      ),
    );
  }

  _selectCar(Car car) {
    widget.selectCar(car);
  }
}
