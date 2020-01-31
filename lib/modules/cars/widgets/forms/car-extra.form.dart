import 'package:enginizer_flutter/generated/i18n.dart';
import 'package:enginizer_flutter/modules/cars/providers/cars-make.provider.dart';
import 'package:enginizer_flutter/modules/shared/widgets/datepicker.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                  carMakeProvider.carExtraFormState['activeKm'] = value;
                },
                initialValue: carMakeProvider.carExtraFormState['activeKm'],
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
                carMakeProvider.carExtraFormState['rcaExpiryDate'] = value;
                print(carMakeProvider.carExtraFormState);
              },
            ),
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
                carMakeProvider.carExtraFormState['itpExpiryDate'] = value;
                print(carMakeProvider.carExtraFormState);
              },
            ),
          ],
        ),
      ),
    );
  }

  valid() {
    return _formKey.currentState.validate();
  }
}
