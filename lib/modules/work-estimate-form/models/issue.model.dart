import 'issue-item.model.dart';
import 'issue-section.model.dart';

class Issue {
  int id;
  String name;
  List<IssueSection> sections;

  Issue({this.id, this.name, this.sections = const []});


  clearItems() {
    for(IssueSection section in sections) {
      section.clearItems();
    }

    sections = [];
  }

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
        id: json['id'],
        name: json['name'],
        sections: []);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'id': id,
      'name': name,
      'sections': []
    };

    return propMap;
  }

  Map<String, dynamic> toCreateJson() {
    Map<String, dynamic> propMap = {
      'id': id,
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
