import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/providers/cars-make.provider.dart';
import 'package:app/modules/shared/widgets/datepicker.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CarExtraForm extends StatefulWidget {
  CarExtraForm({Key key}) : super(key: key);

  @override
  CarExtraFormState createState() => CarExtraFormState();
}

class CarExtraFormState extends State<CarExtraForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var carMakeProvider = Provider.of<CarsMakeProvider>(context);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // CAR REGISTRATION NUMBER
            TextFormField(
                decoration: InputDecoration(
                    labelText: S.of(context).cars_create_registrationNumber),
                onChanged: (value) {
                  setState(() {
                    carMakeProvider.carExtraFormState['registrationNumber'] =
                        value;
                  });
                },
                initialValue:
                    carMakeProvider.carExtraFormState['registrationNumber'],
                validator: (value) {
                  if (value.isEmpty) {
                    return S
                        .of(context)
                        .cars_create_error_RegistrationNumberEmpty;
                  } else {
                    return null;
                  }
                }),
            // CAR MILEAGE
            TextFormField(
                decoration: InputDecoration(
                    labelText: S.of(context).cars_create_mileage),
                onChanged: (value) {
                  carMakeProvider.carExtraFormState['mileage'] = value;
                },
                initialValue: carMakeProvider.carExtraFormState['mileage'],
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return S.of(context).cars_create_error_MileageEmpty;
                  } else {
                    return null;
                  }
                }),
            // CAR RCA Date
            _rcaContainer(carMakeProvider),
            _itpContainer(carMakeProvider),
          ],
        ),
      ),
    );
  }

  _rcaContainer(CarsMakeProvider carsMakeProvider) {
    return Column(
      children: <Widget>[
        BasicDateField(
          labelText: S.of(context).cars_create_rcaExpiryDate,
          validator: (value) {
            if (value == null) {
              return S.of(context).cars_create_error_RCAExpiryEmpty;
            } else {
              return null;
            }
          },
          onChange: (value) {
            carsMakeProvider.carExtraFormState['rcaExpiryDate'] = value;

            if (value == null) {
              carsMakeProvider.carExtraFormState['rcaExpiryDateNotification'] =
                  false;
            }

            setState(() {});
          },
        ),
        _rcaNotificationContainer(carsMakeProvider),
      ],
    );
  }

  _rcaNotificationContainer(CarsMakeProvider carsMakeProvider) {
    var color = carsMakeProvider.carExtraFormState['rcaExpiryDateNotification']
        ? red
        : Colors.black;

    var imageSource =
        carsMakeProvider.carExtraFormState['rcaExpiryDateNotification']
            ? 'assets/images/icons/bell_fill.svg'
            : 'assets/images/icons/bell.svg';

    return carsMakeProvider.carExtraFormState['rcaExpiryDate'] != null
        ? InkWell(
            onTap: () {
              setState(() {
                carsMakeProvider
                        .carExtraFormState['rcaExpiryDateNotification'] =
                    !carsMakeProvider
                        .carExtraFormState['rcaExpiryDateNotification'];
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              child: Row(
                children: <Widget>[
                  Text(
                    S.of(context).cars_create_rca_expiry_date_notification,
                    style: TextHelper.customTextStyle(
                        null, color, FontWeight.bold, 14),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 4),
                    width: 20,
                    height: 20,
                    child: SvgPicture.asset(imageSource,
                        color: color, semanticsLabel: 'Bell Icon'),
                  )
                ],
              ),
            ),
          )
        : Container();
  }

  _itpContainer(CarsMakeProvider carsMakeProvider) {
    return Column(
      children: <Widget>[
        BasicDateField(
          labelText: S.of(context).cars_create_itpExpiryDate,
          validator: (value) {
            if (value == null) {
              return S.of(context).cars_create_error_ITPExpiryEmpty;
            } else {
              return null;
            }
          },
          onChange: (value) {
            setState(() {
              carsMakeProvider.carExtraFormState['itpExpiryDate'] = value;

              if (value == null) {
                carsMakeProvider
                    .carExtraFormState['itpExpiryDateNotification'] = false;
              }
            });
          },
        ),
        _itpNotificationContainer(carsMakeProvider),
      ],
    );
  }

  _itpNotificationContainer(CarsMakeProvider carsMakeProvider) {
    var color = carsMakeProvider.carExtraFormState['itpExpiryDateNotification']
        ? red
        : Colors.black;
    var imageSource =
        carsMakeProvider.carExtraFormState['itpExpiryDateNotification']
            ? 'assets/images/icons/bell_fill.svg'
            : 'assets/images/icons/bell.svg';

    return carsMakeProvider.carExtraFormState['itpExpiryDate'] != null
        ? InkWell(
            onTap: () {
              setState(() {
                carsMakeProvider
                        .carExtraFormState['itpExpiryDateNotification'] =
                    !carsMakeProvider
                        .carExtraFormState['itpExpiryDateNotification'];
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              child: Row(
                children: <Widget>[
                  Text(
                    S.of(context).cars_create_itp_expiry_date_notification,
                    style: TextHelper.customTextStyle(
                        null, color, FontWeight.bold, 14),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 4),
                    width: 20,
                    height: 20,
                    child: SvgPicture.asset(imageSource,
                        color: color, semanticsLabel: 'Bell Icon'),
                  )
                ],
              ),
            ),
          )
        : Container();
  }

  valid() {
    return _formKey.currentState.validate();
  }
}
