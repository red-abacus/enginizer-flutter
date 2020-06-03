class GenericModel {
  int id;
  String name;

  GenericModel({this.id, this.name});

  factory GenericModel.fromJson(Map<String, dynamic> json) {
    return GenericModel(id: json['id'], name: json['name']);
  }
}
