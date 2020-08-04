import 'package:app/modules/shop/enums/shop-appointment-type.enum.dart';

class GenericModel {
  int id;
  String name;
  String profilePhoto;
  String fileName;
  String value;

  GenericModel(
      {this.id, this.name, this.profilePhoto, this.fileName, this.value});

  factory GenericModel.fromJson(Map<String, dynamic> json) {
    return GenericModel(
        id: json['id'],
        name: json['name'],
        profilePhoto:
            json['profilePhotoUrl'] != null ? json['profilePhotoUrl'] : '',
        fileName: json['fileName'] != null ? json['fileName'] : '',
        value: json['value'] != null ? json['value'] : null);
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
      case 'TOW_SERVICE':
      case 'PICKUP_RETURN':
        return ShopAppointmentType.Location;
      case 'RCA_SERVICE':
        return ShopAppointmentType.Rca;
    }

    return null;
  }

  bool isRentService() {
    return name == 'RENT_SERVICE';
  }
}
