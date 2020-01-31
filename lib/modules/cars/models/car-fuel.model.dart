class CarFuelType {
  int id;
  String name;

  CarFuelType({this.id = -1, this.name = ''});

  factory CarFuelType.fromJson(Map<String, dynamic> json) {
    return CarFuelType(id: json['id'], name: json['name']);
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
