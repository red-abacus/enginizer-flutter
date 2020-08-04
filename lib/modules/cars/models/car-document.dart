import 'dart:io';

class CarDocument {
  int id;
  String fileName;
  String name;
  File file;
  String fileType;

  CarDocument(this.file, this.name) {
    String extension = this.file.path.split('.').last;

    if (extension == 'jpg' || extension == 'jpeg') {
      fileType = 'image';
    } else if (extension == 'pdf') {
      fileType = 'pdf';
    } else if (extension == 'doc') {
      fileType = 'application/msword';
    } else if (extension == 'png') {
      fileType = 'image/png';
    }
  }

  CarDocument.fromDocument({this.id, this.fileName, this.name});

  factory CarDocument.fromJson(Map<String, dynamic> json) {
    return CarDocument.fromDocument(
        id: json['id'],
        fileName: json['fileName'] != null ? json['fileName'] : '',
        name: json['name'] != null ? json['name'] : '');
  }

  String getExtension() {
    return fileName.split('.').last;
  }
}
