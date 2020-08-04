import 'package:app/generated/l10n.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';

class TaskPriorityUtils {
  static String title(BuildContext context, TaskPriority priority) {
    switch (priority) {
      case TaskPriority.LOW:
        return S.of(context).mechanic_appointment_task_priority_low;
      case TaskPriority.MEDIUM:
        return S.of(context).mechanic_appointment_task_priority_medium;
      case TaskPriority.HIGH:
        return S.of(context).mechanic_appointment_task_priority_high;
    }
  }

  static Color color(BuildContext context, TaskPriority priority) {
    switch (priority) {
      case TaskPriority.LOW:
        return gray;
      case TaskPriority.MEDIUM:
        return yellow;
      case TaskPriority.HIGH:
        return red;
    }
  }

  static TaskPriority fromString(String sender) {
    switch(sender.toLowerCase()) {
      case 'high':
        return TaskPriority.HIGH;
      case 'medium':
        return TaskPriority.MEDIUM;
      case 'low':
        return TaskPriority.LOW;
    }

    return null;
  }

  static String getString(TaskPriority priority) {
    switch(priority) {
      case TaskPriority.HIGH:
        return 'HIGH';
      case TaskPriority.MEDIUM:
        return 'MEDIUM';
      case TaskPriority.LOW:
        return 'LOW';
    }
  }
}

enum TaskPriority { LOW, MEDIUM, HIGH }
