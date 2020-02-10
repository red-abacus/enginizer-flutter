import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/details/service-details-widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceDetailsModal extends StatefulWidget {
  @override
  _ServiceDetailsModalState createState() => _ServiceDetailsModalState();

  ServiceProvider serviceProvider;

  ServiceDetailsModal(this.serviceProvider);
}

class _ServiceDetailsModalState extends State<ServiceDetailsModal> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: new BorderRadius.circular(5.0),
      child: Container(
        decoration: new BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0))),
        child: Theme(
          data: ThemeData(
              accentColor: Theme.of(context).primaryColor,
              primaryColor: Theme.of(context).primaryColor),
          child: ServiceDetailsWidget(widget.serviceProvider),
        ),
      ),
    );
  }
}
