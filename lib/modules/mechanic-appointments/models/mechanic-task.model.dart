import 'package:app/generated/l10n.dart';
import 'package:app/modules/mechanic-appointments/enums/mechanic-task-status.enum.dart';
import 'package:app/modules/mechanic-appointments/enums/mechanic-task-type.enum.dart';
import 'package:app/modules/mechanic-appointments/models/mechanic-task-issue.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:flutter/cupertino.dart';

class MechanicTask {
  int id;
  String name;
  MechanicTaskStatus status;
  MechanicTaskType type;
  String timeValue;
  String referenceTimeValue;

  List<MechanicTaskIssue> issues = [];

  MechanicTask(
      {this.id,
      this.name,
      this.status,
      this.issues,
      this.timeValue,
      this.referenceTimeValue,
      this.type});

  factory MechanicTask.fromJson(
      MechanicTaskType type, Map<String, dynamic> json) {
    return MechanicTask(
        id: json['id'],
        name: json['name'],
        status: json['status'] != null
            ? MechanicTaskStatusUtilities.fromString(json['status'])
            : '',
        issues: json['recommendations'] != null
            ? _mapIssues(json['recommendations'])
            : [],
        timeValue: json['timeValue'] != null ? json['timeValue'] : '',
        referenceTimeValue: json['referenceTimeValue'] != null
            ? json['referenceTimeValue']
            : '',
        type: type);
  }

  factory MechanicTask.from(Issue issue) {
    return MechanicTask(id: -1, name: issue.name, issues: []);
  }

  static _mapIssues(List<dynamic> response) {
    List<MechanicTaskIssue> issues = [];
    response.forEach((item) {
      issues.add(MechanicTaskIssue.fromJson(item));
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
      default:
        return name;
    }
  }
}
