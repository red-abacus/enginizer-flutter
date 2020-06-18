import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car-model.model.dart';
import 'package:app/modules/cars/providers/cars-make.provider.dart';
import 'package:app/modules/shared/widgets/custom-dropdown-field.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopAlertPreviewForm extends StatefulWidget {
  @override
  ShopAlertPreviewFormState createState() => ShopAlertPreviewFormState();
}

class ShopAlertPreviewFormState extends State<ShopAlertPreviewForm> {
  CarsMakeProvider _provider;

  Widget build(BuildContext context) {
    _provider = Provider.of<CarsMakeProvider>(context);

    String year = '';

    if (_provider.carTechnicalFormState['start_year'] != null) {
      year = _provider.carTechnicalFormState['start_year'].toString();
    }

    if (_provider.carTechnicalFormState['end_year'] != null) {
      if (year.isEmpty) {
        year = _provider.carTechnicalFormState['end_year'].toString();
      } else {
        year =
            '$year - ${_provider.carTechnicalFormState['end_year'].toString()}';
      }
    }

    String price = '';

    if (_provider.carTechnicalFormState['start_price'] != null) {
      price = _provider.carTechnicalFormState['start_price'];
    }

    if (_provider.carTechnicalFormState['end_price'] != null) {
      if (price.isEmpty) {
        price = _provider.carTechnicalFormState['end_price'];
      } else {
        price = '$price - ${_provider.carTechnicalFormState['end_price']}';
      }
    }

    if (price.isNotEmpty) {
      price = '$price ${S.of(context).general_currency}';
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (_provider.carMakeFormState['brand'] != null)
            _titleContainer(S.of(context).general_brand),
          if (_provider.carMakeFormState['brand'] != null)
            _subtitleContainer(
                (_provider.carMakeFormState['brand'] as CarBrand).name),
          if (_provider.carMakeFormState['model'] != null)
            _titleContainer(S.of(context).general_model),
          if (_provider.carMakeFormState['model'] != null)
            _subtitleContainer(
                (_provider.carMakeFormState['model'] as CarModel).name),
          if (year.isNotEmpty) _titleContainer(S.of(context).general_year),
          if (year.isNotEmpty) _subtitleContainer(year),
          if (price.isNotEmpty) _titleContainer(S.of(context).general_price),
          if (price.isNotEmpty) _subtitleContainer(price),
        ],
      ),
    );
  }

  _titleContainer(String text) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: TextHelper.customTextStyle(
            color: gray2, weight: FontWeight.bold, size: 18),
      ),
    );
  }

  _subtitleContainer(String text) {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextHelper.customTextStyle(size: 18),
            ),
          )
        ],
      ),
    );
  }
}
