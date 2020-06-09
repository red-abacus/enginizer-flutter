class GenericModel {
  int id;
  String name;
  String profilePhoto;

  GenericModel({this.id, this.name, this.profilePhoto});

  factory GenericModel.fromJson(Map<String, dynamic> json) {
    return GenericModel(
        id: json['id'],
        name: json['name'],
        profilePhoto:
            json['profilePhotoUrl'] != null ? json['profilePhotoUrl'] : '');
  }
}
