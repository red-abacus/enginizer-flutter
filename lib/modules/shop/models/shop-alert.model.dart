import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car-model.model.dart';

class ShopAlert {
  int id;
  CarBrand brand;
  CarModel carModel;
  int startMileage;
  int endMileage;
  int startPrice;
  int endPrice;
  int startYear;
  int endYear;

  ShopAlert(
      {this.id,
      this.brand,
      this.carModel,
      this.startMileage,
      this.endMileage,
      this.startPrice,
      this.endPrice,
      this.startYear,
      this.endYear});

  factory ShopAlert.fromJson(Map<String, dynamic> json) {
    return ShopAlert(
        id: json['id'] != null ? json['id'] : '',
        brand: json['brand'] != null ? CarBrand.fromJson(json['brand']) : null,
        carModel:
            json['model'] != null ? CarModel.fromJson(json['model']) : null,
        startMileage: json['startMileage'] != null ? json['startMileage'] : 0,
        endMileage: json['endMileage'] != null ? json['endMileage'] : 0,
        startPrice: json['startPrice'] != null ? json['startPrice'] : 0,
        endPrice: json['endPrice'] != null ? json['endPrice'] : 0,
        startYear: json['startYear'] != null ? json['startYear'] : 0,
        endYear: json['endYear'] != null ? json['endYear'] : 0);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    if (id != null) {
      map['id'] = id;
    }

    if (brand != null) {
      map['brand'] = brand.toJson();
    }

    if (carModel != null) {
      map['model'] = carModel.toJson();
    }

    if (startMileage != null) {
      map['startMileage'] = startMileage;
    }

    if (startMileage != null) {
      map['endMileage'] = endMileage;
    }

    if (startPrice != null) {
      map['startPrice'] = startPrice;
    }

    if (endPrice != null) {
      map['endPrice'] = endPrice;
    }

    if (startYear != null) {
      map['startYear'] = startYear;
    }

    if (endYear != null) {
      map['endYear'] = endYear;
    }

    return map;
  }
}
