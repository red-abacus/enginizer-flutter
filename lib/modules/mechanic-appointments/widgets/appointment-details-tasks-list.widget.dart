import 'dart:async';

import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue.model.dart';
import 'package:enginizer_flutter/modules/mechanic-appointments/models/mechanic-task.model.dart';
import 'package:enginizer_flutter/modules/mechanic-appointments/models/timer-config.model.dart';
import 'package:enginizer_flutter/modules/mechanic-appointments/providers/appointment-mechanic.provider.dart';
import 'package:enginizer_flutter/modules/mechanic-appointments/widgets/appointment-details-task-issues-list.widget.dart';
import 'package:enginizer_flutter/utils/constants.dart';
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
  int _currentStepIndex = 0;
  List<Step> steps = [];

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
    appointmentMechanicProvider =
        Provider.of<AppointmentMechanicProvider>(context, listen: false);

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
                  currentStep: _currentStepIndex,
                  onStepTapped: (stepIndex) => _showTask(stepIndex),
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
                        heroTag: 'stopTimerBtn',
                        backgroundColor: stop,
                        onPressed: _stopTimer,
                        child: Icon(Icons.stop))
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
          title: Text(
              (task.name?.isNotEmpty ?? false)
                  ? _translateTaskName(task.name)
                  : 'N/A',
              style: TextStyle(color: Colors.black87)),
          content: AppointmentDetailsTaskIssuesList(
            issues: appointmentMechanicProvider.selectedMechanicTask.issues,
            addIssue: _addIssue,
            removeIssue: _removeIssue,
          ),
        ),
      );
    });
    return stepsList;
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

  _showTask(int stepIndex) {
    setState(() {
      appointmentMechanicProvider.selectedMechanicTask =
          appointmentMechanicProvider.standardTasks[stepIndex];

      _currentStepIndex = stepIndex;
    });
  }

  _startTimer() {
    setState(() {
      _timer = Timer.periodic(
        Duration(seconds: 1),
        (timer) => setState(() {
          _timerConfig.seconds += 1;
          if (_timerConfig.seconds > 59) {
            _timerConfig.seconds = 0;
            _timerConfig.minutes += 1;
          }
          if (_timerConfig.minutes > 59) {
            _timerConfig.minutes = 0;
            _timerConfig.hours += 1;
          }
        }),
      );
      _showTimer = true;
    });
  }

  _pauseTimer() {
    setState(() {
      _timer.cancel();
    });
  }

  _stopTimer() {
    setState(() {
      _timer.cancel();
      _timerConfig = TimerConfig();
      _showTimer = false;
    });
  }

  bool _isStepActive(int stepIndex) {
    return _currentStepIndex == stepIndex;
  }

  _translateTaskName(String taskName) {
    switch (taskName) {
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
