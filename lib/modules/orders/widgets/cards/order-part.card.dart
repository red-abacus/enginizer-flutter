import 'package:app/generated/l10n.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/modules/work-estimate-form/widgets/import/work-estimate-issue-details.widget.dart';
import 'package:app/utils/date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:app/utils/constants.dart' as Constants;

import '../order-part-details.widget.dart';

class OrderPartCard extends StatelessWidget {
  final IssueItem issueItem;

  OrderPartCard({this.issueItem});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Constants.gray_80,
              offset: Offset(1.0, 1.0),
              blurRadius: 1.0,
            ),
          ],
        ),
        child: Container(
          child: Material(
            color: Colors.white,
            child: ClipRRect(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _imageContainer(),
                  _textContainer(context),
                  _statusContainer(context),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  _imageContainer() {
    return Container(
      width: 60,
      height: 60,
      margin: EdgeInsets.only(left: 4),
      padding: EdgeInsets.all(1),
      child: Image.network(
        'https://images.homedepot-static.com/productImages/464241a7-ee44-4ddf-b2f9-a6054982a938/svn/wagner-brake-brake-parts-bd126055e-64_1000.jpg',
        fit: BoxFit.fitHeight,
      ),
    );
  }

  _textContainer(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 10),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('${issueItem.name} (${issueItem.code})',
                      style: TextStyle(
                          color: Colors.black87,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          height: 1.5)),
                  Text(
                      '${S.of(context).general_price}: ${(issueItem.price + issueItem.priceVAT).toString()}',
                      style: TextStyle(
                          color: Constants.red,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _statusContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () => {
          showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return OrderPartDetails(
                    issueItem: issueItem);
              })
        },
        child: Icon(
          Icons.info,
          color: Constants.red,
        ),
      ),
    );
  }
}
