import 'package:app/generated/l10n.dart';
import 'package:app/modules/invoices/enums/invoice-status.enum.dart';
import 'package:app/modules/invoices/models/invoice.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:app/utils/constants.dart' as Constants;

class InvoiceCard extends StatelessWidget {
  final Invoice invoice;
  final Function selectInvoice;

  InvoiceCard({this.invoice, this.selectInvoice});

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
            child: InkWell(
              splashColor: Theme.of(context).primaryColor,
              onTap: () => this.selectInvoice(this.invoice),
              child: ClipRRect(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _textContainer(context),
                    _statusContainer(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  _textContainer(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        margin: EdgeInsets.only(left: 10),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text('${invoice.code}',
                      style: TextStyle(
                          color: Colors.black87,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          height: 1.5)),
                ),
                if (this.invoice.issueDate.isNotEmpty)
                  _issueDateContainer(context),
                if (this.invoice.dueDate.isNotEmpty) _dueDateContainer(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _issueDateContainer(BuildContext context) {
    return Row(
      children: [
        Text(
          '${S.of(context).invoice_issue_date}:',
          style: TextHelper.customTextStyle(size: 12, color: gray2),
        ),
        Text(
          ' ${this.invoice.issueDate}',
          style: TextHelper.customTextStyle(
              size: 12, color: gray3, weight: FontWeight.bold),
        ),
      ],
    );
  }

  _dueDateContainer(BuildContext context) {
    return Row(
      children: [
        Text(
          '${S.of(context).invoice_due_date}:',
          style: TextHelper.customTextStyle(size: 12, color: gray2),
        ),
        Text(
          ' ${this.invoice.dueDate}',
          style: TextHelper.customTextStyle(
              size: 12, color: gray3, weight: FontWeight.bold),
        ),
      ],
    );
  }

  _statusContainer(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 10),
        child: Text(
          InvoiceStatusUtils.value(this.invoice.status).toUpperCase(),
          textAlign: TextAlign.right,
          style: TextHelper.customTextStyle(
              color: this.invoice.getStatusColor(),
              weight: FontWeight.bold,
              size: 12),
        ),
      ),
    );
  }
}
