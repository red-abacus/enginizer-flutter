import 'package:enginizer_flutter/modules/appointments/model/service-provider.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:enginizer_flutter/modules/cars/widgets/details/car-details-widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarDetailsModal extends StatefulWidget {
  @override
  _CarDetailsModalState createState() => _CarDetailsModalState();

  ServiceProvider serviceProvider;

  CarDetailsModal(this.serviceProvider);
}

class _CarDetailsModalState extends State<CarDetailsModal> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 2.0,
      child: _buildContent(widget.serviceProvider),
    );
  }

  Widget _buildContent(ServiceProvider serviceProvider) {
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
          child: CarDetailsWidget(serviceProvider),
        ),
      ),
    );
  }
}
