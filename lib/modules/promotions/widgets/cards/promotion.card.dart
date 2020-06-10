import 'package:app/modules/promotions/enum/promotion-status.enum.dart';
import 'package:app/modules/promotions/models/promotion.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/generated/l10n.dart';

class PromotionCard extends StatelessWidget {
  final Function selectPromotion;
  final Promotion promotion;

  PromotionCard({this.promotion, this.selectPromotion});

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
            onTap: () => this.selectPromotion(),
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
                        margin: EdgeInsets.only(top: 2, bottom: 2),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _titleContainer(),
                                _detailsContainer()
                              ],
                            ),
                            Positioned(
                              child: Align(
                                  alignment: FractionalOffset.bottomLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                        PromotionStatusUtils.title(
                                            context, promotion.getStatus()),
                                        style: TextStyle(
                                            color: red,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            height: 1.5)),
                                  )),
                            ),
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
    return promotion.discount == 0.0
        ? Container()
        : Container(
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
                      '-${promotion.discount.toStringAsFixed(0)}%',
                      style: TextHelper.customTextStyle(
                          null, Colors.white, null, 14),
                    )),
                  ),
                )
              ],
            ),
          );
  }

  _imageContainer(BuildContext context) {
    return Container(
        width: 120,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: (promotion.images.length > 0)
                        ? FadeInImage.assetNetwork(
                            width: 100,
                            height: 100,
                            image: promotion.images[0].name,
                            placeholder: 'assets/images/icons/camera.svg',
                            fit: BoxFit.contain,
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
            if (true) _pointContainer(context),
          ],
        ));
  }

  _titleContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(promotion.title,
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
      child: Text(promotion.description,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
              color: Colors.black87,
              fontFamily: null,
              fontWeight: FontWeight.normal,
              fontSize: 12)),
    );
  }

  _priceContainer(BuildContext context) {
    return Container(
      child: Text(
          '${promotion.price.toStringAsFixed(1)} ${S.of(context).general_currency}',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: red,
              fontFamily: null,
              fontWeight: FontWeight.bold,
              fontSize: 14)),
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
              style: TextHelper.customTextStyle(null, Colors.white, null, 14),
            ),
          )
        ],
      ),
    );
  }

  _valabilityContainer(BuildContext context) {
    String startDate = promotion.startDate != null
        ? DateUtils.stringFromDate(promotion.startDate, 'dd MMM')
        : '';
    String endDate = promotion.endDate != null
        ? DateUtils.stringFromDate(promotion.endDate, 'dd MMM')
        : '';

    String title = '';

    if (startDate.isNotEmpty) {
      title = startDate;
    }

    if (endDate.isNotEmpty) {
      if (title.isEmpty) {
        title = endDate;
      } else {
        title = '$title - $endDate';
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        title,
        style:
            TextHelper.customTextStyle(null, black_text, FontWeight.bold, 12),
      ),
    );
  }
}
