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
  int guarantee;
  double addition;

  ProviderItem(
      {this.id,
      this.type,
      this.typeId,
      this.code,
      this.name,
      this.quantity,
      this.price,
      this.priceVAT,
      this.total,
      this.guarantee,
      this.addition});

  factory ProviderItem.fromJson(Map<String, dynamic> json) {
    return ProviderItem(
        id: json['id'],
        type: json['type'] != null ? ItemType.fromJson(json['type']) : null,
        typeId: json['typeId'],
        code: json['code'],
        name: json['name'],
        quantity: json['quantity'],
        price: json['price'],
        priceVAT: json['priceVAT'],
        total: json['total'],
        guarantee: json['guarantee'] != null ? json['guarantee'] : 0,
        addition: json['addition'] != null ? json['addition'] : 0);
  }
}
