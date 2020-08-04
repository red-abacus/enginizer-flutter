class CarPower {
  int id;
  String name;

  CarPower({this.id = -1, this.name = ''});

  factory CarPower.fromJson(Map<String, dynamic> json) {
    return CarPower(id: json['id'], name: json['name']);
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
