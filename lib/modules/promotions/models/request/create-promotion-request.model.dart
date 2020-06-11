import 'dart:io';

import 'package:app/modules/appointments/enum/payment-method.enum.dart';
import 'package:app/modules/appointments/enum/tank-quantity.enum.dart';
import 'package:app/modules/appointments/model/generic-model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
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
  bool isActive = true;
  List<GenericModel> images;

  final Promotion promotion;

  CreatePromotionRequest(this.providerId, {this.promotion}) {
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
      'serviceId': serviceProviderItem.id,
      'startDate': DateUtils.stringFromDate(startDate, 'dd/MM/yyyy'),
      'title': title,
      'price': price,
      'isActive': isActive
    };

    if (promotionId != null) {
      propMap['id'] = promotionId;
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
      }
      else if (files.length > 0 && files.last != null) {
        files.add(null);
      }
    }
  }
}