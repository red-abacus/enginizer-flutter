import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car-fuel.model.dart';
import 'package:app/modules/cars/models/car-model.model.dart';
import 'package:app/modules/cars/models/car-query.model.dart';
import 'package:app/modules/cars/models/car-type.model.dart';
import 'package:app/modules/cars/models/car-year.model.dart';
import 'package:app/modules/cars/providers/cars-make.provider.dart';
import 'package:app/utils/locale.manager.dart';
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

  CarsMakeProvider _carsMakeProvider;

  @override
  Widget build(BuildContext context) {
    _carsMakeProvider = Provider.of<CarsMakeProvider>(context);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _brandDropdownWidget(),
            _modelDropdownWidget(),
            _typeDropdownWidget(),
            _yearDropdownWidget(),
            _fuelTypeDropdownWidget(),
          ],
        ),
      ),
    );
  }

  valid() {
    return _formKey.currentState.validate();
  }

  _brandDropdownWidget() {
    return DropdownButtonFormField(
      hint: Text(S.of(context).cars_create_selectBrand),
      // Not necessary for Option 1
      items: _buildBrandDropdownItems(_carsMakeProvider.brands),
      value: _carsMakeProvider.carMakeFormState['brand'],
      validator: (value) {
        if (value == null) {
          return S.of(context).cars_create_error_brandNotSelected;
        } else {
          return null;
        }
      },
      onChanged: (newValue) {
        _carsMakeProvider
            .loadCarModel(CarQuery(
                language: LocaleManager.language(context), brand: newValue))
            .then((_) => {
                  setState(() {
                    _carsMakeProvider.carMakeFormState['brand'] = newValue;
                    _carsMakeProvider.carMakeFormState['model'] = null;
                    _carsMakeProvider.carMakeFormState['year'] = null;
                  })
                });
      },
    );
  }

  _modelDropdownWidget() {
    return _carsMakeProvider.carMakeFormState['brand'] != null
        ? DropdownButtonFormField(
            hint: Text(S.of(context).cars_create_selectModel),
            items: _buildCarModelDropdownItems(_carsMakeProvider.carModels),
            value: _carsMakeProvider.carMakeFormState['model'],
            validator: (value) {
              if (value == null) {
                return S.of(context).cars_create_error_modelNotSelected;
              } else {
                return null;
              }
            },
            onChanged: (selectedModel) {
              _carsMakeProvider
                  .loadCarTypes(CarQuery(
                      language: LocaleManager.language(context),
                      brand: _carsMakeProvider.carMakeFormState['brand'],
                      model: selectedModel))
                  .then((_) => {
                        setState(() {
                          _carsMakeProvider.carMakeFormState['model'] =
                              selectedModel;
                          _carsMakeProvider.carMakeFormState['type'] = null;
                        })
                      });
            })
        : DropdownButtonFormField(
            hint: Text(S.of(context).cars_create_selectModel));
  }

  _typeDropdownWidget() {
    return _carsMakeProvider.carMakeFormState['model'] != null
        ? DropdownButtonFormField(
            hint: Text(S.of(context).cars_create_select_type),
            items: _buildCarTypeDropdownItems(_carsMakeProvider.carTypes),
            value: _carsMakeProvider.carMakeFormState['type'],
            validator: (value) {
              if (value == null) {
                return S.of(context).cars_create_error_type_not_selected;
              } else {
                return null;
              }
            },
            onChanged: (selectedType) {
              Provider.of<CarsMakeProvider>(context)
                  .loadCarYears(CarQuery(
                      language: LocaleManager.language(context),
                      brand: _carsMakeProvider.carMakeFormState['brand'],
                      model: _carsMakeProvider.carMakeFormState['model'],
                      carType: selectedType))
                  .then((_) => {
                        setState(() {
                          _carsMakeProvider.carMakeFormState['type'] =
                              selectedType;
                        })
                      });
            })
        : DropdownButtonFormField(
            hint: Text(S.of(context).cars_create_select_type));
  }

  _yearDropdownWidget() {
    return _carsMakeProvider.carMakeFormState['model'] != null
        ? DropdownButtonFormField(
            hint: Text(S.of(context).cars_create_selectYear),
            items: _buildCarYearDropdownItems(_carsMakeProvider.carYears),
            value: _carsMakeProvider.carMakeFormState['year'],
            validator: (value) {
              if (value == null) {
                return S.of(context).cars_create_error_yearNotSelected;
              } else {
                return null;
              }
            },
            onChanged: (selectedYear) {
              Provider.of<CarsMakeProvider>(context)
                  .loadCarFuelTypes(CarQuery(
                      language: LocaleManager.language(context),
                      brand: _carsMakeProvider.carMakeFormState['brand'],
                      model: _carsMakeProvider.carMakeFormState['model'],
                      carType: _carsMakeProvider.carMakeFormState['type'],
                      year: _carsMakeProvider.carMakeFormState['year']))
                  .then((_) => {
                        setState(() {
                          _carsMakeProvider.carMakeFormState['year'] =
                              selectedYear;
                        })
                      });
            })
        : DropdownButtonFormField(
            hint: Text(S.of(context).cars_create_selectYear));
  }

  _fuelTypeDropdownWidget() {
    return _carsMakeProvider.carMakeFormState['year'] != null
        ? DropdownButtonFormField(
            hint: Text(S.of(context).cars_create_selectFuelType),
            items:
                _buildCarFuelTypeDropdownItems(_carsMakeProvider.carFuelTypes),
            value: _carsMakeProvider.carMakeFormState['fuelType'],
            validator: (value) {
              if (value == null) {
                return S.of(context).cars_create_selectFuelType;
              } else {
                return null;
              }
            },
            onChanged: (selectedFuelType) {
              setState(() {
                _carsMakeProvider.carMakeFormState['fuelType'] =
                    selectedFuelType;
              });
            })
        : DropdownButtonFormField(
            hint: Text(S.of(context).cars_create_selectFuelType));
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

  List<DropdownMenuItem<CarType>> _buildCarTypeDropdownItems(
      List<CarType> carTypes) {
    List<DropdownMenuItem<CarType>> typeDropdownList = [];
    carTypes.forEach((carType) => typeDropdownList
        .add(DropdownMenuItem(value: carType, child: Text(carType.name))));
    return typeDropdownList;
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
