import 'package:enginizer_flutter/modules/appointments/model/appointment-issue.model.dart';

class MechanicTask {
  int id;
  String name;
  bool completed;
  List<AppointmentIssue> issues;

  MechanicTask({this.id, this.name, this.completed, this.issues = const []});

  factory MechanicTask.fromJson(Map<String, dynamic> json) {
    return MechanicTask(
        id: json['id'],
        name: json['name'],
        completed: json['completed'],
        issues: json['issues'] != null ? _mapIssues(json['issues']) : []);
  }

  static _mapIssues(List<dynamic> response) {
    List<AppointmentIssue> issues = [];
    response.forEach((item) {
      issues.add(AppointmentIssue.fromJson(item));
    });
    return issues;
  }
}
