import 'package:app/modules/appointments/model/generic-model.dart';
import 'package:app/modules/authentication/models/user.model.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car-model.model.dart';

class ShopItem {
  int id;
  String title;
  String description;
  double price;
  double discount;
  String startDate;
  String endDate;
  int providerId;
  int carId;
  User user;
  String type;
  String currency;
  List<GenericModel> images;
  int createdBy;

  ShopItem(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.discount,
      this.startDate,
      this.endDate,
      this.providerId,
      this.carId,
      this.user,
      this.type,
      this.currency,
      this.images,
      this.createdBy});

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
        id: json['id'] != null ? json['id'] : '',
        title: json['title'] != null ? json['title'] : '',
        description: json['description'] != null ? json['description'] : '',
        price: json['price'] != null ? json['price'] : 0,
        discount: json['discount'] != null ? json['discount'] : 0,
        startDate: json['startDate'] != null ? json['startDate'] : '',
        endDate: json['endDate'] != null ? json['endDate'] : '',
        providerId: json['providerId'] != null ? json['providerId'] : 0,
        carId: json['carId'] != null ? json['carId'] : 0,
        user: json['user'] != null ? User.fromJson(json['user']) : null,
        type: json['type'] != null ? json['type'] : '',
        currency: json['currency'] != null ? json['currency'] : '',
        images: json['images'] != null ? _mapImages(json['images']) : [],
        createdBy: json['createdBy'] != null ? json['createdBy'] : 0);
  }

  static _mapImages(List<dynamic> response) {
    List<GenericModel> models = [];
    response.forEach((element) {
      models.add(GenericModel.imageFromJson(element));
    });
    return models;
  }
}
