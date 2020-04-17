import 'package:app/generated/l10n.dart';
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
}

enum TaskPriority {
  LOW,
  MEDIUM,
  HIGH
}