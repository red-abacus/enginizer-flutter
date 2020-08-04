import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car-model.model.dart';
import 'package:app/modules/shop/providers/shop-alert-make.provider.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopAlertPreviewForm extends StatefulWidget {
  @override
  ShopAlertPreviewFormState createState() => ShopAlertPreviewFormState();
}

class ShopAlertPreviewFormState extends State<ShopAlertPreviewForm> {
  ShopAlertMakeProvider _provider;

  Widget build(BuildContext context) {
    _provider = Provider.of<ShopAlertMakeProvider>(context);

    String year = '';

    if (_provider.shopAlert.startYear != null) {
      year = _provider.shopAlert.startYear.toString();
    }

    if (_provider.shopAlert.endYear != null) {
      if (year.isEmpty) {
        year = _provider.shopAlert.endYear.toString();
      } else {
        year = '$year - ${_provider.shopAlert.endYear.toString()}';
      }
    }

    String price = '';

    if (_provider.shopAlert.startPrice != null) {
      price = _provider.shopAlert.startPrice.toString();
    }

    if (_provider.shopAlert.endPrice != null) {
      if (price.isEmpty) {
        price = _provider.shopAlert.endPrice.toString();
      } else {
        price = '$price - ${_provider.shopAlert.endPrice}';
      }
    }

    if (price.isNotEmpty) {
      price = '$price ${S.of(context).general_currency}';
    }

    String mileage = '';

    if (_provider.shopAlert.startMileage != null) {
      mileage = _provider.shopAlert.startMileage.toString();
    }

    if (_provider.shopAlert.endMileage != null) {
      if (mileage.isEmpty) {
        mileage = _provider.shopAlert.endMileage.toString();
      } else {
        mileage = '$mileage - ${_provider.shopAlert.endMileage}';
      }
    }

    if (mileage.isNotEmpty) {
      mileage = '$mileage ${S.of(context).general_km}';
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (_provider.shopAlert.brand != null)
            _titleContainer(S.of(context).general_brand),
          if (_provider.shopAlert.brand != null)
            _subtitleContainer((_provider.shopAlert.brand.name)),
          if (_provider.shopAlert.carModel != null)
            _titleContainer(S.of(context).general_model),
          if (_provider.shopAlert.carModel != null)
            _subtitleContainer(_provider.shopAlert.carModel.name),
          if (year.isNotEmpty) _subtitleContainer(year),
          if (mileage.isNotEmpty) _titleContainer(S.of(context).general_mileage),
          if (mileage.isNotEmpty) _subtitleContainer(mileage),
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
