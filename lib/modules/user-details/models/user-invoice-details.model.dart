import 'package:app/modules/user-details/models/user-company-data.model.dart';
import 'package:app/modules/user-details/models/user-personal-data.model.dart';

class UserInvoiceDetails {
  UserPersonalData userPersonalData;
  UserCompanyData userCompanyData;

  UserInvoiceDetails({this.userPersonalData, this.userCompanyData});

  factory UserInvoiceDetails.fromJson(Map<String, dynamic> json) {
    return UserInvoiceDetails(
        userPersonalData: json['userPersonalData'] != null
            ? UserPersonalData.fromJson(json['userPersonalData'])
            : null,
        userCompanyData: json['userCompanyData'] != null
            ? UserCompanyData.fromJson(json['userCompanyData'])
            : null);
  }
}
