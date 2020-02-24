class ItemType {
  int id;
  String name;

  ItemType({this.id, this.name});

  factory ItemType.fromJson(Map<String, dynamic> json) {
    return ItemType(id: json['id'], name: json['name']);
  }
}
