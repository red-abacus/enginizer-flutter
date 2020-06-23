import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car-model.model.dart';
import 'package:app/modules/cars/models/car-query.model.dart';
import 'package:app/modules/cars/services/car-make.service.dart';
import 'package:app/modules/shop/providers/shop-alert-make.provider.dart';
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
  ShopAlertMakeProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<ShopAlertMakeProvider>(context);
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
      items: _buildBrandDropdownItems(_provider.brands),
      value: _provider.shopAlert.brand,
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
                      _provider.shopAlert.brand = newValue;
                      _provider.shopAlert.carModel = null;
                    })
                  });
        } catch (error) {
          setState(() {
            _provider.shopAlert.brand = newValue;
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
    return _provider.shopAlert.brand != null
        ? DropdownButtonFormField(
            isExpanded: true,
            hint: Text(S.of(context).cars_create_selectModel),
            items: _buildCarModelDropdownItems(_provider.carModels),
            value: _provider.shopAlert.carModel,
            validator: (value) {
              if (value == null) {
                return S.of(context).cars_create_error_modelNotSelected;
              } else {
                return null;
              }
            },
            onChanged: (selectedModel) async {
              setState(() {
                _provider.shopAlert.carModel =
                    selectedModel;
              });
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
