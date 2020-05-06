import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/appointments/widgets/details/service-provider/service-details-widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

class ShopServiceDetailsModal extends StatefulWidget {
  @override
  _ShopServiceDetailsModalState createState() =>
      _ShopServiceDetailsModalState();
}

class _ShopServiceDetailsModalState extends State<ShopServiceDetailsModal> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        heightFactor: .8,
        child: Scaffold(
          body: Container(
            child: ClipRRect(
              child: Container(
                decoration:
                    new BoxDecoration(color: Theme.of(context).cardColor),
                child: Theme(
                  data: ThemeData(
                      accentColor: Theme.of(context).primaryColor,
                      primaryColor: Theme.of(context).primaryColor),
                  child: _buildContent(context),
                ),
              ),
            ),
          ),
        ));
  }

  _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _swiperWidget(),
            _titleWidget(),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Divider(),
            ),
            _valabilityContainer(),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Text(
                '${S.of(context).general_details}:',
                style: TextHelper.customTextStyle(
                    null, gray3, FontWeight.bold, 14),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Text(
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
                style: TextHelper.customTextStyle(null, gray3, null, 14),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(top: 20),
                child: FlatButton(
                  color: red,
                  child: Text(
                    S.of(context).online_shop_appointment_title,
                    style: TextHelper.customTextStyle(null, Colors.white, null, 14),
                  ), onPressed: () {},
                ),
              ),
            )
          ],
        ),
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
              'https://lh3.googleusercontent.com/4Upx9VZxU9zjgfGv80m7aCF91mM2bcVDGIn2LGSmQwhp_GqQNfVdKR7eDy1tqWH88y62OExo=w1080-h608-p-no-v0',
              fit: BoxFit.fill,
            );
          },
          autoplay: true,
          itemCount: 10,
          scrollDirection: Axis.horizontal,
          pagination: new SwiperPagination(
              margin: new EdgeInsets.all(0.0),
              builder: new SwiperCustomPagination(
                  builder: (BuildContext context, SwiperPluginConfig config) {
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

  _titleWidget() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              'Lorep ispum dolorem Lorep ispum dolorem Lorep ispum dolorem Lorep ispum dolorem Lorep ispum dolorem',
              style: TextHelper.customTextStyle(null, gray3, null, 16),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              '-50%',
              style: TextHelper.customTextStyle(null, red, null, 16),
            ),
          ),
        ],
      ),
    );
  }

  _valabilityContainer() {
    String title =
        '${S.of(context).online_shop_card_valability_title}: 20 Mai - 15 Iunie';

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextHelper.customTextStyle(null, gray, FontWeight.bold, 10),
          )
        ],
      ),
    );
  }
}
