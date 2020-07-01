import 'package:app/generated/l10n.dart';
import 'package:app/modules/invoices/models/invoice-details.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InvoiceDetailsProvider extends StatelessWidget {
  final InvoiceDetails invoiceDetails;

  InvoiceDetailsProvider({this.invoiceDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  '1',
                  textAlign: TextAlign.center,
                  style: TextHelper.customTextStyle(
                      color: Colors.white, size: 16, weight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 4),
              child: Text(
                S.of(context).invoice_provider_info,
                style: TextHelper.customTextStyle(
                    color: gray3, weight: FontWeight.bold, size: 16),
              ),
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
                      S.of(context).invoice_cui_title, invoiceDetails.provider?.cui ?? ''),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: _infoWidget(S.of(context).invoice_fiscal_name_title,
                      invoiceDetails.provider?.fiscalName ?? ''),
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
                  child: _infoWidget(S.of(context).invoice_address_title,
                      invoiceDetails.provider?.address ?? '-'),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: _infoWidget(
                      S.of(context).invoice_contact_name_title, invoiceDetails.provider?.contactPerson ?? ''),
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
                  child: _infoWidget(S.of(context).invoice_iban_title,
                      invoiceDetails.provider?.iban ?? ''),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: _infoWidget(
                      S.of(context).invoice_bank_name, invoiceDetails.provider?.bankName ?? ''),
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
          shape: Shape.line,
          linePosition: LinePosition.bottom,
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
