import 'dart:io';

import 'package:app/modules/mechanic-appointments/enums/task-priority.enum.dart';

import 'issue-item.model.dart';
import 'issue-recommendation.model.dart';

class Issue {
  int id;
  String name;
  List<IssueRecommendation> recommendations;
  TaskPriority priority;
  File image;

  Issue({this.id, this.name, this.recommendations = const []});

  clearItems() {
    for (IssueRecommendation section in recommendations) {
      section.clearItems();
    }

    recommendations = [];
  }

  factory Issue.fromJson(Map<String, dynamic> json) {
    IssueRecommendation issueRecommendation = new IssueRecommendation();
    issueRecommendation.name = "Hardcoded Section";

    List<IssueItem> items = [];

    if (json['items'] != null) {
      List<dynamic> temp = json['items'];
      temp.forEach((item) {
        items.add(IssueItem.fromJson(item));
      });
    }

    issueRecommendation.items = items;

    return Issue(id: json['id'], name: json['name'], recommendations: [issueRecommendation]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {'id': id, 'name': name, 'sections': []};

    return propMap;
  }

  Map<String, dynamic> toCreateJson() {
    Map<String, dynamic> propMap = {
      'id': id,
      'name': name,
      'recommendations': recommendations.map((item) => item.toCreateJson()).toList()
    };

    return propMap;
  }

  static _mapIssueItems(List<dynamic> response) {
    List<IssueItem> issuesItems = [];

    if (response != null) {
      response.forEach((item) {
        issuesItems.add(IssueItem.fromJson(item));
      });
    }
    return issuesItems;
  }
}
