import 'issue-item-type.model.dart';

class IssueItem {
  int id;
  IssueItemType type;
  String code;
  String name;
  int quantity;
  double price;
  double priceVAT;

  IssueItem(
      {this.id,
      this.type,
      this.code,
      this.name,
      this.quantity,
      this.price,
      this.priceVAT});

  factory IssueItem.fromJson(Map<String, dynamic> json) {
    return IssueItem(
        id: json['id'],
        type: json['type'] != null
            ? IssueItemType.fromJson(json['type'])
            : null,
        code: json['code'],
        name: json['name'],
        quantity: json['quantity'],
        price: json['price'],
        priceVAT: json['priceVAT']);
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'type': type?.name,
        'code': code,
        'quantity': quantity.toString(),
        'priceNoVAT': (price - priceVAT).toString(),
        'priceVAT': price.toString(),
      };
}
