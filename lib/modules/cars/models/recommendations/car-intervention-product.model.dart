class CarInterventionProduct {
  int id;
  String name;

  CarInterventionProduct({this.id = -1, this.name = ''});

  factory CarInterventionProduct.fromJson(Map<String, dynamic> json) {
    return CarInterventionProduct(id: json['id'], name: json['name']);
  }
}
