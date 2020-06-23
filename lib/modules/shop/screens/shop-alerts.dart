import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/providers/cars-make.provider.dart';
import 'package:app/modules/shop/providers/shop-alert-make.provider.dart';
import 'package:app/modules/shop/providers/shop.provider.dart';
import 'package:app/modules/shop/screens/shop-alert-create.modal.dart';
import 'package:app/modules/shop/screens/shop.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopAlerts extends StatefulWidget {
  static const String route = '${Shop.route}/shopAlerts';

  @override
  State<StatefulWidget> createState() {
    return ShopAlertsState(route: route);
  }
}

class ShopAlertsState extends State<ShopAlerts> {
  String route;
  var _initDone = false;
  var _isLoading = false;

  ShopProvider _provider;

  ShopAlertsState({this.route});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopProvider>(
      builder: (context, shopProvider, _) => Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).general_alerts,
            style: TextHelper.customTextStyle(
                color: Colors.white, weight: FontWeight.bold, size: 20),
          ),
          iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
        ),
          body: Center(
            child: Container(),
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: null,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 1,
            onPressed: () => _openShopAlertModal(),
            child: Icon(Icons.add),
          ),),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<ShopProvider>(context);
    }

    _initDone = true;
    super.didChangeDependencies();
  }

  _renderList(bool _isLoading) {

  }

  _openShopAlertModal() {
    Provider.of<ShopAlertMakeProvider>(context).initParams();

    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return ShopAlertCreateModal();
          });
        });
  }
}
