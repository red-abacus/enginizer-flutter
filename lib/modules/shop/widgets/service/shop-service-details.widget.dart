import 'package:app/generated/l10n.dart';
import 'package:app/modules/shop/models/shop-item.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ShopServiceDetailsWidget extends StatelessWidget {
  final Function showAppointment;
  final Function showProviderDetails;
  final ShopItem shopItem;

  ShopServiceDetailsWidget(
      {this.showAppointment, this.showProviderDetails, this.shopItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          if (shopItem.images.length > 0)
            _swiperWidget(),
          _titleWidget(context),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Divider(),
          ),
          _valabilityContainer(context),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Text(
              '${S.of(context).general_details}:',
              style: TextHelper.customTextStyle(
                  color: gray3, weight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Text(
              shopItem.description,
              style: TextHelper.customTextStyle(color: gray3),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20, right: 10),
                child: FlatButton(
                  color: red,
                  child: Text(
                    S.of(context).online_shop_appointment_title,
                    style: TextHelper.customTextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    showAppointment();
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, left: 10),
                child: FlatButton(
                  color: red,
                  child: Text(
                    S.of(context).online_shop_appointment_provider_details,
                    style: TextHelper.customTextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    showProviderDetails();
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _swiperWidget() {
    return Container(
      height: 300,
      child: Swiper(
          outer: true,
          itemBuilder: (BuildContext context, int index) {
            return Image.network(
              this.shopItem.images[index].name,
              fit: BoxFit.fill,
            );
          },
          autoplay: true,
          itemCount: shopItem.images.length,
          scrollDirection: Axis.horizontal,
          pagination: new SwiperPagination(
              margin: new EdgeInsets.all(0.0),
              builder: new SwiperCustomPagination(builder:
                  (BuildContext context, SwiperPluginConfig config) {
                return new ConstrainedBox(
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Align(
                          alignment: Alignment.center,
                          child: new DotSwiperPaginationBuilder(
                              color: gray_80,
                              activeColor: red,
                              size: 10.0,
                              activeSize: 10.0)
                              .build(context, config),
                        ),
                      )
                    ],
                  ),
                  constraints: new BoxConstraints.expand(height: 50.0),
                );
              }))),
    );
  }

  _titleWidget(BuildContext context) {
    double finalPrice = this.shopItem.price -
        this.shopItem.discount / 100 * this.shopItem.price;

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Text(
                shopItem.title,
                style: TextHelper.customTextStyle(color: gray3, size: 16),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        '${this.shopItem.price.toStringAsFixed(1)} ${S.of(context).general_currency}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: black_text,
                            fontFamily: null,
                            fontWeight: FontWeight.normal,
                            fontSize: 14)),
                    if (shopItem.discount > 0)
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          '(-${shopItem.discount}%)',
                          style: TextHelper.customTextStyle(color: red, size: 16),
                        ),
                      ),
                  ],
                ),
                Text(
                    '${finalPrice.toStringAsFixed(1)} ${S.of(context).general_currency}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: red,
                        fontFamily: null,
                        fontWeight: FontWeight.normal,
                        fontSize: 14))
              ],
            ),
          )
        ],
      ),
    );
  }

  _valabilityContainer(BuildContext context) {
    String title =
        '${S.of(context).online_shop_card_valability_title}: ${shopItem.getDateTitle()}';

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextHelper.customTextStyle(
                color: gray, weight: FontWeight.bold, size: 12),
          )
        ],
      ),
    );
  }
}
