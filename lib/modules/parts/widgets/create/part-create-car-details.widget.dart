import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car-fuel.model.dart';
import 'package:app/modules/cars/models/car-model.model.dart';
import 'package:app/modules/cars/models/car-query.model.dart';
import 'package:app/modules/cars/models/car-type.model.dart';
import 'package:app/modules/cars/models/car-variant.model.dart';
import 'package:app/modules/cars/models/car-year.model.dart';
import 'package:app/modules/cars/services/car-make.service.dart';
import 'package:app/modules/parts/providers/part-create.provider.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/locale.manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PartCreateCarDetailsWidget extends StatefulWidget {
  PartCreateCarDetailsWidget({Key key}) : super(key: key);

  @override
  _PartCreateCarDetailsWidgetState createState() =>
      _PartCreateCarDetailsWidgetState();
}

class _PartCreateCarDetailsWidgetState
    extends State<PartCreateCarDetailsWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  PartCreateProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<PartCreateProvider>(context);
    _provider.formState = _formKey;

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
      isExpanded: true,
      hint: Text(S.of(context).cars_create_selectBrand),
      // Not necessary for Option 1
      items: _buildBrandDropdownItems(_provider.brands),
      value: _provider.carFormState['brand'],
      validator: (value) {
        if (value == null) {
          return S.of(context).cars_create_error_brandNotSelected;
        } else {
          return null;
        }
      },
      onChanged: (newValue) async {
        try {
          await _provider
              .loadCarModel(CarQuery(
                  language: LocaleManager.language(context), brand: newValue))
              .then((_) => {
                    setState(() {
                      _provider.carFormState['brand'] = newValue;
                      _provider.carFormState['model'] = null;
                      _provider.carFormState['year'] = null;
                    })
                  });
        } catch (error) {
          setState(() {
            _provider.carFormState['brand'] = newValue;
          });

          if (error
              .toString()
              .contains(CarMakeService.LOAD_CAR_MODELS_FAILED_EXCEPTION)) {
            FlushBarHelper.showFlushBar(S.of(context).general_error,
                S.of(context).exception_load_car_models, context);
          }
        }
      },
    );
  }

  _modelDropdownWidget() {
    return _provider.carFormState['brand'] != null
        ? DropdownButtonFormField(
            isExpanded: true,
            hint: Text(S.of(context).cars_create_selectModel),
            items: _buildCarModelDropdownItems(_provider.carModels),
            value: _provider.carFormState['model'],
            validator: (value) {
              if (value == null) {
                return S.of(context).cars_create_error_modelNotSelected;
              } else {
                return null;
              }
            },
            onChanged: (selectedModel) async {
              try {
                await _provider
                    .loadCarTypes(CarQuery(
                        language: LocaleManager.language(context),
                        brand: _provider.carFormState['brand'],
                        model: selectedModel))
                    .then((_) => {
                          setState(() {
                            _provider.carFormState['model'] = selectedModel;
                            _provider.carFormState['type'] = null;
                          })
                        });
              } catch (error) {
                if (error
                    .toString()
                    .contains(CarMakeService.LOAD_CAR_TYPE_FAILED_EXCEPTION)) {
                  FlushBarHelper.showFlushBar(S.of(context).general_error,
                      S.of(context).exception_load_car_types, context);

                  setState(() {
                    _provider.carFormState['model'] = selectedModel;
                  });
                }
              }
            })
        : DropdownButtonFormField(
            hint: Text(S.of(context).cars_create_selectModel));
  }

  _typeDropdownWidget() {
    return DropdownButtonFormField(
        isExpanded: true,
        hint: Text(S.of(context).cars_create_select_type),
        items: _buildCarTypeDropdownItems(_provider.carTypes),
        value: _provider.carFormState['type'],
        validator: (value) {
          if (value == null) {
            return S.of(context).cars_create_error_type_not_selected;
          } else {
            return null;
          }
        },
        onChanged: (selectedType) async {
          CarQuery carQuery = CarQuery(
              language: LocaleManager.language(context), carType: selectedType);
          try {
            await _provider.loadCarYears(carQuery).then((_) async {
              setState(() {
                _provider.carFormState['type'] =
                    selectedType;
              });
            });
          } catch (error) {
            if (error
                .toString()
                .contains(CarMakeService.LOAD_CAR_YEAR_FAILED_EXCEPTION)) {
              FlushBarHelper.showFlushBar(
                  S.of(context).general_error,
                  S.of(context).exception_load_car_years,
                  context);
            }

            setState(() {
              _provider.carFormState['type'] = selectedType;
            });
          }
        });
  }

  _yearDropdownWidget() {
    return _provider.carFormState['type'] != null
        ? DropdownButtonFormField(
        isExpanded: true,
        hint: Text(S.of(context).cars_create_selectYear),
        items: _buildCarYearDropdownItems(_provider.carYears),
        value: _provider.carFormState['year'],
        validator: (value) {
          if (value == null) {
            return S.of(context).cars_create_error_yearNotSelected;
          } else {
            return null;
          }
        },
        onChanged: (selectedYear) async {
          try {
            await _provider
                .loadCarFuelTypes(CarQuery(
                language: LocaleManager.language(context),
                carType:
                _provider.carFormState['type']))
                .then((_) => {
              setState(() {
                _provider.carFormState['year'] =
                    selectedYear;
              })
            });
          } catch (error) {
            if (error
                .toString()
                .contains(CarMakeService.LOAD_CAR_FUEL_FAILED_EXCEPTION)) {
              FlushBarHelper.showFlushBar(
                  S.of(context).general_error,
                  S.of(context).exception_load_car_fuel_types,
                  context);

              setState(() {
                _provider.carFormState['year'] =
                    selectedYear;
              });
            }
          }
        })
        : DropdownButtonFormField(
        hint: Text(S.of(context).cars_create_selectYear));
  }

  _fuelTypeDropdownWidget() {
    return _provider.carFormState['year'] != null
        ? DropdownButtonFormField(
        isExpanded: true,
        hint: Text(S.of(context).cars_create_selectFuelType),
        items:
        _buildCarFuelTypeDropdownItems(_provider.carFuelTypes),
        value: _provider.carFormState['fuelType'],
        validator: (value) {
          if (value == null) {
            return S.of(context).cars_create_selectFuelType;
          } else {
            return null;
          }
        },
        onChanged: (selectedFuelType) {
          setState(() {
            _provider.carFormState['fuelType'] =
                selectedFuelType;
          });
        })
        : DropdownButtonFormField(
        hint: Text(S.of(context).cars_create_selectFuelType));
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

  List<DropdownMenuItem<CarType>> _buildCarTypeDropdownItems(
      List<CarType> carTypes) {
    List<DropdownMenuItem<CarType>> typeDropdownList = [];
    carTypes.forEach((carType) => typeDropdownList.add(DropdownMenuItem(
      value: carType,
      child: Text(carType.name),
    )));
    return typeDropdownList;
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
}
