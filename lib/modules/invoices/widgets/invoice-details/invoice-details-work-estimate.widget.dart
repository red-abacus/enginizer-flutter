import 'package:app/generated/l10n.dart';
import 'package:app/modules/invoices/widgets/cards/invoice-issue.card.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InvoiceDetailsWorkEstimate extends StatelessWidget {
  final List<IssueItem> items;

  InvoiceDetailsWorkEstimate({this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: new BoxDecoration(
                color: darkGray,
                borderRadius: BorderRadius.all(
                  Radius.circular(13),
                ),
              ),
              child: Center(
                child: Text(
                  '3',
                  textAlign: TextAlign.center,
                  style: TextHelper.customTextStyle(
                      color: Colors.white, size: 16, weight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 4),
              child: Text(
                S.of(context).invoice_work_estimate,
                style: TextHelper.customTextStyle(
                    color: gray3, weight: FontWeight.bold, size: 16),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: this.items.length,
            itemBuilder: (context, index) {
              return InvoiceIssueCard(
                  issueItem: this.items[index]);
            },
          ),
        ),
      ],
    );
  }
}
