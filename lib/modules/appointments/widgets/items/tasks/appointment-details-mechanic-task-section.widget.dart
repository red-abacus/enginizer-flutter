import 'dart:async';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/enum/mechanic-task-status.enum.dart';
import 'package:app/modules/appointments/model/personnel/mechanic-task-issue.model.dart';
import 'package:app/modules/appointments/model/personnel/mechanic-task.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../personnel/appointment-details-mechanic-task-issue-modal.widget.dart';
import 'appointment-details-mechanic-task-issue.widget.dart';

class AppointmentDetailsMechanicTaskSectionWidget extends StatefulWidget {
  final MechanicTask task;
  final int index;

  Function addMechanicTaskIssue;

  AppointmentDetailsMechanicTaskSectionWidget(
      {this.task, this.index, this.addMechanicTaskIssue});

  @override
  _AppointmentDetailsMechanicTaskSectionWidgetState createState() {
    return _AppointmentDetailsMechanicTaskSectionWidgetState();
  }
}

class _AppointmentDetailsMechanicTaskSectionWidgetState
    extends State<AppointmentDetailsMechanicTaskSectionWidget> {
  bool _bestTimeActivated = false;
  Timer _timer;

  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

  @override
  void dispose() {
    super.dispose();

    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_timer != null) {
      _timer.cancel();
    }

    _initialiseTime();

    if (widget.task.status == MechanicTaskStatus.IN_PROGRESS) {
      const oneDecimal = const Duration(seconds: 1);
      _timer = new Timer.periodic(
          oneDecimal,
          (Timer timer) => setState(() {
                setState(() {
                  widget.task.addOneSecond();
                });
              }));
    }

    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _numberContainer(),
                _titleWidget(),
                _timerWidget(),
                _bestTimeWidget(),
              ],
            ),
          ),
          _issuesContainer(),
        ],
      ),
    );
  }

  _initialiseTime() {
    _hours = widget.task.hours();
    _minutes = widget.task.minutes();
    _seconds = widget.task.seconds();
  }

  _issuesContainer() {
    return widget.task.status != MechanicTaskStatus.NEW
        ? ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _recommendationsNumber(),
            itemBuilder: (context, index) {
              return _recommendationWidget(index);
            })
        : Container();
  }

  _recommendationsNumber() {
    switch (widget.task.status) {
      case MechanicTaskStatus.NEW:
      case MechanicTaskStatus.DONE:
        return 0;
      case MechanicTaskStatus.IN_PROGRESS:
      case MechanicTaskStatus.ON_HOLD:
        return widget.task.issues.length + 1;
    }
  }

  _recommendationWidget(int index) {
    if (index < widget.task.issues.length) {
      return AppointmentDetailsTaskIssueWidget(
          mechanicTaskIssue: widget.task.issues[index],
          showMechanicTaskIssueModal: _showMechanicTaskIssueModal);
    }

    return AppointmentDetailsTaskIssueWidget(
        mechanicTaskIssue: MechanicTaskIssue(
            id: -1, name: '', taskId: widget.task.id),
        showMechanicTaskIssueModal: _showMechanicTaskIssueModal);
  }

  _titleWidget() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 6),
        child: Text(
            (widget.task.name?.isNotEmpty ?? false)
                ? widget.task.translatedName(context)
                : 'N/A',
            style: TextStyle(color: Colors.black87)),
      ),
    );
  }

  _timerWidget() {
    String hourString = (_hours < 10) ? '0$_hours' : _hours.toString();
    String minutesString = (_minutes < 10) ? '0$_minutes' : _minutes.toString();
    String secondsString = (_seconds < 10) ? '0$_seconds' : _seconds.toString();

    return Align(
      alignment: Alignment.centerRight,
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(5.0),
        child: Container(
          height: 30,
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
    );
  }

  _bestTimeWidget() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(left: 4),
        width: 60,
        child: !_bestTimeActivated
            ? GestureDetector(
                child: Icon(Icons.timer, color: gray),
                onTap: () => _showBestTime())
            : Text(
                '${S.of(context).mechanic_appointment_tasks_reference_time_title}: ${widget.task.referenceTimeValue}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: gray,
                  fontSize: 10,
                ),
              ),
      ),
    );
  }

  _numberContainer() {
    return Container(
      alignment: Alignment.center,
      child: Text('${widget.index + 1}',
          textAlign: TextAlign.center,
          style: TextHelper.customTextStyle(
              null, Colors.white, FontWeight.normal, 14)),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: _getNumberColor(),
        borderRadius: new BorderRadius.all(
          const Radius.circular(12.0),
        ),
      ),
    );
  }

  _getNumberColor() {
    switch (widget.task.status) {
      case MechanicTaskStatus.DONE:
        return green;
      case MechanicTaskStatus.ON_HOLD:
      case MechanicTaskStatus.IN_PROGRESS:
        return red;
//      case MechanicTaskState.FINISHED:
//        return green;
      case MechanicTaskStatus.NEW:
        return gray;
    }
  }

  _showBestTime() {
    setState(() {
      _bestTimeActivated = true;
    });

    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        _bestTimeActivated = false;
      });
    });
  }

  _showMechanicTaskIssueModal(MechanicTaskIssue mechanicTaskIssue) {
    if (mechanicTaskIssue.id != -1) {
      // TODO - no endpoint for edit recommendation
      return;
    }

    if (widget.task.status == MechanicTaskStatus.IN_PROGRESS) {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (_) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter state) {
              return AppointmentDetailsDetailsMechanicTaskIssueModal(
                mechanicTaskIssue: mechanicTaskIssue,
                mechanicTaskIssueAdded: _addMechanicTaskIssue,
              );
            });
          });
    }
  }

  _addMechanicTaskIssue(MechanicTaskIssue mechanicTaskIssue) {
    widget.addMechanicTaskIssue(widget.task, mechanicTaskIssue);
  }
}
