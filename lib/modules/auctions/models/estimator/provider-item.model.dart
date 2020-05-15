import 'item-type.model.dart';

class ProviderItem {
  int id;
  ItemType type;
  int typeId;
  String code;
  String name;
  int quantity;
  double price;
  double priceVAT;
  int issueId;
  double total;

  ProviderItem({this.id,
    this.type,
    this.typeId,
    this.code,
    this.name,
    this.quantity,
    this.price,
    this.priceVAT,
    this.total});

  factory ProviderItem.fromJson(Map<String, dynamic> json) {
    print('provider item ${json['id']}');
    return ProviderItem(
        id: json['id'],
        type: json['type'] != null ? ItemType.fromJson(json['type']) : null,
        typeId: json['typeId'],
        code: json['code'],
        name: json['name'],
        quantity: json['quantity'],
        price: json['price'],
        priceVAT: json['priceVAT'],
        total: json['total']);
  }
}
