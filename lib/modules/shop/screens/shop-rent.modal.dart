import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/promotions/services/promotion.service.dart';
import 'package:app/modules/shop/providers/shop-appointment.provider.dart';
import 'package:app/modules/shop/widgets/rent-form/shop-rent-details.form.dart';
import 'package:app/modules/shop/widgets/rent-form/shop-rent-schedule.form.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopRentModal extends StatefulWidget {
  @override
  _ShopRentModalState createState() => _ShopRentModalState();
}

class _ShopRentModalState extends State<ShopRentModal> {
  bool _initDone = false;
  bool _isLoading = false;

  int _currentStepIndex = 0;
  bool _isLastStep = false;

  ShopAppointmentProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<ShopAppointmentProvider>(context);

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
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _contentWidget()),
              ),
            ),
          ),
        ));
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<ShopAppointmentProvider>(context);

      setState(() {
        _isLoading = true;
      });

      _loadData();
      _initDone = true;
    }

    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _provider
          .getServiceProvider(_provider.shopItem.providerId)
          .then((_) async {
        await _provider.getCarDetails(_provider.shopItem.carId).then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(ProviderService.GET_PROVIDER_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_provider_details, context);
      } else if (error.toString().contains(CarService.CAR_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_car_details, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _contentWidget() {
    double finalPrice = 0;

    if (this._provider.shopItem != null) {
      finalPrice = this._provider.shopItem.price -
          this._provider.shopItem.discount /
              100 *
              this._provider.shopItem.price;
    }

    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 60),
            child: Column(
              children: [
                Container(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).online_shop_rent_car_title,
                        style:
                            TextHelper.customTextStyle(size: 20, color: gray3),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (this._provider.shopItem != null &&
                              this._provider.shopItem.discount > 0)
                            Text(
                                '${_provider.shopItem.price.toStringAsFixed(1)} ${S.of(context).general_currency}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: black_text,
                                    fontFamily: null,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14)),
                          Text(
                              '${finalPrice.toStringAsFixed(1)} ${S.of(context).general_currency}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: red,
                                  fontFamily: null,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14))
                        ],
                      )
                    ],
                  ),
                ),
                Divider(
                  color: gray_80,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: _getContentWidget(),
                )
              ],
            ),
          ),
        ),
        _bottomButtonsWidget(),
      ],
    );
  }

  _bottomButtonsWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: Text(
                S.of(context).general_back,
                style: TextHelper.customTextStyle(color: red),
              ),
              onPressed: _back,
            ),
            FlatButton(
              child: _isLastStep
                  ? Text(
                      S.of(context).general_create,
                      style: TextHelper.customTextStyle(color: red),
                    )
                  : Text(
                      S.of(context).general_continue,
                      style: TextHelper.customTextStyle(color: red),
                    ),
              onPressed: _next,
            )
          ],
        ),
      ),
    );
  }

  _getContentWidget() {
    if (_currentStepIndex == 0) {
      return ShopRentScheduleForm();
    } else if (_currentStepIndex == 1) {
      return ShopRentDetailsForm();
    }
  }

  _next() {
    if (_currentStepIndex == 0) {
      if (_provider.startDateTime != null && _provider.endDateTime != null) {
        setState(() {
          _isLastStep = true;
          _currentStepIndex = 1;
        });
      }
    } else {
      _submit();
    }
  }

  _back() {
    if (_currentStepIndex == 0) {
      Navigator.of(context).pop();
    } else if (_currentStepIndex == 1) {
      setState(() {
        _isLastStep = false;
        _currentStepIndex = 0;
      });
    }
  }

  _submit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .usePromotion(_provider.getUsePromotionRequest())
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error.toString().contains(PromotionService.USE_PROMOTION_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_use_promotion, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
