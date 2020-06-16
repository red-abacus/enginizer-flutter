import 'dart:io';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/providers/cars-make.provider.dart';
import 'package:app/modules/shared/managers/permissions/permissions-car.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:app/modules/shared/widgets/datepicker.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:file_picker/file_picker.dart';
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

  CarsMakeProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<CarsMakeProvider>(context);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _registrationNumberContainer(),
            _mileageContainer(),
            _rcaContainer(),
            _itpContainer(),
            if (PermissionsManager.getInstance().hasAccess(
                MainPermissions.Cars, PermissionsCar.CREATE_CAR_EXTRA))
              _exhaustContainer(),
            if (PermissionsManager.getInstance().hasAccess(
                MainPermissions.Cars, PermissionsCar.CREATE_CAR_EXTRA))
              _diagnosisContainer(),
            if (PermissionsManager.getInstance().hasAccess(
                MainPermissions.Cars, PermissionsCar.CREATE_CAR_EXTRA))
              _generalVerificationContainer()
          ],
        ),
      ),
    );
  }

  _registrationNumberContainer() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: S.of(context).cars_create_registrationNumber),
      onChanged: (value) {
        setState(() {
          _provider.carExtraFormState['registrationNumber'] = value;
        });
      },
      initialValue: _provider.carExtraFormState['registrationNumber'],
      validator: (value) {
        if (value.isEmpty) {
          return S.of(context).cars_create_error_RegistrationNumberEmpty;
        } else {
          return null;
        }
      },
    );
  }

  _mileageContainer() {
    return TextFormField(
      decoration: InputDecoration(labelText: S.of(context).cars_create_mileage),
      onChanged: (value) {
        _provider.carExtraFormState['mileage'] = value;
      },
      initialValue: _provider.carExtraFormState['mileage'],
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
      },
    );
  }

  _rcaContainer() {
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
            _provider.carExtraFormState['rcaExpiryDate'] = value;

            if (value == null) {
              _provider.carExtraFormState['rcaExpiryDateNotification'] = false;
            }

            setState(() {});
          },
        ),
        _rcaNotificationContainer(),
      ],
    );
  }

  _rcaNotificationContainer() {
    var color = _provider.carExtraFormState['rcaExpiryDateNotification']
        ? red
        : Colors.black;

    var imageSource = _provider.carExtraFormState['rcaExpiryDateNotification']
        ? 'assets/images/icons/bell_fill.svg'
        : 'assets/images/icons/bell.svg';

    return _provider.carExtraFormState['rcaExpiryDate'] != null
        ? InkWell(
            onTap: () {
              setState(() {
                _provider.carExtraFormState['rcaExpiryDateNotification'] =
                    !_provider.carExtraFormState['rcaExpiryDateNotification'];
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

  _itpContainer() {
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
              _provider.carExtraFormState['itpExpiryDate'] = value;

              if (value == null) {
                _provider.carExtraFormState['itpExpiryDateNotification'] =
                    false;
              }
            });
          },
        ),
        _itpNotificationContainer(),
      ],
    );
  }

  _itpNotificationContainer() {
    var color = _provider.carExtraFormState['itpExpiryDateNotification']
        ? red
        : Colors.black;
    var imageSource = _provider.carExtraFormState['itpExpiryDateNotification']
        ? 'assets/images/icons/bell_fill.svg'
        : 'assets/images/icons/bell.svg';

    return _provider.carExtraFormState['itpExpiryDate'] != null
        ? InkWell(
            onTap: () {
              setState(() {
                _provider.carExtraFormState['itpExpiryDateNotification'] =
                    !_provider.carExtraFormState['itpExpiryDateNotification'];
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

  _exhaustContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () async {
          File file = await FilePicker.getFile(
            type: FileType.custom,
            allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
          );

          setState(() {
            _provider.carExtraFormState['exhaust'] = file;
          });
        },
        child: Row(
          children: [
            Icon(
              Icons.attach_file,
              color:
                  _provider.carExtraFormState['exhaust'] == null ? gray2 : red,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  S.of(context).car_create_exhaust_test,
                  style: TextHelper.customTextStyle(null, _provider.carExtraFormState['exhaust'] != null ? red : gray2, null, 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _diagnosisContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () async {
          File file = await FilePicker.getFile(
            type: FileType.custom,
            allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
          );

          setState(() {
            _provider.carExtraFormState['diagnosisProtocol'] = file;
          });
        },
        child: Row(
          children: [
            Icon(
              Icons.attach_file,
              color: _provider.carExtraFormState['diagnosisProtocol'] == null
                  ? gray2
                  : red,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                S.of(context).car_create_diagnosis_protocol,
                style: TextHelper.customTextStyle(null, _provider.carExtraFormState['diagnosisProtocol'] != null ? red : gray2, null, 16),
              ),
            )
          ],
        ),
      ),
    );
  }

  _generalVerificationContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () async {
          File file = await FilePicker.getFile(
            type: FileType.custom,
            allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
          );

          setState(() {
            _provider.carExtraFormState['generalVerification'] = file;
          });
        },
        child: Row(
          children: [
            Icon(
              Icons.attach_file,
              color: _provider.carExtraFormState['generalVerification'] == null
                  ? gray2
                  : red,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                S.of(context).car_create_general_car_verification,
                style: TextHelper.customTextStyle(null, _provider.carExtraFormState['generalVerification'] != null ? red : gray2, null, 16),
              ),
            )
          ],
        ),
      ),
    );
  }

  valid() {
    return _formKey.currentState.validate();
  }
}
