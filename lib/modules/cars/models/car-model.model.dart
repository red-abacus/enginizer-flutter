class CarModel {
  int id;
  String name;

  CarModel({this.id = -1, this.name = ''});

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(id: json['id'], name: json['name']);
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
