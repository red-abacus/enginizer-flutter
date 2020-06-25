import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/shop/models/shop-item.model.dart';

class ShopItemResponse {
  int total;
  int totalPages;
  List<ShopItem> items;

  ShopItemResponse({this.total, this.totalPages, this.items});

  factory ShopItemResponse.fromJson(Map<String, dynamic> json) {
    return ShopItemResponse(
        total: json['total'],
        totalPages: json['totalPages'],
        items: _mapShopItems(json['items']));
  }

  static _mapShopItems(List<dynamic> response) {
    List<ShopItem> list = [];
    response.forEach((item) {
      list.add(ShopItem.fromJson(item));
    });
    return list;
  }
}
