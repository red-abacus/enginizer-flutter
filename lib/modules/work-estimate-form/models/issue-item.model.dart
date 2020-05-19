import 'package:app/modules/auctions/models/estimator/item-type.model.dart';

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
  double total;

  IssueItem(
      {this.id,
      this.type,
      this.typeId,
      this.code,
      this.name,
      this.quantity,
      this.price,
      this.priceVAT,
      this.total});

  factory IssueItem.fromJson(Map<String, dynamic> json) {
    return IssueItem(
        id: json['id'],
        type: json['type'] != null ? ItemType.fromJson(json['type']) : null,
        typeId: json['typeId'],
        code: json['code'],
        name: json['name'],
        quantity: json['quantity'],
        price: json['price'] != null ? json['price'] : 0.0,
        priceVAT: json['priceVAT'] != null ? json['priceVAT'] : 0.0,
        total: json['total'] != null ? json['total'] : 0.0);
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
      'type': type?.toJson(),
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
