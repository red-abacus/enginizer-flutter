class CarVariant {
  int id;
  String name;

  CarVariant({this.id, this.name});

  factory CarVariant.fromJson(Map<String, dynamic> json) {
    return CarVariant(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
