class CarYear {
  int id;
  String name;

  CarYear({this.id = -1, this.name = ''});

  factory CarYear.fromJson(Map<String, dynamic> json) {
    return CarYear(id: json['id'], name: json['name']);
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
