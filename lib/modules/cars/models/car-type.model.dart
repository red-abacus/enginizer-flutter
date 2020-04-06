class CarType {
  int id;
  String name;

  CarType({this.id = -1, this.name = ''});

  factory CarType.fromJson(Map<String, dynamic> json) {
    return CarType(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  bool operator ==(other) {
    return id == other.id;
  }
}
