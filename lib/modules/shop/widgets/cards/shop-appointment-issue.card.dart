import 'package:app/modules/shop/models/shop-appointment-issue.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopAppointmentIssueCard extends StatelessWidget {
  final ShopAppointmentIssue issue;
  final int index;

  ShopAppointmentIssueCard({this.issue, this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 24,
            height: 24,
            decoration: new BoxDecoration(
              color: gray3,
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '${index + 1}',
                textAlign: TextAlign.center,
                style: TextHelper.customTextStyle(color: Colors.white, size: 12),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(issue.name,
                style: TextHelper.customTextStyle(color: gray3),),
            ),
          )
        ],
      ),
    );
  }
}
