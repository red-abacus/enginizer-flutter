import 'package:app/modules/invoices/enums/invoice-status.enum.dart';
import 'package:app/modules/invoices/models/invoice-client.model.dart';
import 'package:app/modules/invoices/models/invoice-company.model.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';

class InvoiceDetails {
  InvoiceClient client;
  String dueDate;
  int id;
  String issueDate;
  List<IssueItem> items;
  int number;
  InvoiceCompany provider;
  String series;
  InvoiceStatus status;

  InvoiceDetails(
      {this.client,
      this.dueDate,
      this.id,
      this.issueDate,
      this.items,
      this.number,
      this.provider,
      this.series,
      this.status});

  factory InvoiceDetails.fromJson(Map<String, dynamic> json) {
    return InvoiceDetails(
        client: json['client'] != null
            ? InvoiceClient.fromJson(json['client'])
            : null,
        dueDate: json['dueDate'] != null ? json['dueDate'] : null,
        id: json['id'] != null ? json['id'] : '',
        issueDate: json['issueDate'] != null ? json['issueDate'] : null,
        items: json['items'] != null ? _mapIssueItem(json['items']) : [],
        number: json['number'] != null ? json['number'] : 0,
        provider:
            json['provider'] != null ? InvoiceCompany.fromJson(json['provider']) : null,
        series: json['series'] != null ? json['series'] : '',
        status: json['status'] != null
            ? InvoiceStatusUtils.status(json['status'])
            : '');
  }

  static _mapIssueItem(List<dynamic> items) {
    List<IssueItem> list = [];
    items.forEach((item) {
      list.add(IssueItem.fromJson(item));
    });
    return list;
  }

  double totalServices() {
    double total = 0.0;

    for(IssueItem item in this.items) {
      if (!item.type.isProduct()) {
        total += item.getTotalPrice();
      }
    }

    return total;
  }

  double totalProducts() {
    double total = 0.0;

    for(IssueItem item in this.items) {
      if (item.type.isProduct()) {
        total += item.getTotalPrice();
      }
    }

    return total;
  }
}
