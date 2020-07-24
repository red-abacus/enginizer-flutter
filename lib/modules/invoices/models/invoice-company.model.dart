import 'package:app/modules/cars/enums/car-status.enum.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car-color.model.dart';
import 'package:app/modules/cars/models/car-cylinder-capacity.model.dart';
import 'package:app/modules/cars/models/fuel/car-fuel.model.dart';
import 'package:app/modules/cars/models/car-model.model.dart';
import 'package:app/modules/cars/models/car-power.model.dart';
import 'package:app/modules/cars/models/car-transmissions.model.dart';
import 'package:app/modules/cars/models/car-year.model.dart';
import 'package:app/modules/invoices/enums/invoice-status.enum.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/string.utils.dart';
import 'package:intl/intl.dart';

class InvoiceCompany {
  String address;
  String bankName;
  int billingUserId;
  String contactPerson;
  String cui;
  String fiscalName;
  String iban;
  bool isVatPayer;
  String registrationNumber;

  InvoiceCompany(
      {this.address,
      this.bankName,
      this.billingUserId,
      this.contactPerson,
      this.cui,
      this.fiscalName,
      this.iban,
      this.isVatPayer,
      this.registrationNumber});

  factory InvoiceCompany.fromJson(Map<String, dynamic> json) {
    return InvoiceCompany(
        address: json['address'] != null ? json['address'] : '',
        bankName: json['bankName'] != null ? json['bankName'] : '',
        billingUserId:
            json['billingUserId'] != null ? json['billingUserId'] : '',
        contactPerson:
            json['contactPerson'] != null ? json['contactPerson'] : '',
        cui: json['cui'] != null ? json['cui'] : '',
        fiscalName: json['fiscalName'] != null ? json['fiscalName'] : '',
        iban: json['iban'] != null ? json['iban'] : '',
        isVatPayer: json['isVATPayer'] != null ? json['isVATPayer'] : null,
        registrationNumber: json['registrationNumber'] != null
            ? json['registrationNumber']
            : '');
  }
}
