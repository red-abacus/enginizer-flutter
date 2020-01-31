class CarCylinderCapacity {
  int id;
  String name;

  CarCylinderCapacity({this.id = -1, this.name = ''});

  factory CarCylinderCapacity.fromJson(Map<String, dynamic> json) {
    return CarCylinderCapacity(id: json['id'], name: json['name']);
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
