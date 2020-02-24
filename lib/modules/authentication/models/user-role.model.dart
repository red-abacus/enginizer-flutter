class UserRole {
  int id;
  String name;

  UserRole({this.id, this.name});

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(id: json['id'], name: json['name']);
  }
}
