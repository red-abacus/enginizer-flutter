class GenericModel {
  int id;
  String name;
  String profilePhoto;
  String fileName;

  GenericModel({this.id, this.name, this.profilePhoto, this.fileName});

  factory GenericModel.fromJson(Map<String, dynamic> json) {
    return GenericModel(
        id: json['id'],
        name: json['name'],
        profilePhoto:
            json['profilePhotoUrl'] != null ? json['profilePhotoUrl'] : '',
        fileName: json['fileName'] != null ? json['fileName'] : '');
  }

  factory GenericModel.imageFromJson(Map<String, dynamic> json) {
    return GenericModel(id: json['id'], name: json['imageUrl']);
  }
}
