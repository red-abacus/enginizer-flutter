import 'package:app/modules/authentication/models/unit-provider.model.dart';
import 'package:app/modules/authentication/models/user-role.model.dart';
import 'package:app/modules/user-details/enums/invoice-type.enum.dart';
import 'package:app/modules/user-details/models/user-invoice-details.model.dart';

class JwtUserDetails {
  int id;
  String name;
  String email;
  UserRole userRole;
  UnitProvider userProvider;
  String phoneNumber;
  String userType;
  bool active;
  String profilePhotoUrl;
  String homeAddress;
  InvoiceType invoiceType;
  UserInvoiceDetails userInvoiceDetails;

  JwtUserDetails(
      {this.id,
      this.name,
      this.email,
      this.userRole,
      this.userProvider,
      this.phoneNumber,
      this.userType,
      this.active,
      this.profilePhotoUrl,
      this.homeAddress,
      this.invoiceType,
      this.userInvoiceDetails});

  factory JwtUserDetails.fromJson(Map<String, dynamic> json) {
    return JwtUserDetails(
        id: json['id'],
        name: json['name'] != null ? json['name'] : "",
        email: json['email'] != null ? json['email'] : "",
        userRole: json['role'] != null ? UserRole.fromJson(json['role']) : null,
        userProvider: json['provider'] != null
            ? UnitProvider.fromJson(json['provider'])
            : null,
        phoneNumber: json['phoneNo'] != null ? json['phoneNo'] : "",
        userType: json['userType'] != null ? json['userType'] : "",
        active: json['active'] != null ? json['active'] : false,
        profilePhotoUrl:
            json['profilePhotoUrl'] != null ? json['profilePhotoUrl'] : '',
        homeAddress: json['homeAddress'] != null ? json['homeAddress'] : '',
        invoiceType: json['invoiceType'] != null
            ? InvoiceTypeUtils.invoiceType(json['invoiceType'])
            : null,
        userInvoiceDetails: json['invoiceDetails'] != null
            ? UserInvoiceDetails.fromJson(json['invoiceDetails'])
            : null);
  }
}
