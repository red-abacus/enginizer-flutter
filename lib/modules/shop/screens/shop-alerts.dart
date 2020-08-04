import 'package:app/generated/l10n.dart';
import 'package:app/modules/shared/widgets/alert-confirmation-dialog.widget.dart';
import 'package:app/modules/shop/models/shop-alert.model.dart';
import 'package:app/modules/shop/providers/shop-alert-make.provider.dart';
import 'package:app/modules/shop/providers/shop.provider.dart';
import 'package:app/modules/shop/screens/shop-alert-create.modal.dart';
import 'package:app/modules/shop/screens/shop.dart';
import 'package:app/modules/shop/services/shop.service.dart';
import 'package:app/modules/shop/widgets/shop-alert-list.widget.dart';
import 'package:app/utils/flush_bar.helper.dart';
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
          child: _isLoading == true
              ? Center(child: CircularProgressIndicator())
              : _provider.alerts.length != 0
                  ? ShopAlertList(
                      _provider.alerts, _removeShopAlert, _selectShopAlert)
                  : Center(
                      child: Text(
                        S.of(context).online_shop_no_alerts_title,
                        style: TextHelper.customTextStyle(color: Colors.black, size: 18),
                      ),
                    ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: null,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 1,
          onPressed: () => _openShopAlertModal(),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<ShopProvider>(context);
      _loadData();
    }

    _initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider.getShopAlerts().then((alerts) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).exception_get_shop_alerts, context);

      setState(() {
        _isLoading = false;
      });
    }
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
            return ShopAlertCreateModal(
              refreshState: _refreshState,
            );
          });
        });
  }

  _removeShopAlert(ShopAlert shopAlert) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AlertConfirmationDialogWidget(
                confirmFunction: (confirm) => {
                      if (confirm) {_confirmRemoveShopAlert(shopAlert)}
                    },
                title: S.of(context).online_shop_remove_alert);
          });
        });
  }

  _confirmRemoveShopAlert(ShopAlert shopAlert) {
    setState(() {
      _isLoading = true;
    });

    try {
      _provider.removeShopAlert(shopAlert).then((value) {
        _loadData();
      });
    } catch (error) {
      if (error.toString().contains(ShopService.REMOVE_SHOP_ALERT_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_remove_shop_alert, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _refreshState() {
    _loadData();
  }

  _selectShopAlert(ShopAlert shopAlert) {
    Provider.of<ShopAlertMakeProvider>(context).initParams();
    Provider.of<ShopAlertMakeProvider>(context).shopAlert = shopAlert;

    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return ShopAlertCreateModal(
              refreshState: _refreshState,
            );
          });
        });
  }
}
