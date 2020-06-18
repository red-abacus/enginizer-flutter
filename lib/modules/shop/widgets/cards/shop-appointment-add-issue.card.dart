import 'package:app/generated/l10n.dart';
import 'package:app/modules/shop/models/shop-appointment-issue.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopAppointmentAddIssueCard extends StatelessWidget {
  Function addNewIssue;
  final ShopAppointmentIssue issue;

  ShopAppointmentAddIssueCard({this.addNewIssue, this.issue});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: gray, width: 1),
          borderRadius: new BorderRadius.all(
            const Radius.circular(6.0),
          )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                onSubmitted: (val) {
                  issue.name = val;
                },
                minLines: 1,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: S.of(context).appointment_create_issues,
                    hintStyle:
                        TextHelper.customTextStyle(color: gray)),
                showCursor: false,
                onChanged: (val) {
                  issue.name = val;
                },
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _addIssue(),
            child: Container(
              width: 40,
              height: 32,
              decoration: BoxDecoration(
                color: red,
                borderRadius: new BorderRadius.only(
                    topRight: Radius.circular(6.0),
                    bottomRight: Radius.circular(6.0)),
              ),
              child: Icon(Icons.add, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  _addIssue() {
    addNewIssue(issue);
  }
}
