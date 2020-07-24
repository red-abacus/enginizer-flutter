import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car-color.model.dart';
import 'package:app/modules/cars/models/fuel/car-fuel.model.dart';
import 'package:app/modules/cars/models/car-query.model.dart';
import 'package:app/modules/cars/models/car-type.model.dart';
import 'package:app/modules/cars/models/car-variant.model.dart';
import 'package:app/modules/cars/models/car-year.model.dart';
import 'package:app/modules/cars/providers/cars-make.provider.dart';
import 'package:app/modules/cars/services/car-make.service.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/locale.manager.dart';
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

  CarsMakeProvider _carsMakeProvider;

  Widget build(BuildContext context) {
    _carsMakeProvider = Provider.of<CarsMakeProvider>(context);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _typeDropdownWidget(),
            _yearDropdownWidget(),
            _fuelTypeDropdownWidget(),
            _variantDropdownWidget(),
            _colorDropdownWidget(),
            _carVinDropdownWidget()
          ],
        ),
      ),
    );
  }

  _typeDropdownWidget() {
    return DropdownButtonFormField(
        isExpanded: true,
        hint: Text(S.of(context).cars_create_select_type),
        items: _buildCarTypeDropdownItems(_carsMakeProvider.carTypes),
        value: _carsMakeProvider.carTechnicalFormState['type'],
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
            await _carsMakeProvider.loadCarYears(carQuery).then((_) async {
              await _carsMakeProvider.loadCarVariants(carQuery).then((_) => {
                    setState(() {
                      _carsMakeProvider.carTechnicalFormState['type'] =
                          selectedType;
                    })
                  });
            });
          } catch (error) {
            if (error
                .toString()
                .contains(CarMakeService.LOAD_CAR_YEAR_FAILED_EXCEPTION)) {
              FlushBarHelper.showFlushBar(S.of(context).general_error,
                  S.of(context).exception_load_car_years, context);
            } else if (error
                .toString()
                .contains(CarMakeService.LOAD_CAR_VARIANTS_FAILED_EXCEPTION)) {
              FlushBarHelper.showFlushBar(S.of(context).general_error,
                  S.of(context).exception_load_car_variants, context);
            }

            setState(() {
              _carsMakeProvider.carTechnicalFormState['type'] = selectedType;
            });
          }
        });
  }

  _yearDropdownWidget() {
    return _carsMakeProvider.carTechnicalFormState['type'] != null
        ? DropdownButtonFormField(
            isExpanded: true,
            hint: Text(S.of(context).cars_create_selectYear),
            items: _buildCarYearDropdownItems(_carsMakeProvider.carYears),
            value: _carsMakeProvider.carTechnicalFormState['year'],
            validator: (value) {
              if (value == null) {
                return S.of(context).cars_create_error_yearNotSelected;
              } else {
                return null;
              }
            },
            onChanged: (selectedYear) async {
              try {
                await _carsMakeProvider
                    .loadCarFuelTypes(CarQuery(
                        language: LocaleManager.language(context),
                        carType:
                            _carsMakeProvider.carTechnicalFormState['type']))
                    .then((_) => {
                          setState(() {
                            _carsMakeProvider.carTechnicalFormState['year'] =
                                selectedYear;
                          })
                        });
              } catch (error) {
                if (error
                    .toString()
                    .contains(CarMakeService.LOAD_CAR_FUEL_FAILED_EXCEPTION)) {
                  FlushBarHelper.showFlushBar(S.of(context).general_error,
                      S.of(context).exception_load_car_fuel_types, context);

                  setState(() {
                    _carsMakeProvider.carTechnicalFormState['year'] =
                        selectedYear;
                  });
                }
              }
            })
        : DropdownButtonFormField(
            hint: Text(S.of(context).cars_create_selectYear));
  }

  _fuelTypeDropdownWidget() {
    return _carsMakeProvider.carTechnicalFormState['year'] != null
        ? DropdownButtonFormField(
            isExpanded: true,
            hint: Text(S.of(context).cars_create_selectFuelType),
            items:
                _buildCarFuelTypeDropdownItems(_carsMakeProvider.carFuelTypes),
            value: _carsMakeProvider.carTechnicalFormState['fuelType'],
            validator: (value) {
              if (value == null) {
                return S.of(context).cars_create_selectFuelType;
              } else {
                return null;
              }
            },
            onChanged: (selectedFuelType) {
              setState(() {
                _carsMakeProvider.carTechnicalFormState['fuelType'] =
                    selectedFuelType;
              });
            })
        : DropdownButtonFormField(
            hint: Text(S.of(context).cars_create_selectFuelType));
  }

  _variantDropdownWidget() {
    return _carsMakeProvider.carTechnicalFormState['type'] != null
        ? DropdownButtonFormField(
            isExpanded: true,
            hint: Text(S.of(context).cars_create_select_variant),
            items: _buildVariantsDropdownItems(_carsMakeProvider.carVariants),
            value: _carsMakeProvider.carTechnicalFormState['variant'],
            validator: (value) {
              if (value == null) {
                return S.of(context).cars_create_error_variant_not_selected;
              } else {
                return null;
              }
            },
            onChanged: (selectedFuelType) {
              setState(() {
                _carsMakeProvider.carTechnicalFormState['variant'] =
                    selectedFuelType;
              });
            })
        : DropdownButtonFormField(
            hint: Text(S.of(context).cars_create_select_variant));
  }

  _colorDropdownWidget() {
    return DropdownButtonFormField(
        isExpanded: true,
        hint: Text(S.of(context).cars_create_selectColor),
        items: _buildCarColorDropdownItems(_carsMakeProvider.carColors),
        value: _carsMakeProvider.carTechnicalFormState['color'],
        validator: (value) {
          if (value == null) {
            return S.of(context).cars_create_error_ColorNotSelected;
          } else {
            return null;
          }
        },
        onChanged: (selectedColor) {
          setState(() {
            _carsMakeProvider.carTechnicalFormState['color'] = selectedColor;
          });
        });
  }

  _carVinDropdownWidget() {
    return TextFormField(
        decoration: InputDecoration(labelText: S.of(context).cars_create_vin),
        onChanged: (value) {
          _carsMakeProvider.carTechnicalFormState['vin'] = value;
        },
        initialValue: _carsMakeProvider.carTechnicalFormState['vin'],
        validator: (value) {
          if (value.isEmpty) {
            return S.of(context).cars_create_error_vinEmpty;
          } else {
            return null;
          }
        });
  }

  valid() {
    return _formKey.currentState.validate();
  }

  List<DropdownMenuItem<CarColor>> _buildCarColorDropdownItems(
      List<CarColor> colors) {
    List<DropdownMenuItem<CarColor>> colorsDropdownList = [];
    colors.forEach((color) => colorsDropdownList.add(DropdownMenuItem(
        value: color,
        child: Text(color.translateColorName(context),
            overflow: TextOverflow.visible))));
    return colorsDropdownList;
  }

  List<DropdownMenuItem<CarType>> _buildCarTypeDropdownItems(
      List<CarType> carTypes) {
    List<DropdownMenuItem<CarType>> typeDropdownList = [];
    carTypes.forEach((carType) => typeDropdownList.add(DropdownMenuItem(
          value: carType,
          child: Text(carType.name, overflow: TextOverflow.visible),
        )));
    return typeDropdownList;
  }

  List<DropdownMenuItem<CarYear>> _buildCarYearDropdownItems(
      List<CarYear> carYears) {
    List<DropdownMenuItem<CarYear>> yearDropdownList = [];
    carYears.forEach((carYear) => yearDropdownList.add(DropdownMenuItem(
        value: carYear,
        child: Text(carYear.name, overflow: TextOverflow.visible))));
    return yearDropdownList;
  }

  List<DropdownMenuItem<CarFuelType>> _buildCarFuelTypeDropdownItems(
      List<CarFuelType> carFuelTypes) {
    List<DropdownMenuItem<CarFuelType>> fuelTypeDropdownList = [];
    carFuelTypes.forEach((carFuelType) => fuelTypeDropdownList.add(
        DropdownMenuItem(
            value: carFuelType,
            child: Text(carFuelType.name, overflow: TextOverflow.visible))));
    return fuelTypeDropdownList;
  }

  List<DropdownMenuItem<CarVariant>> _buildVariantsDropdownItems(
      List<CarVariant> carVariants) {
    List<DropdownMenuItem<CarVariant>> variantsDropdownList = [];
    carVariants.forEach((carVariant) => variantsDropdownList.add(
        DropdownMenuItem(
            value: carVariant,
            child: Text(carVariant.name, overflow: TextOverflow.visible))));
    return variantsDropdownList;
  }
}
