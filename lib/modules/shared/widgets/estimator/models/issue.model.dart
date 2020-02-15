import 'issue-item.model.dart';

class Issue {
  int id;
  String description;
  List<IssueItem> items;

  Issue({this.id, this.description, this.items = const []});

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
        id: json['id'],
        description: json['description'],
        items: json['items'] ?? []);
  }
}
