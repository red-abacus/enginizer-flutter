import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car-model.model.dart';
import 'package:app/modules/cars/models/car-query.model.dart';
import 'package:app/modules/cars/providers/cars-make.provider.dart';
import 'package:app/modules/cars/services/car-make.service.dart';
import 'package:app/utils/locale.manager.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopAlertCreateIdentificationForm extends StatefulWidget {
  @override
  ShopAlertCreateIdentificationFormState createState() =>
      ShopAlertCreateIdentificationFormState();
}

class ShopAlertCreateIdentificationFormState
    extends State<ShopAlertCreateIdentificationForm> {
  CarsMakeProvider _carsMakeProvider;

  @override
  Widget build(BuildContext context) {
    _carsMakeProvider = Provider.of<CarsMakeProvider>(context);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _brandDropdownWidget(),
          _modelDropdownWidget(),
        ],
      ),
    );
  }

  _brandDropdownWidget() {
    return DropdownButtonFormField(
      isExpanded: true,
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
      onChanged: (newValue) async {
        try {
          await _carsMakeProvider
              .loadCarModel(CarQuery(
                  language: LocaleManager.language(context), brand: newValue))
              .then((_) => {
                    setState(() {
                      _carsMakeProvider.carMakeFormState['brand'] = newValue;
                      _carsMakeProvider.carMakeFormState['model'] = null;
                      _carsMakeProvider.carMakeFormState['year'] = null;
                    })
                  });
        } catch (error) {
          setState(() {
            _carsMakeProvider.carMakeFormState['brand'] = newValue;
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
    return _carsMakeProvider.carMakeFormState['brand'] != null
        ? DropdownButtonFormField(
            isExpanded: true,
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
            onChanged: (selectedModel) async {
              try {
                await _carsMakeProvider
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
              } catch (error) {
                if (error
                    .toString()
                    .contains(CarMakeService.LOAD_CAR_TYPE_FAILED_EXCEPTION)) {
                  FlushBarHelper.showFlushBar(S.of(context).general_error,
                      S.of(context).exception_load_car_types, context);

                  setState(() {
                    _carsMakeProvider.carMakeFormState['model'] = selectedModel;
                  });
                }
              }
            })
        : DropdownButtonFormField(
            hint: Text(S.of(context).cars_create_selectModel));
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
