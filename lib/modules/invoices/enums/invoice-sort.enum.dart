import 'package:app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

class InvoiceSortUtils {
  static String value(InvoiceSort invoiceStatus) {
    switch (invoiceStatus) {
      case InvoiceSort.Number:
        return 'number';
      case InvoiceSort.IssueDate:
        return 'issueDate';
      case InvoiceSort.DueDate:
        return 'dueDate';
        break;
    }
  }

  static String title(BuildContext context, InvoiceSort invoiceSort) {
    switch (invoiceSort) {
      case InvoiceSort.Number:
        return S.of(context).invoice_sort_number;
      case InvoiceSort.IssueDate:
        return S.of(context).invoice_issue_date;
      case InvoiceSort.DueDate:
        return S.of(context).invoice_due_date;
    }
  }

  static List<InvoiceSort> list() {
    return [InvoiceSort.Number, InvoiceSort.IssueDate, InvoiceSort.DueDate];
  }
}

enum InvoiceSort { Number, IssueDate, DueDate }
