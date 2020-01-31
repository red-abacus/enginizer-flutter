class CarBrand {
  int id;
  String name;

  CarBrand({this.id = -1, this.name = ''});

  factory CarBrand.fromJson(Map<String, dynamic> json) {
    return CarBrand(id: json['id'], name: json['name']);
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
