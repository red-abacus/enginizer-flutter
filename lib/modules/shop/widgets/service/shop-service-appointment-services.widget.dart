import 'package:app/modules/shop/widgets/cards/shop-appointment-service.card.dart';
import 'package:flutter/cupertino.dart';

class ShopServiceAppointmentServicesWidget extends StatefulWidget {
  @override
  _ShopServiceAppointmentServicesWidgetState createState() =>
      _ShopServiceAppointmentServicesWidgetState();
}

class _ShopServiceAppointmentServicesWidgetState
    extends State<ShopServiceAppointmentServicesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _listContainer(),
        ],
      ),
    );
  }

  _listContainer() {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, index) {
          return ShopAppointmentServiceCard();
        },
        itemCount: 10,
      ),
    );
  }
}
