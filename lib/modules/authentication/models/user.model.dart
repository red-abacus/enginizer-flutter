class User {
  int uid;
  String name;
  String email;
  dynamic role;

  User({this.uid, this.name, this.email, this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        uid: json["id"] != null ? json["id"] : 0,
        name: json["name"] != null ? json["name"] : "",
        email: json["email"] != null ? json["email"] : "",
        role: json["role"] != null ? json["role"] : "");
  }
}
