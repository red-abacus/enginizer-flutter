import 'package:enginizer_flutter/modules/shared/widgets/estimator/models/issue-item-type.model.dart';

class IssueItem {
  int id;
  IssueItemType type;
  String code;
  String name;
  int quantity;
  int price;
  int priceNoVAT;

  IssueItem(
      {this.id,
      this.type,
      this.code,
      this.name,
      this.quantity,
      this.price,
      this.priceNoVAT});

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
        priceNoVAT: json['priceNoVAT']);
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'type': type?.name,
        'code': code,
        'quantity': quantity.toString(),
        'priceNoVAT': priceNoVAT.toString(),
        'priceVAT': price.toString(),
      };
}
