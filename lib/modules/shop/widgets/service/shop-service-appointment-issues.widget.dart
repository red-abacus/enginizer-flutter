import 'package:app/modules/shop/cards/shop-appointment-add-issue.card.dart';
import 'package:app/modules/shop/cards/shop-appointment-issue.card.dart';
import 'package:app/modules/shop/models/shop-appointment-issue.model.dart';
import 'package:flutter/cupertino.dart';

class ShopServiceAppointmentIssuesWidget extends StatefulWidget {
  Function addNewIssue;
  final List<ShopAppointmentIssue> issues;

  ShopServiceAppointmentIssuesWidget({this.issues, this.addNewIssue});

  @override
  _ShopServiceAppointmentIssuesWidgetState createState() =>
      _ShopServiceAppointmentIssuesWidgetState();
}

class _ShopServiceAppointmentIssuesWidgetState
    extends State<ShopServiceAppointmentIssuesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _listContainer(),
        ],
      ),
    );
  }

  _listContainer() {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, index) {
          return index < widget.issues.length - 1
              ? ShopAppointmentIssueCard(
                  issue: widget.issues[index], index: index)
              : ShopAppointmentAddIssueCard(addNewIssue: widget.addNewIssue, issue: widget.issues[index]);
        },
        itemCount: widget.issues.length,
      ),
    );
  }
}
