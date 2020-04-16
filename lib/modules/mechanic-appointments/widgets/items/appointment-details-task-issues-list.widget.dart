import 'package:app/generated/l10n.dart';
import 'package:app/modules/mechanic-appointments/models/mechanic-task.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/shared/widgets/custom-text-form-field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsTaskIssuesListWidget extends StatelessWidget {
  final MechanicTask mechanicTask;

  final Function addIssue;
  final Function removeIssue;

  AppointmentDetailsTaskIssuesListWidget(
      {this.mechanicTask, this.addIssue, this.removeIssue});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: mechanicTask.issues.length,
        itemBuilder: (context, index) {
          return _buildListTile(context, index, mechanicTask.issues);
        });
  }

  ListTile _buildListTile(BuildContext context, int index, List<Issue> issues) {
    return ListTile(
      title: _tileTextFormField(context, issues[index], _isLastTile(index)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _isLastTile(index)
              ? GestureDetector(
                  onTap: () => addIssue(issues[index]),
                  child: Icon(Icons.add_circle,
                      color: Theme.of(context).accentColor, size: 32))
              : GestureDetector(
                  onTap: () => removeIssue(index),
                  child: Icon(Icons.close,
                      color: Theme.of(context).accentColor, size: 32)),
        ],
      ),
    );
  }

  _tileTextFormField(BuildContext context, Issue issue, bool enabled) {
    return CustomTextFormField(
      labelText: S.of(context).appointment_details_task_add_issue,
      enabled: enabled,
      listener: (value) {
        issue.name = value;
      },
      currentValue: issue.name,
      errorText: S.of(context).appointment_create_error_issueCannotBeEmpty,
      validate: true,
    );
  }

  _isLastTile(int index) {
    return index == mechanicTask.issues.length - 1;
  }
}
