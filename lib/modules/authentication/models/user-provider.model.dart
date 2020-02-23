class UserProvider {
  int id;
  String name;

  UserProvider({this.id, this.name});

  factory UserProvider.fromJson(Map<String, dynamic> json) {
    return UserProvider(id: json['id'], name: json['name']);
  }
}
