import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/details/service-provider/service-provider-fiscal-widget.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/details/service-provider/service-provider-items-widget.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/details/service-provider/service-provider-reviews-widget.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceDetailsWidget extends StatefulWidget {
  @override
  ServiceDetailsWidgetState createState() => ServiceDetailsWidgetState();
}

class ServiceDetailsWidgetState extends State<ServiceDetailsWidget> {
  TabBarState currentState = TabBarState.SERVICES;

  @override
  Widget build(BuildContext context) {
    ServiceProviderDetailsProvider provider = Provider.of<ServiceProviderDetailsProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: 200,
          child: Image.network(
            provider.serviceProvider.image,
            fit: BoxFit.fill,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Text(
            provider.serviceProvider.name,
            style: TextStyle(
                fontFamily: "Lato", fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        _buildTabBar(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: _getContainer(),
          ),
        )
      ],
    );
  }

  Widget _getContainer() {
    switch (currentState) {
      case TabBarState.SERVICES:
        return ServiceProviderItemWidget();
        break;
      case TabBarState.REVIEWS:
        return ServiceProviderReviewsWidget();
      case TabBarState.FISCAL:
        return ServiceProviderFiscalInfoWidget();
      default:
    }
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 40,
      child: new Row(
        children: <Widget>[
          _buildTabBarButton(TabBarState.SERVICES),
          _buildTabBarButton(TabBarState.REVIEWS),
          _buildTabBarButton(TabBarState.FISCAL),
          _buildTabBarButton(TabBarState.PROMOTIONS),
        ],
      ),
    );
  }

  Widget _buildTabBarButton(TabBarState state) {
    Color bottomColor = (currentState == state) ? red : gray_80;

    return Expanded(
      flex: 1,
      child: Container(
          child: Center(
            child: FlatButton(
              child: Text(
                stateTitle(state, context),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Lato",
                    color: red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
              onPressed: () {
                setState(() {
                  currentState = state;
                });
              },
            ),
          ),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(width: 1.0, color: bottomColor),
          ))),
    );
  }
}

enum TabBarState { SERVICES, REVIEWS, FISCAL, PROMOTIONS }

String stateTitle(TabBarState state, BuildContext context) {
  switch (state) {
    case TabBarState.SERVICES:
      return S.of(context).service_services;
      break;
    case TabBarState.REVIEWS:
      return S.of(context).service_reviews;
      break;
    case TabBarState.FISCAL:
      return S.of(context).service_fiscal;
      break;
    case TabBarState.PROMOTIONS:
      return S.of(context).service_promotions;
      break;
  }
}