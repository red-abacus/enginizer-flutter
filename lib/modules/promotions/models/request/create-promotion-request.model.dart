import 'dart:io';

import 'package:app/modules/appointments/enum/payment-method.enum.dart';
import 'package:app/modules/appointments/enum/tank-quantity.enum.dart';
import 'package:app/modules/appointments/model/generic-model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/promotions/models/promotion.model.dart';
import 'package:app/utils/date_utils.dart';
import 'package:pie_chart/pie_chart.dart';

class CreatePromotionRequest {
  final int maxFiles = 5;

  final int providerId;
  int promotionId;
  int serviceId;

  String title = '';
  String description = '';
  DateTime startDate;
  DateTime endDate;
  int discount = 0;
  double price;
  ServiceProviderItem serviceProviderItem;
  ServiceProviderItem presetServiceProviderItem;
  bool isActive = true;
  List<GenericModel> images;
  Car car;

  final Promotion promotion;

  CreatePromotionRequest(this.providerId,
      {this.promotion, this.car, this.presetServiceProviderItem}) {
    if (promotion != null) {
      promotionId = promotion.id;
      title = promotion.title;
      description = promotion.description;
      startDate = promotion.startDate;
      endDate = promotion.endDate;
      discount = int.parse(promotion.discount.toStringAsFixed(0));
      price = promotion.price;
      serviceId = promotion.serviceId;
      isActive = promotion.isActive;
      images = promotion.images;
    }

    checkAddImage();
  }

  List<File> files = [];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'description': description,
      'discount': discount,
      'endDate': DateUtils.stringFromDate(endDate, 'dd/MM/yyyy'),
      'startDate': DateUtils.stringFromDate(startDate, 'dd/MM/yyyy'),
      'title': title,
      'price': price,
      'isActive': isActive
    };

    if (serviceProviderItem != null) {
      propMap['serviceId'] = serviceProviderItem.id;
    } else if (presetServiceProviderItem != null) {
      propMap['serviceId'] = presetServiceProviderItem.id;
    }

    if (promotionId != null) {
      propMap['id'] = promotionId;
    }

    if (this.car != null) {
      propMap['carId'] = this.car.id;
    }

    if (this.providerId != null) {
      propMap['providerId'] = this.providerId;
    }

    return propMap;
  }

  List<File> getImages() {
    List<File> list = [];
    files.forEach((file) {
      if (file != null) {
        list.add(file);
      }
    });
    return list;
  }

  checkAddImage() {
    int total = 0;

    if (images != null) {
      total += images.length;
    }

    if (files != null) {
      total += files.length;
    }

    if (total >= maxFiles) {
      if (files.length > 0 && files.last == null) {
        files.removeLast();
      }
    } else {
      if (files.length == 0) {
        files.add(null);
      } else if (files.length > 0 && files.last != null) {
        files.add(null);
      }
    }
  }

  hasSellerService() {
    return this.serviceProviderItem != null && this.serviceProviderItem.isSellerService();
  }
}
