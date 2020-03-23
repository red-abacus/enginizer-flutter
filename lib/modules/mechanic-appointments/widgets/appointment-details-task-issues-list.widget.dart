import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/models/issue.model.dart';
import 'package:enginizer_flutter/modules/shared/widgets/custom-text-form-field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsTaskIssuesList extends StatefulWidget {
  final List<Issue> issues;

  final Function addIssue;
  final Function removeIssue;

  AppointmentDetailsTaskIssuesList(
      {this.issues = const [], this.addIssue, this.removeIssue});

  @override
  _AppointmentDetailsTaskIssuesListState createState() =>
      _AppointmentDetailsTaskIssuesListState();
}

class _AppointmentDetailsTaskIssuesListState
    extends State<AppointmentDetailsTaskIssuesList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.issues.length,
        itemBuilder: (context, index) {
          return _buildListTile(context, index, widget.issues);
        });
  }

  ListTile _buildListTile(
      BuildContext context, int index, List<Issue> issues) {
    return ListTile(
      title: _tileTextFormField(issues[index], _isLastTile(index)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _isLastTile(index)
              ? GestureDetector(
                  onTap: () => widget.addIssue(issues[index]),
                  child: Icon(Icons.add_circle,
                      color: Theme.of(context).accentColor, size: 32))
              : GestureDetector(
                  onTap: () => widget.removeIssue(index),
                  child: Icon(Icons.close,
                      color: Theme.of(context).accentColor, size: 32)),
        ],
      ),
    );
  }

  _tileTextFormField(Issue issue, bool enabled) {
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
    return index == widget.issues.length - 1;
  }
}
