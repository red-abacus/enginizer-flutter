import 'dart:io';

class CarDocument {
  String name;
  File file;
  String fileType;

  CarDocument(this.file, this.name) {
    String extension = this.file.path.split('.').last;

    if (extension == 'jpg' || extension == 'jpeg') {
      fileType = 'image';
    } else if (extension == 'pdf') {
      fileType = 'application/pdf';
    } else if (extension == 'doc') {
      fileType = 'application/msword';
    } else if (extension == 'png') {
      fileType = 'image/png';
    }
  }
}
