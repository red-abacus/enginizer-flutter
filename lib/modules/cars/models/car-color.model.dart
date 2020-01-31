class CarColor {
  int id;
  String name;

  CarColor({this.id = -1, this.name = ''});

  factory CarColor.fromJson(Map<String, dynamic> json) {
    return CarColor(id: json['id'], name: json['name']);
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
