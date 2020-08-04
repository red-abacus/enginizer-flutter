import 'package:app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

class CarColor {
  int id;
  String name;

  CarColor({this.id = -1, this.name = ''});

  factory CarColor.fromJson(Map<String, dynamic> json) {
    return CarColor(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  bool operator ==(other) {
    return id == other.id;
  }

  String translateColorName(BuildContext context) {
    switch (name) {
      case 'COLOR_RED':
        return S.of(context).COLOR_RED;
      case 'COLOR_BLACK':
        return S.of(context).COLOR_BLACK;
      case 'COLOR_GREEN':
        return S.of(context).COLOR_GREEN;
      case 'COLOR_SILVER':
        return S.of(context).COLOR_SILVER;
      case 'COLOR_WHITE':
        return S.of(context).COLOR_WHITE;
      case 'COLOR_GRAY':
        return S.of(context).COLOR_GRAY;
      case 'COLOR_DARK_BLUE':
        return S.of(context).COLOR_DARK_BLUE;
      case 'COLOR_DARK_GRAY':
        return S.of(context).COLOR_DARK_GRAY;
      case 'COLOR_GOLD':
        return S.of(context).COLOR_GOLD;
      default:
        return '';
    }
  }
}
