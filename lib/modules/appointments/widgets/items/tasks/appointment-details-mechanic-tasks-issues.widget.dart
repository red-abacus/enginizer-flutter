import 'dart:async';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/enum/mechanic-task-screen-state.enum.dart';
import 'package:app/modules/appointments/model/personnel/mechanic-task-issue.model.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/appointments/enum/mechanic-task-status.enum.dart';
import 'package:app/modules/appointments/enum/mechanic-task-type.enum.dart';
import 'package:app/modules/appointments/model/personnel/mechanic-task.model.dart';
import 'package:app/modules/appointments/providers/appointment-mechanic.provider.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../appointment-mechanic-tasks-form.widget.dart';
import 'appointment-details-mechanic-task-section.widget.dart';

class AppointmentDetailsMechanicTasksIssuesWidget extends StatefulWidget {
  final Function stopAppointment;

  AppointmentDetailsMechanicTasksIssuesWidget({this.stopAppointment});

  @override
  _AppointmentDetailsMechanicTasksIssuesWidgetState createState() {
    return _AppointmentDetailsMechanicTasksIssuesWidgetState();
  }
}

class _AppointmentDetailsMechanicTasksIssuesWidgetState
    extends State<AppointmentDetailsMechanicTasksIssuesWidget> {
  AppointmentMechanicProvider _provider;

  Timer _timer;

  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

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
    _provider = Provider.of<AppointmentMechanicProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _buildTabBar(),
        _totalTimeWidget(),
        _getContent(),
        Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _bottomButtons())),
      ],
    );
  }

  List<Widget> _bottomButtons() {
    List<Widget> buttons = [];

    switch (_provider.selectedAppointmentDetails.status.getState()) {
      case AppointmentStatusState.IN_UNIT:
        buttons.add(FloatingActionButton(
            heroTag: 'nextIssueBtn',
            backgroundColor: stop,
            onPressed: _startAppointment,
            child: Icon(Icons.navigate_next)));
        break;
      case AppointmentStatusState.ON_HOLD:
        buttons.add(FloatingActionButton(
            heroTag: 'resumeIssueBtn',
            backgroundColor: stop,
            onPressed: _startAppointment,
            child: Icon(Icons.navigate_next)));
        break;
      case AppointmentStatusState.IN_WORK:
        buttons.add(FloatingActionButton(
            heroTag: 'pauseTimerBtn',
            backgroundColor: pending,
            onPressed: _pauseAppointment,
            child: Icon(Icons.pause)));

        buttons.add(SizedBox(width: 48));

        if (_provider.nextIssue() != null) {
          buttons.add(FloatingActionButton(
              heroTag: 'nextIssueBtn',
              backgroundColor: stop,
              onPressed: _nextIssue,
              child: Icon(Icons.navigate_next)));
        } else {
          buttons.add(FloatingActionButton(
              heroTag: 'stopIssueBtn',
              backgroundColor: stop,
              onPressed: _stopIssues,
              child: Icon(Icons.stop)));
        }

        break;
      default:
        break;
    }

    return buttons;
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

  _checkTimer() {
    if (_timer != null) {
      _timer.cancel();
    }

    MechanicTask standardTask;
    MechanicTask issueTask;

    for (MechanicTask task in _provider.standardTasks) {
      if (task.status == MechanicTaskStatus.IN_PROGRESS) {
        standardTask = task;
      }
    }

    for (MechanicTask task in _provider.issueTasks) {
      if (task.status == MechanicTaskStatus.IN_PROGRESS) {
        issueTask = task;
      }
    }

    if (standardTask != null || issueTask != null) {
      const oneDecimal = const Duration(seconds: 1);
      _timer = new Timer.periodic(oneDecimal, (Timer timer) => setState(() {
        if (_currentState == MechanicTaskScreenState.TASK && issueTask != null) {
          issueTask.addOneSecond();
        }
        else if (_currentState == MechanicTaskScreenState.CLIENT && standardTask != null) {
          standardTask.addOneSecond();
        }
        else {
          setState(() {
          });
        }
      }));
    }
  }

  _totalTimeWidget() {
    _checkTimer();

    _hours = 0;
    _minutes = 0;
    _seconds = 0;

    List<MechanicTask> allTasks =
        _provider.standardTasks + _provider.issueTasks;

    for (MechanicTask task in allTasks) {
      _hours += task.hours();
      _minutes += task.minutes();
      _seconds += task.seconds();
    }

    if (_seconds > 59) {
      _seconds = 0;
      _minutes += 1;
    }

    if (_minutes > 59) {
      _minutes = 0;
      _hours += 1;
    }

    String hourString = (_hours < 10) ? '0$_hours' : _hours.toString();
    String minutesString = (_minutes < 10) ? '0$_minutes' : _minutes.toString();
    String secondsString = (_seconds < 10) ? '0$_seconds' : _seconds.toString();

    return Container(
      margin: EdgeInsets.only(top: 10, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('${S.of(context).mechanic_appointment_total_time}:'),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(5.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                color: gray,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '$hourString:$minutesString:$secondsString',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
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
            child: FlatButton(
              child: Text(
                state == MechanicTaskScreenState.CLIENT
                    ? S.of(context).mechanic_appointment_client_requests
                    : S.of(context).mechanic_appointment_standard_verifications,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Lato",
                    color: red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
              onPressed: () {
                setState(() {
                  _currentState = state;

                  if (_currentState == MechanicTaskScreenState.TASK) {
                    _loadStandardTasks();
                  } else {
                    _loadClientTasks();
                  }
                });
              },
            ),
          ),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(width: 1.0, color: bottomColor),
          ))),
    );
  }

  _getContent() {
    return _currentState == MechanicTaskScreenState.TASK
        ? Expanded(
            child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _provider.standardTasks.length,
                itemBuilder: (context, index) {
                  return AppointmentDetailsMechanicTaskSectionWidget(
                      task: _provider.standardTasks[index],
                      index: index,
                      addMechanicTaskIssue: _addMechanicTaskIssue);
                }),
          ))
        : Expanded(
            child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _provider.issueTasks.length,
                itemBuilder: (context, index) {
                  return AppointmentDetailsMechanicTaskSectionWidget(
                      task: _provider.issueTasks[index],
                      index: index,
                      addMechanicTaskIssue: _addMechanicTaskIssue);
                }),
          ));
  }

  _startAppointment() async {
    try {
      await _provider
          .startAppointment(_provider.selectedAppointment.id)
          .then((result) {
        if (result != null) {
          Provider.of<AppointmentsProvider>(context).initDone = false;
          _startTask();
        }
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.START_APPOINTMENT_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_start_appointment, context);
      }
    }
  }

  _startTask() async {
    MechanicTask newTask = _provider.firstTaskShouldStart();

    if (newTask != null) {
      _startGenericTask(newTask);
    }
  }

  _startGenericTask(MechanicTask task) async {
    if (task.type == MechanicTaskType.STANDARD) {
      try {
        await _provider
            .startAppointmentTask(_provider.selectedAppointmentDetails.id, task)
            .then((_) {
          _provider.currentTask = task;
          _loadStandardTasks();
        });
      } catch (error) {
        if (error
            .toString()
            .contains(AppointmentsService.START_APPOINTMENT_TASK_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_start_appointment_task, context);
        }

        _loadStandardTasks();
      }
    } else {
      try {
        await _provider
            .startAppointmentTask(_provider.selectedAppointmentDetails.id, task)
            .then((_) {
          if (_provider.currentTask != null) {
            if (_provider.currentTask.type != task.type) {
              _loadStandardTasks();
            }
          }
          _provider.currentTask = task;
          _loadClientTasks();
        });
      } catch (error) {
        if (error
            .toString()
            .contains(AppointmentsService.START_APPOINTMENT_TASK_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_start_appointment_task, context);
        }

        _loadClientTasks();
      }
    }
  }

  _pauseAppointment() async {
    try {
      await _provider
          .pauseAppointment(_provider.selectedAppointmentDetails.id)
          .then((_) {
        Provider.of<AppointmentsProvider>(context).initDone = false;

        if (_provider.currentTask != null) {
          if (_provider.currentTask.type == MechanicTaskType.STANDARD) {
            _loadStandardTasks();
          } else {
            _loadClientTasks();
          }
        }
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.PAUSE_APPOINTMENT_TASK_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_pause_appointment, context);
      }
    }
  }

  _nextIssue() async {
    MechanicTask nextIssue = _provider.nextIssue();

    if (nextIssue != null) {
      _startGenericTask(nextIssue);
    }
  }

  _stopIssues() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppointmentMechanicTasksFormWidget(
          confirmFunction: (confirmation) {
            if (confirmation) {
              widget.stopAppointment(_provider.selectedAppointmentDetails);
            }
          },
        );
      },
    );
  }

  _loadTasks(MechanicTask task) {
    if (task.type == MechanicTaskType.STANDARD) {
      _loadStandardTasks();
    } else {
      _loadClientTasks();
    }
  }

  _loadStandardTasks() async {
    try {
      await _provider
          .getStandardTasks(_provider.selectedAppointment.id)
          .then((tasks) {
        setState(() {
          _currentState = MechanicTaskScreenState.TASK;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.GET_STANDARD_TASKS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_standard_tasks, context);

        setState(() {
          _currentState = MechanicTaskScreenState.TASK;
        });
      }
    }
  }

  _loadClientTasks() async {
    try {
      await _provider
          .getClientTasks(_provider.selectedAppointment.id)
          .then((tasks) {
        setState(() {
          _currentState = MechanicTaskScreenState.CLIENT;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.GET_CLIENT_TASKS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_client_tasks, context);
      }

      setState(() {
        _currentState = MechanicTaskScreenState.CLIENT;
      });
    }
  }

  _addMechanicTaskIssue(MechanicTask task, MechanicTaskIssue issue) async {
    try {
      await _provider
          .addAppointmentRecommendation(
              _provider.selectedAppointmentDetails.id, issue)
          .then((response) async {
        if (issue.image != null) {
          await _provider
              .addAppointmentRecommendationImage(
                  _provider.selectedAppointmentDetails.id, issue)
              .then((response) {
            _loadTasks(task);
          });
        } else {
          _loadTasks(task);
        }
      });
    } catch (error) {
      if (error.toString().contains(
          AppointmentsService.ADD_APPOINTMENT_RECOMMENDATION_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_add_appointment_recommendation, context);
      } else if (error.toString().contains(
          AppointmentsService.ADD_APPOINTMENT_RECOMMENDATION_IMAGE_EXCEPTION)) {
        FlushBarHelper.showFlushBar(
            S.of(context).general_error,
            S.of(context).exception_add_appointment_recommendation_image,
            context);
      }

      _loadTasks(task);
    }
  }
}
