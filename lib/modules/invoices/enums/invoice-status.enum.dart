import 'package:app/modules/invoices/enums/invoice-sort.enum.dart';

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
}

enum InvoiceStatus { Issued, Paid }
