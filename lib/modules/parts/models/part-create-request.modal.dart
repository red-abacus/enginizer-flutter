import 'dart:io';

class PartCreateRequest {
  List<File> files = [null];

  String name = '';
  String code = '';
  double price;
  double vta = 0.0;
  double addition = 0.0;
  int guarantee = 0;

  Map<String, dynamic> toJson() => {
        'addition': addition,
        'code': code,
        'guarantee': guarantee,
        'name': name,
        'price': price,
        'providedBy': 0,
        'typeId': 2
      };
}
