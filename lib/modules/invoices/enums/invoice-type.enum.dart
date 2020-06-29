import 'package:app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

class InvoiceTypeUtils {
  static String value(InvoiceType invoiceType) {
    switch (invoiceType) {
      case InvoiceType.In:
        return 'IN';
      case InvoiceType.Out:
        return 'OUT';
    }
  }

  static String title(BuildContext context, InvoiceType invoiceType) {
    switch (invoiceType) {
      case InvoiceType.In:
        return S.of(context).invoice_type_in;
      case InvoiceType.Out:
        return S.of(context).invoice_type_out;
    }
  }

  static List<InvoiceType> list() {
    return [InvoiceType.In, InvoiceType.Out];
  }
}

enum InvoiceType { In, Out }
