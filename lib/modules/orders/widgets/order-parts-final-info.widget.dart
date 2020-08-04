import 'package:app/generated/l10n.dart';
import 'package:app/modules/shared/widgets/custom-show-dialog.widget.dart';
import 'package:app/modules/shared/widgets/datepicker.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderPartsFinalInfo extends StatelessWidget {
  final Function infoAdded;

  DateTime time;

  final GlobalKey<FormState> _formKey = GlobalKey();

  OrderPartsFinalInfo({this.infoAdded});

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        width: 260.0,
        height: 160.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
        ),
        child: Form(
          key: _formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                S.of(context).parts_delivery_button_title,
                style:
                    TextHelper.customTextStyle(color: red, weight: FontWeight.bold, size: 20),
              ),
              BasicDateTimeField(
                labelText: S.of(context).orders_date_delivery_estimator,
                validator: (value) {
                  if (value == null) {
                    return S.of(context).orders_date_delivery_estimator;
                  } else {
                    return null;
                  }
                },
                onChange: (value) {
                  time = value;
                },
              ),
              new Container(
                height: 50,
                margin: EdgeInsets.only(top: 20),
                decoration: new BoxDecoration(
                  color: red,
                ),
                child: FlatButton(
                  child: new Text(
                    S.of(context).general_send,
                    style: TextHelper.customTextStyle(
                        color: Colors.white, weight: FontWeight.bold, size: 18.0),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    _save(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _save(BuildContext context) {
    if (_formKey.currentState.validate()) {
      infoAdded(time);
      Navigator.pop(context);
    }
  }
}
