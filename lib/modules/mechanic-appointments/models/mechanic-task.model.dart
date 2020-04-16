import 'package:app/generated/l10n.dart';
import 'package:app/modules/mechanic-appointments/enums/mechanic-task-state.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:flutter/cupertino.dart';

class MechanicTask {
  int id;
  String name;
  bool completed;
  List<Issue> issues = [];
  MechanicTaskState state = MechanicTaskState.NOT_SELECTED;

  MechanicTask({this.id, this.name, this.completed, this.issues});

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

  String translatedName(BuildContext context) {
    switch (name) {
      case 'CHECK_LIGHTS':
        return S.of(context).appointment_details_task_check_lights;
      case 'CHECK_BATTERY':
        return S.of(context).appointment_details_task_check_battery;
      case 'CHECK_LIQUIDS':
        return S.of(context).appointment_details_task_check_liquids;
      case 'CHECK_BRAKES':
        return S.of(context).appointment_details_task_check_brakes;
      case 'CHECK_STEERING':
        return S.of(context).appointment_details_task_check_steering;
      case 'CHECK_BRAKING_MECHANISM':
        return S.of(context).appointment_details_task_check_braking_mechanism;
    }
  }
}
