import 'package:enginizer_flutter/modules/auctions/models/estimator/item-type.model.dart';

class IssueItem {
  int id;
  ItemType type;
  int typeId;
  String code;
  String name;
  int quantity;
  double price;
  double priceVAT;
  int issueId;

  IssueItem(
      {this.id,
      this.type,
      this.typeId,
      this.code,
      this.name,
      this.quantity,
      this.price,
      this.priceVAT});

  factory IssueItem.fromJson(Map<String, dynamic> json) {
    return IssueItem(
        id: json['id'],
        type: json['type'] != null
            ? ItemType.fromJson(json['type'])
            : null,
        typeId: json['typeId'],
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

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'id': id != null ? id : 0,
      'typeId': type?.id,
      'code': code,
      'name': name,
      'quantity': quantity,
      'price': price,
      'priceVAT': priceVAT,
      'total': (price + priceVAT).toString()
    };

    return propMap;
  }
}
