import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentDocumentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              'Deviz Initial',
              style: TextHelper.customTextStyle(null, gray3, null, 14),
            ),
          ),
          Container(
            child: Icon(
              Icons.picture_as_pdf,
              color: gray,
            ),
          ),
        ],
      ),
    );
  }
}
