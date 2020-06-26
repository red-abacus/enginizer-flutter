import 'package:app/generated/l10n.dart';
import 'package:app/modules/orders/services/order.service.dart';
import 'package:app/modules/shop/providers/shop.provider.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopSellerDetailsModal extends StatefulWidget {
  @override
  _ShopSellerDetailsModalState createState() => _ShopSellerDetailsModalState();
}

class _ShopSellerDetailsModalState extends State<ShopSellerDetailsModal> {
  ShopProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<ShopProvider>(context);

    return FractionallySizedBox(
        heightFactor: .8,
        child: Container(
            child: ClipRRect(
                borderRadius: new BorderRadius.circular(5.0),
                child: Scaffold(
                  body: Container(
                    decoration: new BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0))),
                    child: Theme(
                        data: ThemeData(
                            accentColor: Theme.of(context).primaryColor,
                            primaryColor: Theme.of(context).primaryColor),
                        child: _buildContent()),
                  ),
                ))));
  }

  _buildContent() {
    return Container(
      child: Column(
        children: <Widget>[
          _avatarContainer(),
//          _titleWidget(context),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Divider(),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Text(
                  '${S.of(context).general_email}:',
                  style: TextHelper.customTextStyle(
                      color: gray3, weight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Text(
                    _provider.selectedShopItem.user.email,
                    style: TextHelper.customTextStyle(
                        color: gray3, weight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Text(
                  '${S.of(context).general_phone_number}:',
                  style: TextHelper.customTextStyle(
                      color: gray3, weight: FontWeight.bold),
                ),
              ),
              Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Text(
                      _provider.selectedShopItem.user.phoneNumber,
                      style: TextHelper.customTextStyle(
                          color: gray3, weight: FontWeight.bold),
                    ),
                  ),
              )
            ],
          ),
//          Container(
//            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
//            child: Text(
//              shopItem.description,
//              style: TextHelper.customTextStyle(color: gray3),
//            ),
//          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Container(
//                margin: EdgeInsets.only(top: 20, right: 10),
//                child: FlatButton(
//                  color: red,
//                  child: Text(
//                    S.of(context).online_shop_appointment_title,
//                    style: TextHelper.customTextStyle(color: Colors.white),
//                  ),
//                  onPressed: () {
//                    showAppointment();
//                  },
//                ),
//              ),
//              Container(
//                margin: EdgeInsets.only(top: 20, left: 10),
//                child: FlatButton(
//                  color: red,
//                  child: Text(
//                    S.of(context).online_shop_appointment_provider_details,
//                    style: TextHelper.customTextStyle(color: Colors.white),
//                  ),
//                  onPressed: () {
//                    showProviderDetails();
//                  },
//                ),
//              ),
//            ],
//          )
        ],
      ),
    );
  }

  _avatarContainer() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            color: red,
            height: 90,
          ),
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    child: CircleAvatar(
                      backgroundColor: gray3,
                      radius: 70,
                      child: ClipOval(
                        child: Image.network(
                            _provider.selectedShopItem.user.profilePhotoUrl,
                        fit: BoxFit.fill,),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  _provider.selectedShopItem.user.name,
                  style: TextHelper.customTextStyle(
                      color: gray3, weight: FontWeight.bold, size: 20),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
