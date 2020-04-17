import 'package:app/generated/l10n.dart';
import 'package:app/modules/mechanic-appointments/enums/mechanic-task-state.enum.dart';
import 'package:app/modules/mechanic-appointments/models/mechanic-task.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'appointment-details-mechanic-task-issue.widget.dart';

class AppointmentDetailsMechanicTaskSectionWidget extends StatefulWidget {
  final MechanicTask task;
  final int index;

  AppointmentDetailsMechanicTaskSectionWidget({this.task, this.index});

  @override
  _AppointmentDetailsMechanicTaskSectionWidgetState createState() {
    return _AppointmentDetailsMechanicTaskSectionWidgetState();
  }
}

class _AppointmentDetailsMechanicTaskSectionWidgetState
    extends State<AppointmentDetailsMechanicTaskSectionWidget> {
  bool _bestTimeActivated = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _numberContainer(),
              _titleWidget(),
              _timerWidget(),
              _bestTimeWidget(),
            ],
          ),
          _issuesContainer(),
        ],
      ),
    );
  }

  _issuesContainer() {
    return widget.task.state == MechanicTaskState.SELECTED
        ? ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.task.issues.length,
            itemBuilder: (context, index) {
              return AppointmentDetailsTaskIssueWidget(
                issue: widget.task.issues[index],
                issueAdded: _issueAdded,
              );
            })
        : Container();
  }

  _titleWidget() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 6),
        child: Text(
            (widget.task.name?.isNotEmpty ?? false)
                ? widget.task.translatedName(context)
                : 'N/A',
            style: TextStyle(
                color: Colors.black87,
                decoration: widget.task.completed
                    ? TextDecoration.lineThrough
                    : TextDecoration.none)),
      ),
    );
  }

  _timerWidget() {
    return Align(
      alignment: Alignment.topRight,
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(5.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          color: gray,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '00:00:00',
//    '$hoursStr:$minutesStr:$secondsStr',
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
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(left: 4),
        width: 60,
        child: !_bestTimeActivated
            ? GestureDetector(
                child: Icon(Icons.timer, color: gray),
                onTap: () => _showBestTime())
            : Text(
                '${S.of(context).mechanic_appointment_tasks_best_time_title}: 05:00',
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
    switch (widget.task.state) {
      case MechanicTaskState.SELECTED:
        return red;
      case MechanicTaskState.FINISHED:
        return green;
      case MechanicTaskState.NOT_SELECTED:
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

  _issueAdded(Issue issue) {
    setState(() {
      widget.task.state = MechanicTaskState.SELECTED;
      widget.task.issues.add(Issue(id: -1, name: ''));
    });
  }
}
