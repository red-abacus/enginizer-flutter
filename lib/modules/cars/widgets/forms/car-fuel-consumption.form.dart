import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car-fuel-consumption.model.dart';
import 'package:app/modules/cars/providers/car.provider.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/shared/widgets/datepicker.widget.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/snack_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarFuelConsumptionForm extends StatefulWidget {
  Function createFuelConsumption;
  GlobalKey<ScaffoldState> scaffoldKey;

  CarFuelConsumptionForm({this.createFuelConsumption, this.scaffoldKey});

  @override
  CarFuelConsumptionFormState createState() => CarFuelConsumptionFormState();
}

class CarFuelConsumptionFormState extends State<CarFuelConsumptionForm> {
  final nrKmsController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  DateTime fuelDate;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            margin: EdgeInsets.only(left: 40, right: 40, top: 120, bottom: 120),
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : _container();
  }

  _container() {
    return Dialog(
        child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  BasicDateField(
                      labelText: S.of(context).car_details_fuel_date,
                      validator: (value) {
                        if (value == null) {
                          return S.of(context).car_details_fuel_date_error;
                        } else {
                          return null;
                        }
                      },
                      onChange: (value) {
                        this.fuelDate = value;
                      }),
                  TextFormField(
                      decoration: InputDecoration(
                          labelText: S.of(context).car_details_fuel_date_km),
                      controller: nrKmsController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || int.tryParse(value) == null) {
                          return S.of(context).car_details_fuel_date_km_error;
                        } else {
                          return null;
                        }
                      }),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: S.of(context).car_details_fuel_price),
                    keyboardType: TextInputType.number,
                    controller: quantityController,
                    validator: (value) {
                      if (value == null || double.tryParse(value) == null) {
                        return S.of(context).car_details_fuel_price_error;
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: S.of(context).car_details_quantity),
                    keyboardType: TextInputType.number,
                    controller: priceController,
                    validator: (value) {
                      if (value == null || double.tryParse(value) == null) {
                        return S.of(context).car_details_quantity_empty;
                      } else {
                        return null;
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  RaisedButton(
                    child: Text("Add data"),
                    onPressed: () {
                      _createFuelConsumption();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                ],
              ),
            )));
  }

  _createFuelConsumption() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      CarFuelConsumption carFuelConsumption = CarFuelConsumption(
          createdDate: DateUtils.stringFromDate(this.fuelDate, 'dd/MM/yyyy'),
          price: double.tryParse(priceController.text),
          quantity: double.tryParse(quantityController.text),
          nrOfKms: int.tryParse(nrKmsController.text));

      CarProvider carProvider = Provider.of<CarProvider>(context);

      try {
        await carProvider.addCarFuelConsumption(carFuelConsumption).then((value) {
          if (value != null) {
            widget.createFuelConsumption();
            Navigator.pop(context);
          } else {
            setState(() {
              _isLoading = false;
            });
          }
        });
      } catch (error) {
        if (error.toString().contains(CarService.CAR_ADD_FUEL_EXCEPTION)) {
          SnackBarManager.showSnackBar(
              S.of(context).general_error,
              S.of(context).exception_car_add_fuel_consumption,
              widget.scaffoldKey.currentState);
        }

        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
