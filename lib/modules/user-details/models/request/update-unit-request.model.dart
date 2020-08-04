import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/authentication/models/provider-address.model.dart';

class UpdateUnitRequest {
  String description = '';
  String name = '';
  String fiscalName = '';
  String billingAddress = '';
  String contactPerson = '';
  String cui = '';
  String registrationNumber = '';
  String invoiceSerie = '';
  int invoiceNumber;
  String address;
  int providerId;
  ProviderAddress providerAddress;

  UpdateUnitRequest(
      {this.providerId,
      this.description,
      this.name,
      this.fiscalName,
      this.billingAddress,
      this.contactPerson,
      this.cui,
      this.registrationNumber,
      this.invoiceSerie,
      this.invoiceNumber,
      this.address,
      this.providerAddress});

  factory UpdateUnitRequest.fromUserDetails(ServiceProvider serviceProvider) {
    return UpdateUnitRequest(
        providerId: serviceProvider?.id ?? 0,
        description: serviceProvider?.description ?? '',
        name: serviceProvider?.name ?? '',
        fiscalName: serviceProvider?.fiscalName ?? '',
        billingAddress: serviceProvider?.address ?? '',
        contactPerson: serviceProvider?.contactPerson ?? '',
        cui: serviceProvider?.cui ?? '',
        registrationNumber: serviceProvider?.registrationNumber ?? '',
        invoiceSerie: serviceProvider?.invoiceSeries ?? '',
        invoiceNumber: serviceProvider?.invoiceNumber ?? 0,
        address: serviceProvider?.address,
        providerAddress: serviceProvider?.providerAddress);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'description': this.description ?? '',
      'fiscalName': this.fiscalName ?? '',
      'registrationNumber': this.registrationNumber ?? '',
      'cui': this.cui ?? '',
      'contactPerson': this.contactPerson ?? '',
      'invoiceSeries': this.invoiceSerie ?? '',
      'address': this.billingAddress ?? '',
      'unitAddress': this.providerAddress?.toJson() ?? Map()
    };

    if (this.invoiceNumber != null) {
      propMap['invoiceNumber'] = this.invoiceNumber.toString();
    }

    return propMap;
  }
}
