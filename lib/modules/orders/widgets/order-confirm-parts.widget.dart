import 'package:app/generated/l10n.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/orders/providers/order.provider.dart';
import 'package:app/modules/orders/widgets/cards/order-part.card.dart';
import 'package:app/modules/orders/widgets/order-parts-final-info.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderConfirmParts extends StatefulWidget {
  Function showProviderDetails;
  Function acceptOrder;

  OrderConfirmParts({this.showProviderDetails, this.acceptOrder});

  @override
  State<StatefulWidget> createState() {
    return _OrderConfirmPartsState();
  }
}

class _OrderConfirmPartsState extends State<OrderConfirmParts> {
  OrderProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<OrderProvider>(context);

    return Scaffold(
      body: _bodyWidget(),
      floatingActionButton: _floatingButtons(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _bodyWidget() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      padding: EdgeInsets.only(bottom: 60),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  _provider.orderDetails.status.getState() ==
                      AppointmentStatusState.ACCEPTED
                      ? '${S.of(context).appointment_delivery_time}:'
                      : '${S.of(context).parts_suggested_delivery_date}:',
                  style: TextHelper.customTextStyle(null, gray3, null, 14),
                ),
                Container(
                  margin: EdgeInsets.only(left: 6),
                  child: Text(
                    DateUtils.stringFromDate(
                        _provider.orderDetails.deliveryDateTime,
                        'dd-MM-yyyy HH:mm'),
                    style: TextHelper.customTextStyle(
                        null, red, FontWeight.bold, 14),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _provider.orderDetails.items.length,
                itemBuilder: (context, index) {
                  return OrderPartCard(
                      issueItem: _provider.orderDetails.items[index]);
                }),
          )
        ],
      ),
    );
  }

  _floatingButtons(BuildContext context) {
    List<Widget> buttons = [];

    buttons.add(FloatingActionButton.extended(
      heroTag: null,
      onPressed: () {
        widget.showProviderDetails();
      },
      label: Text(
        S.of(context).online_shop_appointment_provider_details.toUpperCase(),
        style: TextHelper.customTextStyle(null, red, FontWeight.bold, 12),
      ),
      backgroundColor: Colors.white,
    ));

    if (_provider.orderDetails.status.getState() ==
        AppointmentStatusState.NEW) {
      buttons.add(FloatingActionButton.extended(
        heroTag: null,
        onPressed: () {
          _showFinalInfo();
        },
        label: Text(
          S.of(context).parts_delivery_button_title.toUpperCase(),
          style: TextHelper.customTextStyle(null, red, FontWeight.bold, 12),
        ),
        backgroundColor: Colors.white,
      ));
    }

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buttons,
      ),
    );
  }

  _showFinalInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OrderPartsFinalInfo(infoAdded: widget.acceptOrder);
      },
    );
  }
}
