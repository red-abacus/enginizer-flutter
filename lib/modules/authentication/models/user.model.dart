class User {
  int uid;
  String name;
  String email;
  dynamic role;
  String phoneNumber;
  String homeAddress;
  String profilePhotoUrl;

  User(
      {this.uid, this.name, this.email, this.role, this.phoneNumber, this.homeAddress, this.profilePhotoUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        uid: json["id"] != null ? json["id"] : 0,
        name: json["name"] != null ? json["name"] : "",
        email: json["email"] != null ? json["email"] : "",
        role: json["role"] != null ? json["role"] : "",
        phoneNumber: json['phoneNo'] != null ? json['phoneNo'] : null,
        homeAddress: json['homeAddress'] != null ? json['homeAddress'] : null,
        profilePhotoUrl: json['profilePhotoUrl'] != null ? json['profilePhotoUrl'] : null);
    }
}
