import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-item.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-sub-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDetailsServicesConsultant extends StatelessWidget {
  ServiceProviderItemsResponse response;

  UserDetailsServicesConsultant({this.response});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 20),
      child: Column(
        children: <Widget>[
          for (ServiceProviderItem item in response.items)
            _serviceProvideContainer(context, item)
        ],
      ),
    );
  }

  _serviceProvideContainer(
      BuildContext buildContext, ServiceProviderItem item) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              _translateServiceName(buildContext, item.name),
              textAlign: TextAlign.left,
              style: TextHelper.customTextStyle(
                  null, black_text, FontWeight.bold, 14),
            ),
          ),
          for (ServiceProviderSubItem subItem in item.items)
            _buildSubItemContainer(buildContext, subItem)
        ],
      ),
    );
  }

  _buildSubItemContainer(BuildContext context, ServiceProviderSubItem subItem) {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 5),
      child: Row(
        children: <Widget>[
          Container(
            width: 14,
            height: 14,
            decoration: new BoxDecoration(
              color: gray2,
              borderRadius: BorderRadius.all(
                Radius.circular(7.0),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              subItem.name,
              style: TextHelper.customTextStyle(null, gray2, null, 14),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${subItem.rate} ${S.of(context).general_currency}',
                style: TextHelper.customTextStyle(null, red, null, 14),
              ),
            ),
          )
        ],
      ),
    );
  }

  String _translateServiceName(BuildContext context, String serviceName) {
    switch (serviceName) {
      case 'SERVICE':
        return S.of(context).SERVICE;
      case 'CAR_WASHING':
        return S.of(context).CAR_WASHING;
      case 'PAINT_SHOP':
        return S.of(context).PAINT_SHOP;
      case 'TIRE_SHOP':
        return S.of(context).TIRE_SHOP;
      case 'TOW_SERVICE':
        return S.of(context).TOW_SERVICE;
      case 'PICKUP_RETURN':
        return S.of(context).PICKUP_RETURN;
      default:
        return '';
    }
  }
}
