class UserPersonalData {
  String cnp;
  String address;

  UserPersonalData({this.cnp, this.address});

  factory UserPersonalData.fromJson(Map<String, dynamic> json) {
    return UserPersonalData(
        cnp: json['cnp'] != null ? json['cnp'] : '',
        address: json['ciAddress'] != null ? json['ciAddress'] : '');
  }

  Map<String, dynamic> toJson() => {'cnp': this.cnp, 'address': this.address};
}
