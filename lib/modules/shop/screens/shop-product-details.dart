import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/widgets/text_widget.dart';
import 'package:app/modules/shop/providers/shop.provider.dart';
import 'package:app/modules/shop/screens/shop.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopProductDetails extends StatefulWidget {
  static const String route = '${Shop.route}/productDetails';

  @override
  State<StatefulWidget> createState() {
    return _ShopProductDetailsState(route: route);
  }
}

class _ShopProductDetailsState extends State<ShopProductDetails> {
  String route;

  ShopProvider _provider;

  _ShopProductDetailsState({this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextHelper.customTextStyle(
              color: Colors.white, weight: FontWeight.bold, size: 20),
        ),
        iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
      ),
      body: Center(
        child: _buildContent(context),
      ),
    );
  }

  _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _imageWidget(),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20, right: 20),
              child: TextWidget(
                'Seat Ibiza',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, left: 20, right: 20),
              child: TextWidget(
                '1997, Albastru',
                fontSize: 14,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 25),
                child: TextWidget('Benzina, Transmisie manuala')),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextWidget('102 CP, 120 kW'),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextWidget('227.000 km'),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextWidget('VIN: VZZTA34AAGH6AWIXCZ'),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextWidget('CJ-10-GTI'),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextWidget('RCA valabil pana in: 01.03.2020'),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: TextWidget('ITP valabil pana in: 01.03.2020'),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(top: 20),
                child: FlatButton.icon(
                  icon: Icon(Icons.phone, color: Colors.white),
                  color: red,
                  label: Text(
                    S.of(context).online_shop_call,
                    style: TextHelper.customTextStyle(
                        color: Colors.white),
                  ),
                  onPressed: () {
                    _callSeller();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _imageWidget() {
    return Container(
      height: 300,
      child: Swiper(
          outer: true,
          itemBuilder: (BuildContext context, int index) {
            return Image.network(
              'https://www.extremetech.com/wp-content/uploads/2019/12/SONATA-hero-option1-764A5360-edit.jpg',
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

  _callSeller() async {
    const url = "tel:40123456789";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).online_shop_call_error, context);
    }
  }

  _showAppointment() {

  }
}
