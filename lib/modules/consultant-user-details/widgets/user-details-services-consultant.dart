import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-item.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-sub-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';

class UserDetailsServicesConsultant extends StatelessWidget {
  ServiceProviderItemsResponse response;

  UserDetailsServicesConsultant({this.response});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (ServiceProviderItem item in response.items)
            _serviceProvideContainer(context, item)
        ],
      ),
    );
  }

  _serviceProvideContainer(BuildContext buildContext, ServiceProviderItem item) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                item.name,
                style: TextHelper.customTextStyle(
                    null, black_text, FontWeight.bold, 14),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${item.rate} ${S.of(buildContext).general_currency}',
                    style: TextHelper.customTextStyle(null, red, null, 14),
                  ),
                ),
              )
            ],
          ),
          for (ServiceProviderSubItem subItem in item.items)
            _buildSubItemContainer(subItem)
        ],
      ),
    );
  }

  _buildSubItemContainer(ServiceProviderSubItem subItem) {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 5),
      child: Row(
        children: <Widget>[
          Container(
            width: 20,
            height: 20,
            decoration: new BoxDecoration(
              color: gray2,
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text('test'),
          )
        ],
      ),
    );
  }
}
