import 'package:app/generated/l10n.dart';
import 'package:app/modules/consultant-appointments/enums/payment-method.enum.dart';
import 'package:app/modules/consultant-appointments/enums/tank-quantity.enum.dart';
import 'package:app/modules/consultant-appointments/providers/pick-up-car-form-consultant.provider.dart';
import 'package:app/modules/shared/widgets/custom-text-form-field.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickupCarFormInformationWidget extends StatefulWidget {
  @override
  _PickupCarFormInformationWidgetState createState() {
    return _PickupCarFormInformationWidgetState();
  }
}

class _PickupCarFormInformationWidgetState
    extends State<PickupCarFormInformationWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  PickUpCarFormConsultantProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<PickUpCarFormConsultantProvider>(context);
    _provider.informationFormState = _formKey;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _clientBoughtPartsWidget(),
            _clientKeepPartsWidget(),
            _fuelWidget(),
            _paymentMethodWidget(),
            _kmWidget(),
            _oilChangeWidget(),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: _addTitle(
                  S.of(context).appointment_consultant_car_form_damaged_items),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                border: Border.all(
                  color: gray2,
                  width: 1.0,
                ),
              ),
              margin: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  onChanged: (value) {
                    setState(() {
                      _provider.receiveFormRequest.damagedItems = value;
                    });
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: _addTitle(
                  S.of(context).appointment_consultant_car_form_observation),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                border: Border.all(
                  color: gray2,
                  width: 1.0,
                ),
              ),
              margin: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  onChanged: (value) {
                    setState(() {
                      _provider.receiveFormRequest.observations = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _clientBoughtPartsWidget() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Text(
            S.of(context).appointment_consultant_car_form_client_parts,
            style:
                TextHelper.customTextStyle(null, gray2, FontWeight.normal, 16),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Checkbox(
              onChanged: (bool value) {
                setState(() {
                  _provider.receiveFormRequest.clientParts = value;
                });
              },
              value: _provider.receiveFormRequest.clientParts,
            ),
          )
        ],
      ),
    );
  }

  _clientKeepPartsWidget() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Text(
            S.of(context).appointment_consultant_car_form_client_keep_parts,
            style:
                TextHelper.customTextStyle(null, gray2, FontWeight.normal, 16),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Checkbox(
              onChanged: (bool value) {
                setState(() {
                  _provider.receiveFormRequest.clientKeepParts = value;
                });
              },
              value: _provider.receiveFormRequest.clientKeepParts,
            ),
          )
        ],
      ),
    );
  }

  _kmWidget() {
    return CustomTextFormField(
      textInputType: TextInputType.number,
      labelText: S.of(context).appointment_consultant_car_form_real_km,
      listener: (value) {
        _provider.receiveFormRequest.km = value;
      },
      currentValue: _provider.receiveFormRequest.km,
      errorText: S.of(context).appointment_consultant_car_form_real_km_error,
      validate: true,
    );
  }

  _fuelWidget() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: DropdownButtonFormField(
        hint: Text(S.of(context).appointment_consultant_car_form_tank_quantity),
        items: _buildTankQuantityDropdownItems(),
        value: _provider.receiveFormRequest.tankQuantity,
        validator: (value) {
          if (value == null) {
            return S
                .of(context)
                .appointment_consultant_car_form_tank_quantity_error;
          } else {
            return null;
          }
        },
        onChanged: (newValue) {
          setState(() {
            _provider.receiveFormRequest.tankQuantity = newValue;
          });
        },
      ),
    );
  }

  _paymentMethodWidget() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: DropdownButtonFormField(
        hint: Text(S.of(context).appointment_consultant_payment_method),
        items: _buildPaymentMethodDropdownItems(),
        value: _provider.receiveFormRequest.paymentMethod,
        validator: (value) {
          if (value == null) {
            return S.of(context).appointment_consultant_payment_method_error;
          } else {
            return null;
          }
        },
        onChanged: (newValue) {
          setState(() {
            _provider.receiveFormRequest.paymentMethod = newValue;
          });
        },
      ),
    );
  }

  _oilChangeWidget() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: CustomTextFormField(
        labelText: S.of(context).appointment_consultant_car_form_oil_change,
        listener: (value) {
          _provider.receiveFormRequest.oilChange = value;
        },
        currentValue: _provider.receiveFormRequest.oilChange,
        errorText:
            S.of(context).appointment_consultant_car_form_oil_change_error,
        validate: false,
      ),
    );
  }

  List<DropdownMenuItem<TankQuantity>> _buildTankQuantityDropdownItems() {
    List<DropdownMenuItem<TankQuantity>> quantityDropdownList = [];

    TankQuantityUtils.tankQuantities().forEach((tankQuantity) {
      quantityDropdownList.add(DropdownMenuItem(
          value: tankQuantity,
          child: Text(
              TankQuantityUtils.titleForTankQuantity(context, tankQuantity))));
    });

    return quantityDropdownList;
  }

  List<DropdownMenuItem<PaymentMethod>> _buildPaymentMethodDropdownItems() {
    List<DropdownMenuItem<PaymentMethod>> paymentMethodsList = [];

    PaymentMethodUtilities.paymentMethods().forEach((paymentMethod) {
      paymentMethodsList.add(DropdownMenuItem(
          value: paymentMethod,
          child: Text(PaymentMethodUtilities.titleForPaymentMethod(
              context, paymentMethod))));
    });

    return paymentMethodsList;
  }

  _addTitle(String title) {
    return Container(
      child: Text(
        title,
        style: TextHelper.customTextStyle(null, red, FontWeight.bold, 16),
      ),
    );
  }
}
