import 'dart:async';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/mechanic-appointments/enums/mechanic-task-form-state.enum.dart';
import 'package:app/modules/mechanic-appointments/enums/mechanic-task-screen-state.enum.dart';
import 'package:app/modules/mechanic-appointments/enums/mechanic-task-state.enum.dart';
import 'package:app/modules/mechanic-appointments/widgets/appointment-details-mechanic-efficiency.widget.dart';
import 'package:app/modules/mechanic-appointments/widgets/appointment-details-mechanic-tasks-issues.widget.dart';
import 'package:app/modules/mechanic-appointments/widgets/items/tasks/appointment-details-mechanic-task-section.widget.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/mechanic-appointments/models/mechanic-task.model.dart';
import 'package:app/modules/mechanic-appointments/providers/appointment-mechanic.provider.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'items/appointment-mechanic-tasks-form.widget.dart';

class AppointmentDetailsTasksList extends StatefulWidget {
  AppointmentDetailsTasksList();

  @override
  AppointmentDetailsTasksListState createState() {
    return AppointmentDetailsTasksListState();
  }
}

class AppointmentDetailsTasksListState
    extends State<AppointmentDetailsTasksList> {
  MechanicTaskFormState _currentState = MechanicTaskFormState.EFFICIENCY;

  @override
  Widget build(BuildContext context) {
    return _currentState == MechanicTaskFormState.TASKS
        ? AppointmentDetailsMechanicTasksIssuesWidget(
            showEfficiency: showEfficiency)
        : AppointmentDetailsMechanicEfficiencyWidget();
  }

  showEfficiency() {
    setState(() {
      _currentState = MechanicTaskFormState.EFFICIENCY;
    });
  }
}
