import 'item-type.model.dart';

class ProviderItem {
  int id;
  ItemType itemType;
  String code;
  String name;
  double price;
  double priceVAT;

  ProviderItem(
      {this.id,
      this.itemType,
      this.code,
      this.name,
      this.price,
      this.priceVAT});

  factory ProviderItem.fromJson(Map<String, dynamic> json) {
    return ProviderItem(
        id: json['id'],
        itemType: json['itemType'] != null
            ? ItemType.fromJson(json['itemType'])
            : null,
        code: json['code'],
        name: json['name'],
        price: json['price'],
        priceVAT: json['priceVAT']);
  }
}
