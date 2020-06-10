import 'package:app/modules/appointments/model/generic-model.dart';
import 'package:app/modules/promotions/enum/promotion-status.enum.dart';
import 'package:app/utils/date_utils.dart';

class Promotion {
  int id;
  String title;
  String description;
  double price;
  double discount;
  DateTime startDate;
  DateTime endDate;
  List<GenericModel> images;
  int serviceId;
  bool isActive;
  String status;

  Promotion(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.discount,
      this.startDate,
      this.endDate,
      this.images,
      this.serviceId,
      this.isActive,
      this.status});

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
        id: json['id'],
        title: json['title'] != null ? json['title'] : '',
        description: json['description'] != null ? json["description"] : '',
        price: json['price'] != null ? json['price'] : 0.0,
        discount: json['discount'] != null ? json['discount'] : 0.0,
        startDate: json['startDate'] != null
            ? DateUtils.dateFromString(json['startDate'], 'dd/MM/yyyy')
            : null,
        endDate: json['endDate'] != null
            ? DateUtils.dateFromString(json['endDate'], 'dd/MM/yyyy')
            : null,
        serviceId: json['serviceId'] != null ? json['serviceId'] : null,
        isActive: json['isActive'] != null ? json['isActive'] : false,
        status: json['status'] != null ? json["status"] : '',
        images: json['images'] != null ? _mapImages(json['images']) : []);
  }

  static _mapImages(List<dynamic> response) {
    List<GenericModel> images = [];
    response.forEach((item) {
      images.add(GenericModel.imageFromJson(item));
    });
    return images;
  }

  getStatus() {
    return PromotionStatusUtils.fromString(this.status);
  }
}
