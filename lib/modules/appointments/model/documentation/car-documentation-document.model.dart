class CarDocumentationDocument {
  String id;
  String description;
  String value;

  CarDocumentationDocument({this.id, this.description, this.value});

  factory CarDocumentationDocument.fromJson(Map<String, dynamic> json) {
    return CarDocumentationDocument(
        id: json['id'],
        description: json['description'],
        value: json['value'] != null ? json['value'] : '');
  }
}
