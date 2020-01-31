class CarTransmission {
  int id;
  String name;

  CarTransmission({this.id = -1, this.name = ''});

  factory CarTransmission.fromJson(Map<String, dynamic> json) {
    return CarTransmission(id: json['id'], name: json['name']);
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
