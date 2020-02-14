import 'package:enginizer_flutter/modules/cars/models/car-fuel-comsumtion.model.dart';
import 'package:enginizer_flutter/modules/cars/providers/car.provider.dart';
import 'package:enginizer_flutter/modules/cars/providers/cars-make.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarFuelConsumptionForm extends StatefulWidget {
  Function callback;

  CarFuelConsumptionForm(this.callback);

  @override
  CarFuelConsumptionFormState createState() => CarFuelConsumptionFormState();
}

class CarFuelConsumptionFormState extends State<CarFuelConsumptionForm> {
  final dateController = TextEditingController();
  final nrKmsController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var carProvider = Provider.of<CarProvider>(context);
    return Dialog(
        child: Container(
//                height: MediaQuery.of(context).size.height / 2,
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: "Date"),
                  keyboardType: TextInputType.datetime,
                  controller: dateController,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Km drove until last gas fueling"),
                  controller: nrKmsController,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Quantity"),
                  keyboardType: TextInputType.number,
                  controller: quantityController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Gas price"),
                  keyboardType: TextInputType.number,
                  controller: priceController,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                RaisedButton(
                  child: Text("Add data"),
                  onPressed: () {
                    carProvider.addCarFuelConsumption(CarFuelConsumption(
                        createdDate: dateController.text,
                        price: int.parse(priceController.text),
                        quantity: int.parse(priceController.text),
                        nrOfKms: int.parse(nrKmsController.text)));
                    widget.callback();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.button.color,
                ),
              ],
            )));
  }
}
