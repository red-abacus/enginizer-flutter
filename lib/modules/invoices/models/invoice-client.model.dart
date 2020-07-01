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
import 'package:app/modules/invoices/models/invoice-company.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/string.utils.dart';
import 'package:intl/intl.dart';

import 'invoice-individual-data.model.dart';

class InvoiceClient {
  int id;
  String clientType;
  InvoiceCompany invoiceCompany;
  InvoiceIndividualData invoiceIndividualData;

  InvoiceClient(
      {this.id,
      this.clientType,
      this.invoiceCompany,
      this.invoiceIndividualData});

  factory InvoiceClient.fromJson(Map<String, dynamic> json) {
    return InvoiceClient(
        id: json['clientId'] != null ? json['clientId'] : 0,
        invoiceCompany: json['companyInvoiceData'] != null
            ? InvoiceCompany.fromJson(json['companyInvoiceData'])
            : null,
        clientType: json['clientType'] != null ? json['clientType'] : '',
        invoiceIndividualData: json['individualInvoiceData'] != null
            ? InvoiceIndividualData.fromJson(json['individualInvoiceData'])
            : null);
  }
}
