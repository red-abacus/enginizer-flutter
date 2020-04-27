import 'package:app/generated/l10n.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom-show-dialog.widget.dart';

class AlertConfirmationDialogWidget extends StatelessWidget {
  final Function confirmFunction;
  final String title;

  AlertConfirmationDialogWidget({this.title, this.confirmFunction});

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        width: 260.0,
        height: 200.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(2.0)),
        ),
        child: new Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextHelper.customTextStyle(
                    null, gray3, FontWeight.bold, 16),
              ),
              margin: EdgeInsets.only(top: 20),
            ),
            Align(
                alignment: FractionalOffset.bottomLeft,
                child: FlatButton(
                  child: new Text(
                    S.of(context).general_no.toUpperCase(),
                    style: TextHelper.customTextStyle(
                        null, gray3, FontWeight.bold, 16.0),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    confirmFunction(false);
                  },
                )
            ),
            Align(
                alignment: FractionalOffset.bottomRight,
                child: FlatButton(
                  child: new Text(
                    S.of(context).general_yes.toUpperCase(),
                    style: TextHelper.customTextStyle(
                        null, red, FontWeight.bold, 16.0),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    confirmFunction(true);
                  },
                )
            )
          ],
        ),
      ),
    );
  }
}