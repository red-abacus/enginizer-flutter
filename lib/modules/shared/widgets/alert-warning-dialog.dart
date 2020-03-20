import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertWarningDialog {
  static Future showAlertDialog(
      BuildContext context, String title, String subtitle) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title,
              style:
                  TextHelper.customTextStyle(null, null, FontWeight.bold, 16)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  subtitle,
                  style: TextHelper.customTextStyle(null, null, null, 16),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(S.of(context).general_ok),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
