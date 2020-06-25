import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/modules/appointments/widgets/service-details-modal.widget.dart';
import 'package:app/modules/shop/providers/shop.provider.dart';
import 'package:app/modules/shop/screens/shop-service-appointment.modal.dart';
import 'package:app/modules/shop/screens/shop.dart';
import 'package:app/modules/shop/widgets/service/shop-service-details.widget.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopServiceDetails extends StatefulWidget {
  static const String route = '${Shop.route}/serviceDetails';

  @override
  State<StatefulWidget> createState() {
    return _ShopServiceDetailsState(route: route);
  }
}

class _ShopServiceDetailsState extends State<ShopServiceDetails> {
  String route;

  ShopProvider _provider;

  _ShopServiceDetailsState({this.route});

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
        child: _renderDetails(),
      ),
    );
  }

  _renderDetails() {
    return ShopServiceDetailsWidget(
        showAppointment: _showAppointment,
        showProviderDetails: _showProviderDetails);
  }

  _showAppointment() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return ShopServiceAppointmentModal();
          });
        });
  }

  _showProviderDetails() {
    Provider.of<ServiceProviderDetailsProvider>(context).serviceProviderId = 1;

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return StatefulBuilder(builder:
              (BuildContext context, StateSetter state) {
            return ServiceDetailsModal();
          });
        });
  }
}
