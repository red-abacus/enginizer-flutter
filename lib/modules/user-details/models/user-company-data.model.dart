class UserCompanyData {
  String cui;
  String fiscalName;
  String registrationNo;
  String address;
  String contactPerson;

  UserCompanyData(
      {this.cui,
      this.fiscalName,
      this.registrationNo,
      this.address,
      this.contactPerson});

  factory UserCompanyData.fromJson(Map<String, dynamic> json) {
    return UserCompanyData(
        cui: json['cui'] != null ? json['cui'] : '',
        fiscalName: json['fiscalName'] != null ? json['fiscalName'] : '',
        registrationNo: json['registrationNumber'] != null
            ? json['registrationNumber']
            : '',
        address: json['address'] != null ? json['address'] : '',
        contactPerson:
            json['contactPerson'] != null ? json['contactPerson'] : '');
  }

  Map<String, dynamic> toJson() => {
    'cui': this.cui,
    'fiscalName': this.fiscalName,
    'registrationNumber': this.registrationNo,
    'address': this.address,
    'contactPerson': this.contactPerson
  };
}
