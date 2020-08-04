import 'package:app/modules/promotions/models/promotion.model.dart';

class PromotionsResponse {
  int total;
  int totalPages;
  List<Promotion> items;

  PromotionsResponse({this.total, this.totalPages, this.items});

  factory PromotionsResponse.fromJson(Map<String, dynamic> json) {
    return PromotionsResponse(
        total: json['total'],
        totalPages: json['totalPages'],
        items: _mapPromotions(json['items']));
  }

  static _mapPromotions(List<dynamic> response) {
    List<Promotion> list = [];
    response.forEach((item) {
      list.add(Promotion.fromJson(item));
    });
    return list;
  }
}
