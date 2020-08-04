import 'package:app/modules/shop/models/shop-alert.model.dart';
import 'package:app/modules/shop/widgets/cards/shop-alert.card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopAlertList extends StatelessWidget {
  final List<ShopAlert> shopAlerts;
  final Function removeShopAlert;
  final Function selectShopAlert;

  ShopAlertList(this.shopAlerts, this.removeShopAlert, this.selectShopAlert);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 60),
          child: Column(
            children: <Widget>[
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return ShopAlertCard(
                    shopAlert: this.shopAlerts[index],
                    removeShopAlert: this.removeShopAlert,
                    selectShopAlert: this.selectShopAlert,
                  );
                },
                itemCount: this.shopAlerts.length,
              )
            ],
          ),
        ),
      ),
    );
  }
}
