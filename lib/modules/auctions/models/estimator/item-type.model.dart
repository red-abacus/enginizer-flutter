class ItemType {
  int id;
  String name;

  ItemType({this.id, this.name});

  factory ItemType.fromJson(Map<String, dynamic> json) {
    return ItemType(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
