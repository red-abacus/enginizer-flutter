import 'package:app/modules/appointments/model/documentation/car-documentation-document.model.dart';

class CarDocumentationTopic {
  String id;
  String description;
  String value;

  CarDocumentationDocument document;

  CarDocumentationTopic({this.id, this.description, this.value});

  factory CarDocumentationTopic.fromJson(Map<String, dynamic> json) {
    return CarDocumentationTopic(
        id: json['id'],
        description: json['description'],
        value: json['value'] != null ? json['value'] : '');
  }
}
