import 'package:app/generated/l10n.dart';
import 'package:app/modules/parts/providers/parts.provider.dart';
import 'package:app/modules/parts/screens/parts.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

class Part extends StatefulWidget {
  static const String route = '${Parts.route}/part';

  @override
  State<StatefulWidget> createState() {
    return _PartState(route: route);
  }
}

class _PartState extends State<Part> {
  String route;

  PartsProvider _provider;

  _PartState({this.route});

  @override
  Widget build(BuildContext context) {
    if (_provider == null) {
      _provider = Provider.of<PartsProvider>(context);
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _swiperWidget(),
              _titleWidget(),
              _codeWidget(),
              _guaranteeWidget(),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Divider(),
              ),
              _priceWidget(),
              _priceAddition(),
              _priceVat(),
            ],
          ),
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
              'https://5.imimg.com/data5/OL/UH/MY-2574174/bolero-brake-disc-500x500.jpg',
              fit: BoxFit.fitHeight,
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
        children: <Widget>[
          Expanded(
            child: Text(
              _provider.selectedPart.name,
              style:
                  TextHelper.customTextStyle(color: gray3, weight: FontWeight.bold, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  _codeWidget() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 4),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              _provider.selectedPart.code,
              style:
                  TextHelper.customTextStyle(color: gray, weight: FontWeight.bold, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  _guaranteeWidget() {
    String guaranteeTitle = '-';

    if (_provider.selectedPart.guarantee == 1) {
      guaranteeTitle =
          '${_provider.selectedPart.guarantee} ${S.of(context).general_month}';
    } else if (_provider.selectedPart.guarantee > 1) {
      guaranteeTitle =
          '${_provider.selectedPart.guarantee} ${S.of(context).general_months}';
    }

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              '${S.of(context).general_guarantee}:',
              style: TextHelper.customTextStyle(color: black_text),
            ),
          ),
          Text(
            guaranteeTitle,
            style: TextHelper.customTextStyle(color: red, weight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  _priceWidget() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              '${S.of(context).estimator_priceNoVAT}',
              style: TextHelper.customTextStyle(color: black_text),
            ),
          ),
          Text(
            '${_provider.selectedPart.price}',
            style: TextHelper.customTextStyle(color: red, weight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  _priceAddition() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              '${S.of(context).general_addition}',
              style: TextHelper.customTextStyle(color: black_text),
            ),
          ),
          Text(
            '${_provider.selectedPart.addition}',
            style: TextHelper.customTextStyle(color: red, weight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  _priceVat() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              '${S.of(context).estimator_total}',
              style: TextHelper.customTextStyle(color: black_text),
            ),
          ),
          Text(
            '${_provider.selectedPart.price + _provider.selectedPart.priceVAT}',
            style: TextHelper.customTextStyle(color: red, weight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
