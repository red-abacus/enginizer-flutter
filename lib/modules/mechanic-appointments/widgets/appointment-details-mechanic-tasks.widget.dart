import 'dart:async';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/mechanic-appointments/enums/mechanic-task-screen-state.enum.dart';
import 'package:app/modules/mechanic-appointments/enums/mechanic-task-state.enum.dart';
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
  Timer _timer;
  bool _timerStart = false;
  MechanicTask _currentTask;

  AppointmentMechanicProvider appointmentMechanicProvider;

  MechanicTaskScreenState _currentState = MechanicTaskScreenState.TASK;

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
        _buildTabBar(),
        _getContent(),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: (_timerStart)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _bottomButtons())
              : FloatingActionButton(
                  heroTag: 'startTimerBtn',
                  backgroundColor: active,
                  onPressed: _startTimer,
                  child: Icon(Icons.play_arrow)),
        ),
      ],
    );
  }

  List<Widget> _bottomButtons() {
    List<Widget> buttons = [];

    if (_currentState != MechanicTaskScreenState.FINISHED) {
      buttons.add(FloatingActionButton(
          heroTag: 'pauseTimerBtn',
          backgroundColor: pending,
          onPressed: _pauseTimer,
          child: Icon(Icons.pause)));

      buttons.add(SizedBox(width: 48));

      buttons.add(FloatingActionButton(
          heroTag: 'nextIssueBtn',
          backgroundColor: stop,
          onPressed: _nextIssue,
          child: Icon(Icons.navigate_next)));
    } else {
      buttons.add(FloatingActionButton(
          heroTag: 'nextIssueBtn',
          backgroundColor: stop,
          onPressed: _stopIssues,
          child: Icon(Icons.stop)));
    }

    return buttons;
  }

  _getContent() {
    return _currentState == MechanicTaskScreenState.TASK
        ? Expanded(
            child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: appointmentMechanicProvider.standardTasks.length,
                itemBuilder: (context, index) {
                  return AppointmentDetailsMechanicTaskSectionWidget(
                      task: appointmentMechanicProvider.standardTasks[index],
                      index: index);
                }),
          ))
        : Expanded(
            child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: appointmentMechanicProvider.issueTasks.length,
                itemBuilder: (context, index) {
                  return AppointmentDetailsMechanicTaskSectionWidget(
                      task: appointmentMechanicProvider.issueTasks[index],
                      index: index);
                }),
          ));
  }

  _startTimer() {
    if (!_timerStart) {
      setState(() {
        _timerStart = true;

        _currentTask = appointmentMechanicProvider.standardTasks[0];
        _currentTask.state = MechanicTaskState.SELECTED;
        _currentTask.issues = [Issue(id: -1, name: '')];
      });
    }
  }

  _pauseTimer() {}

  _nextIssue() {
    if (_currentTask != null) {
      _currentTask.state = MechanicTaskState.FINISHED;

      if (_currentState == MechanicTaskScreenState.TASK) {
        int index =
            appointmentMechanicProvider.standardTasks.indexOf(_currentTask);

        if (index < appointmentMechanicProvider.standardTasks.length - 1) {
          setState(() {
            _currentTask = appointmentMechanicProvider.standardTasks[index + 1];
            _currentTask.state = MechanicTaskState.SELECTED;
            _currentTask.issues = [Issue(id: -1, name: '')];
          });
        } else {
          setState(() {
            _currentState = MechanicTaskScreenState.CLIENT;

            _currentTask = appointmentMechanicProvider.issueTasks[0];
            _currentTask.state = MechanicTaskState.SELECTED;
            _currentTask.issues = [Issue(id: -1, name: '')];
          });
        }
      } else {
        int index =
            appointmentMechanicProvider.issueTasks.indexOf(_currentTask);

        if (index < appointmentMechanicProvider.issueTasks.length - 1) {
          setState(() {
            _currentTask = appointmentMechanicProvider.issueTasks[index + 1];
            _currentTask.state = MechanicTaskState.SELECTED;
            _currentTask.issues = [Issue(id: -1, name: '')];
          });
        } else {
          setState(() {
            _currentState = MechanicTaskScreenState.FINISHED;
          });
        }
      }
    }
  }

  _buildTabBar() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 40,
      child: new Row(
        children: <Widget>[
          _buildTabBarButton(MechanicTaskScreenState.TASK),
          _buildTabBarButton(MechanicTaskScreenState.CLIENT),
        ],
      ),
    );
  }

  Widget _buildTabBarButton(MechanicTaskScreenState state) {
    Color bottomColor = (_currentState == state) ? red : gray_80;

    return Expanded(
      flex: 1,
      child: Container(
          child: Center(
            child: Text(
              state == MechanicTaskScreenState.CLIENT
                  ? S.of(context).mechanic_appointment_standard_verifications
                  : S.of(context).mechanic_appointment_client_requests,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Lato",
                  color: red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(width: 1.0, color: bottomColor),
          ))),
    );
  }

  _stopIssues() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppointmentMechanicTasksFormWidget(
          confirmFunction: (confirmation) {
            // TODO - need to do something this confirmation
            if (confirmation) {}
          },
        );
      },
    );
  }
}
