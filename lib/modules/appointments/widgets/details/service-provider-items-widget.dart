import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-item.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';
import 'package:enginizer_flutter/utils/constants.dart';
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
        Provider
            .of<ProviderServiceProvider>(context)
            .serviceProviderItems;

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
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                item.name,
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
