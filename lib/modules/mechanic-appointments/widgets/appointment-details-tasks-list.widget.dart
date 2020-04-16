import 'dart:async';

import 'package:app/modules/mechanic-appointments/enums/mechanic-task-state.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/mechanic-appointments/models/mechanic-task.model.dart';
import 'package:app/modules/mechanic-appointments/models/timer-config.model.dart';
import 'package:app/modules/mechanic-appointments/providers/appointment-mechanic.provider.dart';
import 'package:app/modules/mechanic-appointments/widgets/items/appointment-details-task-issues-list.widget.dart';
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
  int _currentStepIndex = -1;
  List<Step> steps = [];
  bool _initDone = false;

  Timer _timer;
  TimerConfig _timerConfig = TimerConfig();
  bool _showTimer = false;

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
    steps = _buildSteps(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        if (_showTimer)
          Container(
            padding: EdgeInsets.all(12),
            alignment: Alignment.centerRight,
            child: _buildTimer(context),
          ),
        Expanded(
          child: steps.isNotEmpty
              ? Stepper(
                  type: StepperType.vertical,
                  steps: steps,
                  controlsBuilder: (BuildContext context,
                      {VoidCallback onStepContinue,
                      VoidCallback onStepCancel}) {
                    return Row(
                      children: <Widget>[
                        Container(
                          child: null,
                        ),
                        Container(
                          child: null,
                        ),
                      ],
                    );
                  },
                )
              : Container(),
        ),
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

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      appointmentMechanicProvider =
          Provider.of<AppointmentMechanicProvider>(context, listen: false);

//      MechanicTimerManager.getWorkPeriodTime(
//              appointmentMechanicProvider.workEstimateDetails.id)
//          .then((period) {
//        if (period != 0) {
//          setState(() {
//            _timer = Timer.periodic(Duration(seconds: 1), null);
//            _timer.cancel();
//
//            int hours = period ~/ 3600;
//            _timerConfig.hours = hours;
//            int minutes = (period - hours * 3600) ~/ 60;
//            _timerConfig.minutes = minutes;
//            int seconds = period - hours * 3600 - minutes * 60;
//            _timerConfig.seconds = seconds;
//            _showTimer = true;
//          });
//        }
//
//        MechanicTimerManager.getLastPeriod(
//                appointmentMechanicProvider.workEstimateDetails.id)
//            .then((lastPeriod) {
//          if (lastPeriod != null && lastPeriod.endDate == null) {
//            MechanicTimerManager.startWorkEstimate(
//                appointmentMechanicProvider.workEstimateDetails.id);
//
//            setState(() {
//              _timer = Timer.periodic(
//                Duration(seconds: 1),
//                (timer) => setState(() {
//                  _timerConfig.seconds += 1;
//                  if (_timerConfig.seconds > 59) {
//                    _timerConfig.seconds = 0;
//                    _timerConfig.minutes += 1;
//                  }
//                  if (_timerConfig.minutes > 59) {
//                    _timerConfig.minutes = 0;
//                    _timerConfig.hours += 1;
//                  }
//                }),
//              );
//              _showTimer = true;
//            });
//          }
//        });
//      });
    }
    _initDone = true;
    super.didChangeDependencies();
  }

  Widget _buildTimer(BuildContext context) {
    String hoursStr = (_timerConfig.hours % 24).toString().padLeft(2, '0');
    String minutesStr = (_timerConfig.minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (_timerConfig.seconds % 60).toString().padLeft(2, '0');

    return ClipRRect(
      borderRadius: new BorderRadius.circular(5.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        color: Colors.black87,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$hoursStr:$minutesStr:$secondsStr',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Step> _buildSteps(BuildContext context) {
    List<Step> stepsList = [];
    List<MechanicTask> mechanicTasks =
        appointmentMechanicProvider.standardTasks ?? [];
    mechanicTasks.asMap().forEach((index, task) {
      stepsList.add(
        Step(
          isActive: _isStepActive(index),
          title: _stepperTitle(task),
          content: task.state == MechanicTaskState.SELECTED
              ? AppointmentDetailsTaskIssuesListWidget(
                  mechanicTask: task,
                  addIssue: _addIssue,
                  removeIssue: _removeIssue,
                )
              : Container(),
        ),
      );
    });
    return stepsList;
  }

  _stepperTitle(MechanicTask task) {
    return Text(
        (task.name?.isNotEmpty ?? false) ? task.translatedName(context) : 'N/A',
        style: TextStyle(
            color: Colors.black87,
            decoration: task.completed
                ? TextDecoration.lineThrough
                : TextDecoration.none));
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
        appointmentMechanicProvider.standardTasks[0].issues = List.of(appointmentMechanicProvider.standardTasks[0].issues)..add(Issue(id: null, name: ''));

        _currentStepIndex = 0;
      });
    }
  }

  _pauseTimer() {
//    MechanicTimerManager.pauseWorkEstimate(
//        appointmentMechanicProvider.workEstimateDetails.id);

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
        appointmentMechanicProvider.selectedMechanicTask.completed = true;
        if (_currentStepIndex + 1 <
            appointmentMechanicProvider.standardTasks.length) {
          _currentStepIndex += 1;
          appointmentMechanicProvider.selectedMechanicTask =
              appointmentMechanicProvider.standardTasks[_currentStepIndex];

          _currentStepIndex = _currentStepIndex;
        }
      });
    }
  }

  _editWorkEstimate() {}

  bool _isStepActive(int stepIndex) {
    return _currentStepIndex == stepIndex;
  }
}
