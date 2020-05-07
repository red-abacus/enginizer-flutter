import 'package:app/modules/shop/widgets/service/shop-service-appointment.widget.dart';
import 'package:app/modules/shop/widgets/service/shop-service-details.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopServiceDetailsModal extends StatefulWidget {
  @override
  _ShopServiceDetailsModalState createState() =>
      _ShopServiceDetailsModalState();
}

class _ShopServiceDetailsModalState extends State<ShopServiceDetailsModal> {
  // TODO - remove this
  bool _showAppointmentCreation = true;
//  bool _showAppointmentCreation = false;

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
                    child: _buildContent(context)),
              ),
            ),
          ),
        ));
  }

  _buildContent(BuildContext context) {
    return !_showAppointmentCreation
        ? ShopServiceDetailsWidget(showAppointment: _showAppointment)
        : ShopServiceAppointmentWidget(showAppointment: _showAppointment);
  }

  _showAppointment(bool show) {
    setState(() {
      _showAppointmentCreation = show;
    });
  }
}
