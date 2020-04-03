import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car-color.model.dart';
import 'package:app/modules/cars/models/car-cylinder-capacity.model.dart';
import 'package:app/modules/cars/models/car-power.model.dart';
import 'package:app/modules/cars/models/car-query.model.dart';
import 'package:app/modules/cars/models/car-transmissions.model.dart';
import 'package:app/modules/cars/providers/cars-make.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarTechnicalForm extends StatefulWidget {
  CarTechnicalForm({Key key}) : super(key: key);

  @override
  CarTechnicalFormState createState() => CarTechnicalFormState();
}

class CarTechnicalFormState extends State<CarTechnicalForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var carMakeProvider = Provider.of<CarsMakeProvider>(context);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // CAR Cylinder Capacity
            DropdownButtonFormField(
              hint: Text(S.of(context).cars_create_selectMotorCapacity),
              // Not necessary for Option 1
              items: _buildCylinderCapacityDropdownItems(
                  carMakeProvider.carCylinderCapacities),
              value: carMakeProvider.carTechnicalFormState['cylinderCapacity'],
              validator: (value) {
                if (value == null) {
                  return S.of(context).cars_create_error_CCNotSelected;
                } else {
                  return null;
                }
              },
              onChanged: (newValue) {
                carMakeProvider
                    .loadCarPowers(CarQuery(
                        brand: carMakeProvider.carMakeFormState['brand'],
                        model: carMakeProvider.carMakeFormState['model'],
                        year: carMakeProvider.carMakeFormState['year'],
                        fuelType: carMakeProvider.carMakeFormState['fuelType'],
                        cylinderCapacity: newValue))
                    .then((_) => {
                          setState(() {
                            carMakeProvider
                                    .carTechnicalFormState['cylinderCapacity'] =
                                newValue;
                          })
                        });
              },
            ),
            // CAR Power
            carMakeProvider.carTechnicalFormState['cylinderCapacity'] != null
                ? DropdownButtonFormField(
                    hint: Text(S.of(context).cars_create_selectPower),
                    items:
                        _buildCarPowerDropdownItems(carMakeProvider.carPowers),
                    value: carMakeProvider.carTechnicalFormState['power'],
                    validator: (value) {
                      if (value == null) {
                        return S.of(context).cars_create_error_PowerNotSelected;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (power) {
                      carMakeProvider.loadCarTransmissions().then((_) => {
                            setState(() {
                              carMakeProvider.carTechnicalFormState['power'] =
                                  power;
                            })
                          });
                    })
                : DropdownButtonFormField(
                    hint: Text(S.of(context).cars_create_selectPower)),
            // CAR Transmission
            carMakeProvider.carTechnicalFormState['power'] != null
                ? DropdownButtonFormField(
                    hint: Text(S.of(context).cars_create_selectTransmission),
                    items: _buildCarTransmissionDropdownItems(
                        carMakeProvider.carTransmissions),
                    value:
                        carMakeProvider.carTechnicalFormState['transmission'],
                    validator: (value) {
                      if (value == null) {
                        return S
                            .of(context)
                            .cars_create_error_transmissionNotSelected;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (selectedModel) {
                      carMakeProvider.loadCarColors().then((_) => {
                            setState(() {
                              carMakeProvider
                                      .carTechnicalFormState['transmission'] =
                                  selectedModel;
                            })
                          });
                    })
                : DropdownButtonFormField(
                    hint: Text(S.of(context).cars_create_selectTransmission)),
            carMakeProvider.carTechnicalFormState['transmission'] != null
                ? DropdownButtonFormField(
                    hint: Text(S.of(context).cars_create_selectColor),
                    items:
                        _buildCarColorDropdownItems(carMakeProvider.carColors),
                    value: carMakeProvider.carTechnicalFormState['color'],
                    validator: (value) {
                      if (value == null) {
                        return S.of(context).cars_create_error_ColorNotSelected;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (selectedColor) {
                      setState(() {
                        carMakeProvider.carTechnicalFormState['color'] =
                            selectedColor;
                      });
                    })
                : DropdownButtonFormField(
                    hint: Text(S.of(context).cars_create_selectColor)),
            TextFormField(
                decoration:
                    InputDecoration(labelText: S.of(context).cars_create_vin),
                onChanged: (value) {
                  carMakeProvider.carTechnicalFormState['vin'] = value;
                },
                initialValue: carMakeProvider.carTechnicalFormState['vin'],
                validator: (value) {
                  if (value.isEmpty) {
                    return S.of(context).cars_create_error_vinEmpty;
                  } else {
                    return null;
                  }
                }),
          ],
        ),
      ),
    );
  }

  valid() {
    return _formKey.currentState.validate();
  }

  List<DropdownMenuItem<CarCylinderCapacity>>
      _buildCylinderCapacityDropdownItems(
          List<CarCylinderCapacity> cylinderCapacities) {
    List<DropdownMenuItem<CarCylinderCapacity>> brandDropdownList = [];
    cylinderCapacities.forEach((cc) => brandDropdownList
        .add(DropdownMenuItem(value: cc, child: Text(cc.name))));
    return brandDropdownList;
  }

  List<DropdownMenuItem<CarPower>> _buildCarPowerDropdownItems(
      List<CarPower> powers) {
    List<DropdownMenuItem<CarPower>> powerDropdownList = [];
    powers.forEach((power) => powerDropdownList
        .add(DropdownMenuItem(value: power, child: Text(power.name))));
    return powerDropdownList;
  }

  List<DropdownMenuItem<CarTransmission>> _buildCarTransmissionDropdownItems(
      List<CarTransmission> transmissions) {
    List<DropdownMenuItem<CarTransmission>> brandDropdownList = [];
    transmissions.forEach((transmission) => brandDropdownList.add(
        DropdownMenuItem(value: transmission, child: Text(transmission.name))));
    return brandDropdownList;
  }

  List<DropdownMenuItem<CarColor>> _buildCarColorDropdownItems(
      List<CarColor> colors) {
    List<DropdownMenuItem<CarColor>> colorsDropdownList = [];
    colors.forEach((color) => colorsDropdownList.add(DropdownMenuItem(
        value: color, child: Text(_translateColorName(color.name)))));
    return colorsDropdownList;
  }

  String _translateColorName(String colorName) {
    switch (colorName) {
      case 'COLOR_RED':
        return S.of(context).COLOR_RED;
      case 'COLOR_BLACK':
        return S.of(context).COLOR_BLACK;
      case 'COLOR_GREEN':
        return S.of(context).COLOR_GREEN;
      case 'COLOR_SILVER':
        return S.of(context).COLOR_SILVER;
      case 'COLOR_WHITE':
        return S.of(context).COLOR_WHITE;
      case 'COLOR_GRAY':
        return S.of(context).COLOR_GRAY;
      case 'COLOR_DARK_BLUE':
        return S.of(context).COLOR_DARK_BLUE;
      case 'COLOR_DARK_GRAY':
        return S.of(context).COLOR_DARK_GRAY;
      case 'COLOR_GOLD':
        return S.of(context).COLOR_GOLD;
      default:
        return '';
    }
  }
}
