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

  static _mapIssueItems(List<dynamic> response) {
    List<IssueItem> issuesItems = [];
    response.forEach((item) {
      issuesItems.add(IssueItem.fromJson(item));
    });
    return issuesItems;
  }
}
