import 'package:app/modules/mechanic-appointments/models/mechanic-task.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'appointment-details-mechanic-task-issue.widget.dart';

class AppointmentDetailsMechanicTasksListWidget extends StatelessWidget {
  final MechanicTask mechanicTask;

  final Function addIssue;
  final Function removeIssue;

  AppointmentDetailsMechanicTasksListWidget(
      {this.mechanicTask, this.addIssue, this.removeIssue});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: mechanicTask.issues.length,
        itemBuilder: (context, index) {
          return AppointmentDetailsTaskIssueWidget(issue: mechanicTask.issues[index]);
        });
  }

  _isLastTile(int index) {
    return index == mechanicTask.issues.length - 1;
  }
}