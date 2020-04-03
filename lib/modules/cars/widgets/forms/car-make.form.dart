import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car-fuel.model.dart';
import 'package:app/modules/cars/models/car-model.model.dart';
import 'package:app/modules/cars/models/car-query.model.dart';
import 'package:app/modules/cars/models/car-year.model.dart';
import 'package:app/modules/cars/providers/cars-make.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarMakeForm extends StatefulWidget {
  CarMakeForm({Key key}) : super(key: key);

  @override
  CarMakeFormState createState() => CarMakeFormState();
}

class CarMakeFormState extends State<CarMakeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var carMakeProvider = Provider.of<CarsMakeProvider>(context);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // CAR BRAND
            DropdownButtonFormField(
              hint: Text(S.of(context).cars_create_selectBrand),
              // Not necessary for Option 1
              items: _buildBrandDropdownItems(carMakeProvider.brands),
              value: carMakeProvider.carMakeFormState['brand'],
              validator: (value) {
                if (value == null) {
                  return S.of(context).cars_create_error_brandNotSelected;
                } else {
                  return null;
                }
              },
              onChanged: (newValue) {
                carMakeProvider
                    .loadCarModel(CarQuery(brand: newValue))
                    .then((_) => {
                          setState(() {
                            carMakeProvider.carMakeFormState['brand'] =
                                newValue;
                            carMakeProvider.carMakeFormState['model'] = null;
                            carMakeProvider.carMakeFormState['year'] = null;
                          })
                        });
              },
            ),
            // CAR MODEL
            carMakeProvider.carMakeFormState['brand'] != null
                ? DropdownButtonFormField(
                    hint: Text(S.of(context).cars_create_selectModel),
                    items:
                        _buildCarModelDropdownItems(carMakeProvider.carModels),
                    value: carMakeProvider.carMakeFormState['model'],
                    validator: (value) {
                      if (value == null) {
                        return S.of(context).cars_create_error_modelNotSelected;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (selectedModel) {
                      carMakeProvider
                          .loadCarYears(CarQuery(
                              brand: carMakeProvider.carMakeFormState['brand'],
                              model: selectedModel))
                          .then((_) => {
                                setState(() {
                                  carMakeProvider.carMakeFormState['model'] =
                                      selectedModel;
                                  carMakeProvider.carMakeFormState['year'] =
                                      null;
                                })
                              });
                    })
                : DropdownButtonFormField(
                    hint: Text(S.of(context).cars_create_selectModel)),
            // CAR YEAR
            carMakeProvider.carMakeFormState['model'] != null
                ? DropdownButtonFormField(
                    hint: Text(S.of(context).cars_create_selectYear),
                    items: _buildCarYearDropdownItems(carMakeProvider.carYears),
                    value: carMakeProvider.carMakeFormState['year'],
                    validator: (value) {
                      if (value == null) {
                        return S.of(context).cars_create_error_yearNotSelected;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (selectedYear) {
                      Provider.of<CarsMakeProvider>(context)
                          .loadCarFuelTypes()
                          .then((_) => {
                                setState(() {
                                  carMakeProvider.carMakeFormState['year'] =
                                      selectedYear;
                                })
                              });
                    })
                : DropdownButtonFormField(
                    hint: Text(S.of(context).cars_create_selectYear)),
            // CAR FUEL TYPE
            carMakeProvider.carMakeFormState['year'] != null
                ? DropdownButtonFormField(
                    hint: Text(S.of(context).cars_create_selectFuelType),
                    items: _buildCarFuelTypeDropdownItems(
                        carMakeProvider.carFuelTypes),
                    value: carMakeProvider.carMakeFormState['fuelType'],
                    validator: (value) {
                      if (value == null) {
                        return S.of(context).cars_create_selectFuelType;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (selectedFuelType) {
                      setState(() {
                        carMakeProvider.carMakeFormState['fuelType'] =
                            selectedFuelType;
                      });
                    })
                : DropdownButtonFormField(
                    hint: Text(S.of(context).cars_create_selectFuelType)),
          ],
        ),
      ),
    );
  }

  valid() {
    return _formKey.currentState.validate();
  }

  List<DropdownMenuItem<CarBrand>> _buildBrandDropdownItems(
      List<CarBrand> brands) {
    List<DropdownMenuItem<CarBrand>> brandDropdownList = [];
    brands.forEach((brand) => brandDropdownList
        .add(DropdownMenuItem(value: brand, child: Text(brand.name))));
    return brandDropdownList;
  }

  List<DropdownMenuItem<CarModel>> _buildCarModelDropdownItems(
      List<CarModel> carModels) {
    List<DropdownMenuItem<CarModel>> brandDropdownList = [];
    carModels.forEach((carModel) => brandDropdownList
        .add(DropdownMenuItem(value: carModel, child: Text(carModel.name))));
    return brandDropdownList;
  }

  List<DropdownMenuItem<CarYear>> _buildCarYearDropdownItems(
      List<CarYear> carYears) {
    List<DropdownMenuItem<CarYear>> yearDropdownList = [];
    carYears.forEach((carYear) => yearDropdownList
        .add(DropdownMenuItem(value: carYear, child: Text(carYear.name))));
    return yearDropdownList;
  }

  List<DropdownMenuItem<CarFuelType>> _buildCarFuelTypeDropdownItems(
      List<CarFuelType> carFuelTypes) {
    List<DropdownMenuItem<CarFuelType>> fuelTypeDropdownList = [];
    carFuelTypes.forEach((carFuelType) => fuelTypeDropdownList.add(
        DropdownMenuItem(value: carFuelType, child: Text(carFuelType.name))));
    return fuelTypeDropdownList;
  }
}
