class InvoiceIndividualData {
  int billingUserId;
  String ciAddress;
  String cnp;
  String email;
  String homeAddress;
  String name;
  String phoneNumber;

  InvoiceIndividualData(
      {this.billingUserId,
      this.ciAddress,
      this.cnp,
      this.email,
      this.homeAddress,
      this.name,
      this.phoneNumber});

  factory InvoiceIndividualData.fromJson(Map<String, dynamic> json) {
    return InvoiceIndividualData(
        billingUserId:
            json['billingUserId'] != null ? json['billingUserId'] : null,
        ciAddress: json['ciAddress'] != null ? json['ciAddress'] : '',
        cnp: json['cnp'] != null ? json['cnp'] : '',
        email: json['email'] != null ? json['email'] : '',
        homeAddress: json['homeAddress'] != null ? json['homeAddress'] : '',
        name: json['name'] != null ? json['name'] : '',
        phoneNumber: json['phoneNo'] != null ? json['phoneNo'] : '');
  }
}
