import 'package:app/modules/cars/enums/car-status.enum.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car-color.model.dart';
import 'package:app/modules/cars/models/car-cylinder-capacity.model.dart';
import 'package:app/modules/cars/models/car-fuel.model.dart';
import 'package:app/modules/cars/models/car-model.model.dart';
import 'package:app/modules/cars/models/car-power.model.dart';
import 'package:app/modules/cars/models/car-transmissions.model.dart';
import 'package:app/modules/cars/models/car-year.model.dart';
import 'package:app/modules/invoices/enums/invoice-status.enum.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/string.utils.dart';
import 'package:intl/intl.dart';

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
