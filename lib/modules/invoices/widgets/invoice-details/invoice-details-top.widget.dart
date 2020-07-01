import 'package:app/generated/l10n.dart';
import 'package:app/modules/invoices/enums/invoice-status.enum.dart';
import 'package:app/modules/invoices/models/invoice-details.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';

class InvoiceDetailsTop extends StatelessWidget {
  final InvoiceDetails invoiceDetails;

  InvoiceDetailsTop({this.invoiceDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).general_invoice,
              style: TextHelper.customTextStyle(
                  color: gray3, weight: FontWeight.bold, size: 20),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).general_status,
                  style: TextHelper.customTextStyle(
                      weight: FontWeight.bold, size: 16, color: gray2),
                ),
                Text(
                  InvoiceStatusUtils.title(context, invoiceDetails.status),
                  style: TextHelper.customTextStyle(
                      weight: FontWeight.normal,
                      size: 16,
                      color: InvoiceStatusUtils.color(invoiceDetails.status)),
                ),
              ],
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: _infoWidget(
                      S.of(context).invoice_serie_title, invoiceDetails.series),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: _infoWidget(
                      S.of(context).invoice_number_title, invoiceDetails.number.toString()),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: _infoWidget(
                      S.of(context).invoice_issue_date, invoiceDetails.issueDate),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: _infoWidget(
                      S.of(context).invoice_due_date, invoiceDetails.dueDate),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  _infoWidget(String title, String body) {
    return Container(
      padding: EdgeInsets.only(bottom: 4),
      decoration: DottedDecoration(
          shape: Shape.line, linePosition: LinePosition.bottom,
       color: gray_80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextHelper.customTextStyle(
                weight: FontWeight.bold, size: 14, color: gray2),
          ),
          Container(
            margin: EdgeInsets.only(top: 4),
            child: Text(
              body,
              style: TextHelper.customTextStyle(
                  weight: FontWeight.normal, size: 16, color: gray3),
            ),
          ),
        ],
      ),
    );
  }
}
