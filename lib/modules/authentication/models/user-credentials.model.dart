class UserCredentials {
  int id;
  String email;
  int roleId;
  int providerId;
  String userType;
  bool active;

  UserCredentials({this.id,
    this.email,
    this.roleId,
    this.providerId,
    this.userType,
    this.active});


  factory UserCredentials.fromJson(Map<String, dynamic> json) {
    return UserCredentials(
      id: json["id"] != null ? json["id"] : 0,
      email: json["email"] != null ? json["email"] : "",
      roleId: json["roleId"] != null ? json["roleId"] : 0,
      providerId: json["providerId"] != null ? json["providerId"] : 0,
      userType: json["userType"] != null ? json["userType"] : "",
      active: json["active"] != null ? json["active"] : false
    );
  }

}