import 'package:app/modules/shop/enums/shop-appointment-type.enum.dart';

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

  factory GenericModel.imageFromJson(Map<String, dynamic> json) {
    return GenericModel(id: json['id'], name: json['imageUrl']);
  }

  ShopAppointmentType getShopAppointmentType() {
    switch (name) {
      case 'CAR_WASHING':
      case 'PAINT_SHOP':
      case 'SERVICE':
      case 'ITP_SERVICE':
        return ShopAppointmentType.Simple;
        // TODO - need to check appointment for this
      case 'TOW_SERVICE':
      case 'PICKUP_RETURN':
        return ShopAppointmentType.Location;
    // TODO - need to check appointment for this
      case 'RENT_SERVICE':
        return ShopAppointmentType.CarRent;
    // TODO - need to check appointment for this
      case 'RCA_SERVICE':
        return ShopAppointmentType.Rca;
    }

    return null;
  }
}
