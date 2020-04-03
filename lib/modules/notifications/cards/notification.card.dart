import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.only(bottom: 10, top: 10, left: 20, right: 20),
        child: Text(
          'Test notification text!',
          style: TextHelper.customTextStyle(
              null, gray, FontWeight.normal, 14),
        ),
      );
    });
  }
}
