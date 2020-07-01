import 'package:app/generated/l10n.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';

class InvoiceStatusUtils {
  static InvoiceStatus status(String status) {
    switch (status) {
      case 'PAID':
        return InvoiceStatus.Paid;
      case 'ISSUED':
        return InvoiceStatus.Issued;
    }
  }

  static String value(InvoiceStatus invoiceStatus) {
    switch (invoiceStatus) {
      case InvoiceStatus.Issued:
        return 'ISSUED';
      case InvoiceStatus.Paid:
        return 'PAID';
        break;
    }
  }

  static String title(BuildContext context, InvoiceStatus invoiceStatus) {
    switch (invoiceStatus) {
      case InvoiceStatus.Issued:
        return S.of(context).invoice_type_issued;
      case InvoiceStatus.Paid:
        return S.of(context).invoice_type_paid;
        break;
    }
  }

  static Color color(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.Issued:
        return yellow2;
        break;
      case InvoiceStatus.Paid:
        return green2;
        break;
    }
  }
}

enum InvoiceStatus { Issued, Paid }
