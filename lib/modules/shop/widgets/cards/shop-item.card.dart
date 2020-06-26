import 'package:app/modules/appointments/model/generic-model.dart';
import 'package:app/modules/shop/models/shop-item.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/generated/l10n.dart';

class ShopItemCard extends StatelessWidget {
  final ShopItem shopItem;
  final Function selectShopItem;

  ShopItemCard({this.selectShopItem, this.shopItem});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: red,
          boxShadow: [
            BoxShadow(
              color: gray_80,
              offset: Offset(1.0, 1.0),
              blurRadius: 1.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          child: InkWell(
            splashColor: Theme.of(context).primaryColor,
            onTap: () => this.selectShopItem(),
            child: ClipRRect(
              child: Container(
                height: 120,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _imageContainer(context),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 6, bottom: 6),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _titleContainer(),
                            Expanded(
                              child: _detailsContainer(),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Align(
                        alignment: FractionalOffset.centerRight,
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              _priceContainer(context),
                              _detailsButton(context),
                              _valabilityContainer(context)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  _pointContainer(BuildContext context) {
    return this.shopItem.discount > 0
        ? Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Container(
                  width: 5,
                  height: 40,
                  color: red_dark,
                ),
                Point(
                  triangleHeight: 10,
                  edge: Edge.RIGHT,
                  child: Container(
                    color: red_light,
                    width: 50,
                    height: 40,
                    child: Center(
                        child: Text(
                      '-50%',
                      style: TextHelper.customTextStyle(color: Colors.white),
                    )),
                  ),
                )
              ],
            ),
          )
        : Container();
  }

  _imageContainer(BuildContext context) {
    GenericModel image;

    if (this.shopItem.images.length > 0) {
      image = this.shopItem.images.first;
    }

    return Container(
        width: 100,
        color: image != null ? Colors.white : light_gray_2,
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: image != null
                        ? Image.network(
                            image.name,
                            width: 100,
                            height: 120,
                            fit: BoxFit.fitWidth,
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/images/icons/camera.svg',
                                semanticsLabel: 'No Photo',
                                color: gray2,
                                height: 30,
                                width: 30,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 6),
                                child: Text(
                                  S
                                      .of(context)
                                      .online_shop_card_no_photos_title,
                                  style: TextHelper.customTextStyle(
                                      color: gray2, size: 10),
                                ),
                              ),
                            ],
                          ))
              ],
            ),
            _pointContainer(context),
          ],
        ));
  }

  _titleContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(this.shopItem.title,
          maxLines: 2,
          style: TextStyle(
              color: Colors.black87,
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
              fontSize: 14)),
    );
  }

  _detailsContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(this.shopItem.description,
          overflow: TextOverflow.ellipsis,
          maxLines: 10,
          style: TextStyle(
              color: Colors.black87,
              fontFamily: null,
              fontWeight: FontWeight.normal,
              fontSize: 12)),
    );
  }

  _priceContainer(BuildContext context) {
    double finalPrice = this.shopItem.price -
        this.shopItem.discount / 100 * this.shopItem.price;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (this.shopItem.discount > 0)
          Container(
            child: Text('${this.shopItem.price.toStringAsFixed(1)} ${S.of(context).general_currency}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: black_text,
                    fontFamily: null,
                    fontWeight: FontWeight.normal,
                    fontSize: 14)),
          ),
        Container(
          child: Text(
              '${finalPrice.toStringAsFixed(1)} ${S.of(context).general_currency}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: red,
                  fontFamily: null,
                  fontWeight: FontWeight.normal,
                  fontSize: 14)),
        )
      ],
    );
  }

  _detailsButton(BuildContext context) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(top: 10),
      color: red_light,
      height: 40,
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 10,
                child: Container(
                  color: red_dark,
                ),
              ),
              Triangle.isosceles(
                child: Container(
                  width: 20,
                  color: red_dark,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              )
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              S.of(context).general_details.toUpperCase(),
              style: TextHelper.customTextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  _valabilityContainer(BuildContext context) {
    DateTime startDate =
        DateUtils.dateFromString(this.shopItem.startDate, 'dd/MM/yyyy');
    DateTime endDate =
        DateUtils.dateFromString(this.shopItem.endDate, 'dd/MM/yyyy');

    String title = '';

    if (startDate != null) {
      title = DateUtils.stringFromDate(startDate, 'dd MMMM');
    }

    if (endDate != null) {
      if (title.isEmpty) {
        title = DateUtils.stringFromDate(endDate, 'dd MMMM');
      } else {
        title = '$title - ${DateUtils.stringFromDate(endDate, 'dd MMMM')}';
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        title,
        style: TextHelper.customTextStyle(
            color: black_text, weight: FontWeight.bold, size: 12),
      ),
    );
  }
}
