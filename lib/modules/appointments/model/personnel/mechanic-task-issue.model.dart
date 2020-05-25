import 'dart:io';

import 'package:app/modules/appointments/enum/task-priority.enum.dart';

class MechanicTaskIssue {
  int id;
  String name;
  TaskPriority priority;
  File image;
  int taskId;

  MechanicTaskIssue(
      {this.id, this.name, this.priority, this.image, this.taskId});

  factory MechanicTaskIssue.fromJson(Map<String, dynamic> json) {
    return MechanicTaskIssue(
        id: json['id'] != null ? json['id'] : 0,
        name: json['name'] != null ? json['name'] : '-',
        priority: json['priority'] != null
            ? TaskPriorityUtils.fromString(json['priority'])
            : TaskPriority.LOW);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'priority': TaskPriorityUtils.getString(priority),
      'taskId': taskId
    };
  }
}
