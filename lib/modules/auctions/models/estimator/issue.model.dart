import 'package:enginizer_flutter/modules/appointments/model/appointment-issue.model.dart';

import 'issue-item.model.dart';

class Issue {
  int id;
  String name;
  List<IssueItem> items;

  Issue({this.id, this.name, this.items = const []});

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
        id: json['id'],
        name: json['name'],
        items: json['items'] != null ? _mapIssueItems(json['items']) : []);
  }

  factory Issue.fromAppointmentIssue(AppointmentIssue issue) {
    return Issue(id: issue.id, name: issue.name, items: []);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toJson()).toList()
    };

    return propMap;
  }

  Map<String, dynamic> toCreateJson() {
    Map<String, dynamic> propMap = {
      'id': id,
      'items': items.map((item) => item.toJson()).toList()
    };

    return propMap;
  }

  static _mapIssueItems(List<dynamic> response) {
    List<IssueItem> issuesItems = [];
    response.forEach((item) {
      issuesItems.add(IssueItem.fromJson(item));
    });
    return issuesItems;
  }
}
