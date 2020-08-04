import 'package:app/modules/invoices/enums/invoice-status.enum.dart';

class Invoice {
  int id;
  String code;
  String issueDate;
  String dueDate;
  InvoiceStatus status;

  Invoice({this.id, this.code, this.issueDate, this.dueDate, this.status});

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
        id: json['id'],
        code: json['code'] != null ? json['code'] : '',
        issueDate: json['issueDate'] != null ? json['issueDate'] : '',
        dueDate: json['dueDate'] != null ? json['dueDate'] : '',
        status: json['status'] != null
            ? InvoiceStatusUtils.status(json['status'])
            : null);
  }
}
