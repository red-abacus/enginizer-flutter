import 'package:app/modules/consultant-appointments/enums/tank-quantity.enum.dart';

import 'issue-item.model.dart';

class IssueRecommendation {
  int id;
  String name;
  List<IssueItem> items;
  bool isNew = false;
  bool expanded = false;
  bool selected = false;

  clearItems() {
    items = [];
  }

  static IssueRecommendation defaultRecommendation() {
    IssueRecommendation recommendation = new IssueRecommendation();
    recommendation.name = "";
    recommendation.id = 0;
    recommendation.items = [];
    recommendation.isNew = true;

    return recommendation;
  }

  Map<String, dynamic> toCreateJson() {
    Map<String, dynamic> propMap = {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toJson()).toList()
    };

    return propMap;
  }
}