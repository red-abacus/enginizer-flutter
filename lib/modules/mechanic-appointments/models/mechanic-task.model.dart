import 'package:enginizer_flutter/modules/auctions/models/estimator/issue.model.dart';

class MechanicTask {
  int id;
  String name;
  bool completed;
  List<Issue> issues;

  MechanicTask({this.id, this.name, this.completed, this.issues = const []});

  factory MechanicTask.fromJson(Map<String, dynamic> json) {
    return MechanicTask(
        id: json['id'],
        name: json['name'],
        completed: json['completed'],
        issues: json['issues'] != null ? _mapIssues(json['issues']) : []);
  }

  static _mapIssues(List<dynamic> response) {
    List<Issue> issues = [];
    response.forEach((item) {
      issues.add(Issue.fromJson(item));
    });
    return issues;
  }
}
