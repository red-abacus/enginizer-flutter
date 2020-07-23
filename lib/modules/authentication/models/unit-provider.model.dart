import 'package:app/modules/authentication/models/provider-address.model.dart';

class UnitProvider {
  int id;
  String name;
  String description;
  String fiscalName;
  String registrationNumber;
  String cui;
  String contactPerson;
  String invoiceSeries;
  int invoiceNumber;
  String address;
  String profilePhotoUrl;
  ProviderAddress providerAddress;

  UnitProvider(
      {this.id,
      this.name,
      this.description,
      this.fiscalName,
      this.registrationNumber,
      this.cui,
      this.contactPerson,
      this.invoiceSeries,
      this.invoiceNumber,
      this.address,
      this.profilePhotoUrl,
      this.providerAddress});

  factory UnitProvider.fromJson(Map<String, dynamic> json) {
    return UnitProvider(
        id: json['id'],
        name: json['name'] != null ? json['name'] : '',
        description: json['description'] != null ? json['description'] : '',
        fiscalName: json['fiscalName'] != null ? json['fiscalName'] : '',
        registrationNumber: json['registrationNumber'] != null
            ? json['registrationNumber']
            : '',
        cui: json['cui'] != null ? json['cui'] : '',
        contactPerson:
            json['contactPerson'] != null ? json['contactPerson'] : '',
        invoiceSeries:
            json['invoiceSeries'] != null ? json['invoiceSeries'] : '',
        invoiceNumber:
            json['invoiceNumber'] != null ? json['invoiceNumber'] : null,
        address: json['address'] != null ? json['address'] : '',
        profilePhotoUrl:
            json['profilePhotoUrl'] != null ? json['profilePhotoUrl'] : '',
        providerAddress: json['unitAddress'] != null
            ? ProviderAddress.fromJson(json['unitAddress'])
            : ProviderAddress.fromJson(Map()));
  }
}
