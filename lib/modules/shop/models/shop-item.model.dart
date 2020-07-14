import 'package:app/modules/appointments/model/generic-model.dart';
import 'package:app/modules/auctions/models/estimator/item-type.model.dart';
import 'package:app/modules/authentication/models/user.model.dart';
import 'package:app/modules/shop/enums/shop-appointment-type.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/utils/date_utils.dart';

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
  GenericModel service;

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
      this.createdBy,
      this.service});

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
        id: json['id'] != null ? json['id'] : '',
        title: json['title'] != null ? json['title'] : '',
        description: json['description'] != null ? json['description'] : '',
        price: json['price'] != null ? json['price'] : 0,
        discount: json['discount'] != null ? json['discount'] : 0,
        startDate: json['startDate'] != null ? json['startDate'] : '',
        endDate: json['endDate'] != null ? json['endDate'] : '',
        providerId: json['providerId'] != null ? json['providerId'] : null,
        carId: json['carId'] != null ? json['carId'] : 0,
        user: json['user'] != null ? User.fromJson(json['user']) : null,
        type: json['type'] != null ? json['type'] : '',
        currency: json['currency'] != null ? json['currency'] : '',
        images: json['images'] != null ? _mapImages(json['images']) : [],
        createdBy: json['createdBy'] != null ? json['createdBy'] : 0,
        service: json['service'] != null
            ? GenericModel.fromJson(json['service'])
            : null);
  }

  static _mapImages(List<dynamic> response) {
    List<GenericModel> models = [];
    response.forEach((element) {
      models.add(GenericModel.imageFromJson(element));
    });
    return models;
  }

  String getDateTitle() {
    DateTime startDate = DateUtils.dateFromString(this.startDate, 'dd/MM/yyyy');
    DateTime endDate = DateUtils.dateFromString(this.endDate, 'dd/MM/yyyy');

    String title = '';

    if (startDate != null) {
      title = DateUtils.stringFromDate(startDate, 'dd MMMM');
    }

    if (endDate != null) {
      if (title.isEmpty) {
        title = DateUtils.stringFromDate(endDate, 'dd MMMM');
      } else {
        title = '$title - ${DateUtils.stringFromDate(endDate, 'dd MMMM')}';
      }
    }

    return title;
  }

  ShopAppointmentType getShopAppointmentType() {
    if (service != null) {
      return service.getShopAppointmentType();
    }
  }

  _getPrice() {
    return this.price - this.discount / 100 * this.price;
  }

  IssueItem getIssueItem(ItemType type) {
    return IssueItem(
        type: type,
        code: 'PROMO${this.id}',
        name: this.title,
        quantity: 1,
        price: _getPrice(),
        priceVAT: 0,
        addition: 0);
  }

  DateTime getStartDate() {
    return DateUtils.dateFromString(startDate, 'dd/MM/yyyy');
  }

  DateTime getEndDate() {
    return DateUtils.dateFromString(endDate, 'dd/MM/yyyy');
  }
}
