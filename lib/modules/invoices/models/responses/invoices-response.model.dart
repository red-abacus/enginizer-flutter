import 'package:app/modules/invoices/models/invoice.model.dart';

class InvoicesResponse {
  int total;
  int totalPages;
  List<Invoice> items;

  InvoicesResponse({this.total, this.totalPages, this.items});

  factory InvoicesResponse.fromJson(Map<String, dynamic> json) {
    return InvoicesResponse(
        total: json['total'],
        totalPages: json['totalPages'],
        items: _mapInvoices(json['items']));
  }

  static _mapInvoices(List<dynamic> response) {
    List<Invoice> list = [];
    response.forEach((item) {
      list.add(Invoice.fromJson(item));
    });
    return list;
  }
}
