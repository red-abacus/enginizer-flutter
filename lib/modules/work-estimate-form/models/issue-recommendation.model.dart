import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';

import 'issue-item.model.dart';

class IssueRecommendation {
  int id;
  String name;
  List<IssueItem> items;
  bool isNew = false;
  bool expanded = false;
  String priority;
  bool isStandard;
  bool isAccepted;

  IssueRecommendation(
      {this.id,
      this.name,
      this.items,
      this.priority,
      this.isStandard,
      this.isAccepted});

  factory IssueRecommendation.fromJson(Map<String, dynamic> json) {
    return IssueRecommendation(
        id: json['id'],
        name: json['name'] != null ? json['name'] : '',
        items: json['items'] != null ? _mapItems(json['items']) : [],
        priority: json['priority'] != null ? json['priority'] : '',
        isStandard: json['isStandard'] != null ? json['isStandard'] : true,
        isAccepted: json['isAccepted'] != null ? json['isAccepted'] : true);
  }

  static _mapItems(List<dynamic> response) {
    List<IssueItem> issueItems = [];
    response.forEach((item) {
      issueItems.add(IssueItem.fromJson(item));
    });
    return issueItems;
  }

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

  Map<String, dynamic> toCreateJson(EstimatorMode estimatorMode) {
    Map<String, dynamic> propMap = {
      'id': estimatorMode == EstimatorMode.CreatePart ? id : null,
      'name': estimatorMode == EstimatorMode.Create ? name : null,
      'items': items.map((item) => item.toJson()).toList()
    };

    return propMap;
  }

  double totalCost() {
    double total = 0.0;
    for (IssueItem item in this.items) {
      total += item.total;
    }
    return total;
  }
}
