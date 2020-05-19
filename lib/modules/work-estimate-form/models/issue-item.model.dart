import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/auctions/models/estimator/item-type.model.dart';
import 'package:app/utils/date_utils.dart';

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
  bool imported;
  ServiceProvider provider;
  DateTime availableFrom;
  int warranty;

  IssueItem(
      {this.id,
      this.type,
      this.typeId,
      this.code,
      this.name,
      this.quantity,
      this.price,
      this.priceVAT,
      this.total,
      this.imported,
      this.provider,
      this.availableFrom,
      this.warranty});

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
        total: json['total'] != null ? json['total'] : 0.0,
        imported: json['imported'] != null ? json['imported'] : null,
        provider: json['provider'] != null
            ? ServiceProvider.fromJson(json['provider'])
            : null,
        availableFrom: json['availableFrom'] != null
            ? DateUtils.dateFromString(
                json['availableFrom'], 'dd/MM/yyyy HH:mm')
            : null,
        warranty: json['warranty'] != null ? json['warranty'] : 0);
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'type': type?.name,
        'code': code,
        'quantity': quantity.toString(),
        'priceNoVAT': (price - priceVAT).toString(),
        'priceVAT': price.toString(),
      };

  Map<String, dynamic> toCreateJson() {
    Map<String, dynamic> propMap = {
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
