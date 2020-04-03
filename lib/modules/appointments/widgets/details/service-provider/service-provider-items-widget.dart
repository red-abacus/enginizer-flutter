import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceProviderItemWidget extends StatefulWidget {
  @override
  ServiceProviderItemWidgetState createState() {
    return ServiceProviderItemWidgetState();
  }
}

class ServiceProviderItemWidgetState extends State<ServiceProviderItemWidget> {
  @override
  Widget build(BuildContext context) {
    List<ServiceProviderItem> items =
        Provider.of<ServiceProviderDetailsProvider>(context)
            .serviceProviderItemsResponse
            .items;

    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildRow(items[index]);
      },
      scrollDirection: Axis.vertical,
      itemCount: items.length,
    );
  }

  Widget _buildRow(ServiceProviderItem item) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 6, bottom: 6),
      child: Row(
        children: <Widget>[
          Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
              color: red,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              item.name,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(
                '- ${item.rate} ${S.of(context).general_currency}',
                style: TextStyle(
                  fontSize: 14,
                  color: gray,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
