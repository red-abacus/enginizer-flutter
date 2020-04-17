import 'dart:io';

import 'package:app/modules/mechanic-appointments/enums/task-priority.enum.dart';

import 'issue-item.model.dart';
import 'issue-section.model.dart';

class Issue {
  int id;
  String name;
  List<IssueSection> sections;
  TaskPriority priority;
  File image;

  Issue({this.id, this.name, this.sections = const []});

  clearItems() {
    for (IssueSection section in sections) {
      section.clearItems();
    }

    sections = [];
  }

  factory Issue.fromJson(Map<String, dynamic> json) {
    IssueSection issueSection = new IssueSection();
    issueSection.name = "Hardcoded Section";

    List<IssueItem> items = [];

    if (json['items'] != null) {
      List<dynamic> temp = json['items'];
      temp.forEach((item) {
        items.add(IssueItem.fromJson(item));
      });
    }

    issueSection.items = items;

    return Issue(id: json['id'], name: json['name'], sections: [issueSection]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {'id': id, 'name': name, 'sections': []};

    return propMap;
  }

  Map<String, dynamic> toCreateJson() {
    List<IssueItem> items = [];

    for (IssueSection section in sections) {
      items.addAll(section.items);
    }

    Map<String, dynamic> propMap = {
      'id': id,
      'items': items.map((item) => item.toJson()).toList()
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
