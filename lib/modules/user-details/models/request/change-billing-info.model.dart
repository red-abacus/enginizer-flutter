import 'package:app/modules/authentication/models/jwt-user-details.model.dart';
import 'package:app/modules/user-details/enums/invoice-type.enum.dart';
import 'package:app/modules/user-details/models/user-company-data.model.dart';

import '../user-personal-data.model.dart';

class ChangeBillingInfoRequest {
  InvoiceType invoiceType;
  UserCompanyData userCompanyData;
  UserPersonalData userPersonalData;

  int userId;

  ChangeBillingInfoRequest(
      {this.invoiceType,
      this.userCompanyData,
      this.userPersonalData,
      this.userId});

  factory ChangeBillingInfoRequest.fromUserDetails(JwtUserDetails userDetails) {
    return ChangeBillingInfoRequest(
        userId: userDetails.id,
        invoiceType: userDetails.invoiceType,
        userCompanyData: userDetails.userInvoiceDetails?.userCompanyData,
        userPersonalData: userDetails.userInvoiceDetails?.userPersonalData);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {};

    if (this.invoiceType != null) {
      Map<String, dynamic> billingInfo = Map();

      if (this.invoiceType == InvoiceType.Individual) {
        billingInfo['userPersonalData'] = this.userPersonalData?.toJson() ?? '';
      }
      else {
        billingInfo['userCompanyData'] = this.userCompanyData?.toJson() ?? '';
      }
      propMap['invoiceDetails'] = billingInfo;

      propMap['invoiceType'] = InvoiceTypeUtils.value(this.invoiceType);
    }

    return propMap;
  }
}
