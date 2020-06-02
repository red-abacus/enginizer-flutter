import 'package:app/generated/l10n.dart';
import 'package:app/modules/shared/widgets/alert-warning-dialog.dart';
import 'package:app/modules/shared/widgets/custom-show-dialog.widget.dart';
import 'package:app/modules/shared/widgets/custom-text-form-field.dart';
import 'package:app/modules/shared/widgets/datepicker.widget.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuctionMapDeclineWidget extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        width: 260.0,
        height: 220.0,
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
                S.of(context).auction_map_decline_title,
                style:
                TextHelper.customTextStyle(null, red, FontWeight.bold, 20),
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                onChanged: (value) {
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
                        null, Colors.white, FontWeight.bold, 18.0),
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
      Navigator.pop(context);
    }
  }
}
