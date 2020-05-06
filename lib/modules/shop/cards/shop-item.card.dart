import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/generated/l10n.dart';

class ShopItemCard extends StatelessWidget {
  final Function selectShopItem;
  final int index;

  ShopItemCard({this.index, this.selectShopItem});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.only(bottom: 10, left: 40, right: 40),
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
        child: Material(
          color: Colors.white,
          child: InkWell(
            splashColor: Theme.of(context).primaryColor,
            onTap: () => this.selectShopItem(),
            child: ClipRRect(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _imageContainer(context),
                    _titleContainer(),
                    _detailsContainer(),
                    _priceContainer(context),
                    _detailsButton(context),
                    _valabilityContainer(context),

//                    _statusContainer(context),
                  ]),
            ),
          ),
        ),
      );
    });
  }

  _pointContainer(BuildContext context) {
    return Container(
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
                    style: TextHelper.customTextStyle(null, Colors.white, null, 14),
                  )),
            ),
          )
        ],
      ),
    );
  }

  _imageContainer(BuildContext context) {
    return Container(
        height: 150,
        color: index % 2 == 0 ? Colors.white : light_gray_2,
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: index % 2 == 0
                        ? Image.network(
                            'https://s12emagst.akamaized.net/products/16094/16093852/images/res_79d7f7169b8c13ec5cbb1142dcaa4499_450x450_tiqb.jpg',
                            fit: BoxFit.fitHeight,
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
                                      null, gray2, null, 12),
                                ),
                              ),
                            ],
                          ))
              ],
            ),
            if (index % 2 == 0) _pointContainer(context),
          ],
        ));
  }

  _titleContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Text(
          'Pickup & Return / Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          style: TextStyle(
              color: Colors.black87,
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
              fontSize: 14)),
    );
  }

  _detailsContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent gravida condimentum purus ut rhoncus. Etiam malesuada orci turpis, a varius orci sagittis at. Curabitur rutrum eget quam et ullamcorper. Nullam vel ante rhoncus, aliquet lacus vel, sodales nisi. Suspendisse potenti. Curabitur in purus varius, fermentum ante id, porttitor nunc. Donec sit amet eros aliquam, pellentesque arcu et, ultrices sem. Morbi eu turpis quis enim tincidunt mollis. Maecenas eget ante euismod, dictum leo ac, fringilla neque. Phasellus eget arcu massa. Aenean imperdiet ullamcorper nisi et hendrerit. ',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.black87,
              fontFamily: null,
              fontWeight: FontWeight.normal,
              fontSize: 12)),
    );
  }

  _priceContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(S.of(context).online_shop_card_seller_info_title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: red,
                    fontFamily: null,
                    fontWeight: FontWeight.normal,
                    fontSize: 12)),
          ),
          Text('1200 LEI',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: red,
                  fontFamily: null,
                  fontWeight: FontWeight.normal,
                  fontSize: 14))
        ],
      ),
    );
  }

  _detailsButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
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
              style: TextHelper.customTextStyle(null, Colors.white, null, 14),
            ),
          )
        ],
      ),
    );
  }

  _valabilityContainer(BuildContext context) {
    String title =
        '${S.of(context).online_shop_card_valability_title}: 20 Mai - 15 Iunie';

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextHelper.customTextStyle(
                null, black_text, FontWeight.bold, 12),
          )
        ],
      ),
    );
  }
}
