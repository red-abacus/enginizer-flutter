import 'package:app/modules/cars/models/recommendations/car-intervention-product.model.dart';

class CarIntervention {
  String name;
  List<CarInterventionProduct> products;

  CarIntervention({this.name = '', this.products});

  factory CarIntervention.fromJson(Map<String, dynamic> json) {
    return CarIntervention(
        name: json['name'] != null ? json['name'] : '',
        products: _mapProducts(json['products']));
  }

  static _mapProducts(List<dynamic> response) {
    List<CarInterventionProduct> products = [];
    response.forEach((product) {
      products.add(CarInterventionProduct.fromJson(product));
    });
    return products;
  }
}
