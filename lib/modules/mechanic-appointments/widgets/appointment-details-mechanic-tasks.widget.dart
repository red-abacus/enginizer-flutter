import 'dart:async';

import 'package:app/modules/mechanic-appointments/enums/mechanic-task-state.enum.dart';
import 'package:app/modules/mechanic-appointments/widgets/items/tasks/appointment-details-mechanic-task-section.widget.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/mechanic-appointments/models/mechanic-task.model.dart';
import 'package:app/modules/mechanic-appointments/providers/appointment-mechanic.provider.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentDetailsTasksList extends StatefulWidget {
  AppointmentDetailsTasksList();

  @override
  AppointmentDetailsTasksListState createState() {
    return AppointmentDetailsTasksListState();
  }
}

class AppointmentDetailsTasksListState
    extends State<AppointmentDetailsTasksList> {

  Timer _timer;

  AppointmentMechanicProvider appointmentMechanicProvider;

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appointmentMechanicProvider =
        Provider.of<AppointmentMechanicProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: appointmentMechanicProvider.standardTasks.length,
              itemBuilder: (context, index) {
                return AppointmentDetailsMechanicTaskSectionWidget(
                    task: appointmentMechanicProvider.standardTasks[index],
                    index: index);
              }),
        )),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: (_timer != null && _timer.isActive)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FloatingActionButton(
                        heroTag: 'pauseTimerBtn',
                        backgroundColor: pending,
                        onPressed: _pauseTimer,
                        child: Icon(Icons.pause)),
                    SizedBox(width: 48),
                    FloatingActionButton(
                        heroTag: 'nextIssueBtn',
                        backgroundColor: stop,
                        onPressed: _nextIssue,
                        child: Icon(Icons.navigate_next))
                  ],
                )
              : FloatingActionButton(
                  heroTag: 'startTimerBtn',
                  backgroundColor: active,
                  onPressed: _startTimer,
                  child: Icon(Icons.play_arrow)),
        ),
      ],
    );
  }

  _addIssue(Issue issue) {
    if (issue.name.isEmpty) {
      return;
    }
    setState(() {
      var index =
          appointmentMechanicProvider.selectedMechanicTask.issues.length - 1;
      appointmentMechanicProvider.selectedMechanicTask.issues[index] = issue;
      appointmentMechanicProvider.selectedMechanicTask.issues
          .add(Issue(id: null, name: ''));
    });
  }

  _removeIssue(int index) {
    setState(() {
      appointmentMechanicProvider.selectedMechanicTask.issues.removeAt(index);
    });
  }

  _startTimer() {
    if (appointmentMechanicProvider.standardTasks.length > 0) {
      setState(() {
        appointmentMechanicProvider.standardTasks[0].state =
            MechanicTaskState.SELECTED;
        appointmentMechanicProvider.standardTasks[0].issues = [
          Issue(id: 0, name: '')
        ];
      });
    }
  }

  _pauseTimer() {
    setState(() {
      _timer.cancel();
    });
  }

  _nextIssue() {
    bool allTasksCompleted = true;

    for (MechanicTask task in appointmentMechanicProvider.standardTasks) {
      if (!task.completed) {
        allTasksCompleted = false;
      }
    }

    if (allTasksCompleted) {
      _editWorkEstimate();
    } else {
      setState(() {
//        appointmentMechanicProvider.selectedMechanicTask.completed = true;
//        if (_currentStepIndex + 1 <
//            appointmentMechanicProvider.standardTasks.length) {
//          _currentStepIndex += 1;
//          appointmentMechanicProvider.selectedMechanicTask =
//              appointmentMechanicProvider.standardTasks[_currentStepIndex];
//
//          _currentStepIndex = _currentStepIndex;
//        }
      });
    }
  }

  _editWorkEstimate() {}
}
