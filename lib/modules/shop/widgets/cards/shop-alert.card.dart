import 'package:app/generated/l10n.dart';
import 'package:app/modules/shop/models/shop-alert.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopAlertCard extends StatelessWidget {
  final ShopAlert shopAlert;
  final Function removeShopAlert;
  final Function selectShopAlert;

  ShopAlertCard({this.shopAlert, this.removeShopAlert, this.selectShopAlert});

  @override
  Widget build(BuildContext context) {
    String year = '';

    if (shopAlert.startYear != null) {
      year = shopAlert.startYear.toString();
    }

    if (shopAlert.endYear != null) {
      if (year.isEmpty) {
        year = shopAlert.endYear.toString();
        year = '< ${shopAlert.endYear.toString()}';
      } else {
        year = '$year - ${shopAlert.endYear.toString()}';
      }
    }
    else {
      if (year.isNotEmpty) {
        year = '> $year';
      }
    }

    String price = '';

    if (shopAlert.startPrice != null) {
      price = shopAlert.startPrice.toString();
    }

    if (shopAlert.endPrice != null) {
      if (price.isEmpty) {
        price = '< ${shopAlert.endPrice.toString()}';
      } else {
        price = '$price - ${shopAlert.endPrice}';
      }
    } else {
      if (price.isNotEmpty) {
        price = '> $price';
      }
    }

    if (price.isNotEmpty) {
      price = '$price ${S.of(context).general_currency}';
    }

    String brandName = '';

    if (shopAlert.brand != null) {
      brandName = shopAlert.brand.name;
    }

    if (shopAlert.carModel != null) {
      brandName = brandName.isEmpty
          ? shopAlert.carModel.name
          : '$brandName, ${shopAlert.carModel.name}';
    }

    String mileage = '';

    if (shopAlert.startMileage != null) {
      mileage = shopAlert.startMileage.toString();
    }

    if (shopAlert.endMileage != null) {
      if (mileage.isEmpty) {
        mileage = '< ${shopAlert.endMileage.toString()}';
      } else {
        mileage = '$mileage - ${shopAlert.endMileage}';
      }
    } else {
      if (mileage.isNotEmpty) {
        mileage = '> $mileage';
      }
    }

    if (mileage.isNotEmpty) {
      mileage = '$mileage ${S.of(context).general_km}';
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: gray_80,
              offset: Offset(1.0, 1.0),
              blurRadius: 1.0,
            ),
          ],
        ),
        child: Container(
          child: Material(
            color: Colors.white,
            child: InkWell(
              splashColor: Theme.of(context).primaryColor,
              onTap: () => this.selectShopAlert(shopAlert),
              child: ClipRRect(
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (brandName != null)
                              _titleContainer(S.of(context).general_brand),
                            if (brandName != null)
                              _subtitleContainer(brandName),
                            if (year.isNotEmpty)
                              _titleContainer(S.of(context).general_year),
                            if (year.isNotEmpty) _subtitleContainer(year),
                            if (mileage.isNotEmpty)
                              _titleContainer(S.of(context).general_mileage),
                            if (mileage.isNotEmpty) _subtitleContainer(mileage),
                            if (price.isNotEmpty)
                              _titleContainer(S.of(context).general_price),
                            if (price.isNotEmpty) _subtitleContainer(price),
                          ],
                        ),
                      ),
                      _getRemoveButton(context)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  _titleContainer(String text) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: TextHelper.customTextStyle(
            color: gray2, weight: FontWeight.bold, size: 14),
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
              style: TextHelper.customTextStyle(size: 14),
            ),
          )
        ],
      ),
    );
  }

  _getRemoveButton(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 54.0,
      height: 54.0,
      child: GestureDetector(
          onTap: () => removeShopAlert(this.shopAlert),
          child: Icon(Icons.close,
              color: Theme.of(context).accentColor, size: 32)),
    );
  }
}
