import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-issue.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskIssuesList extends StatefulWidget {
  final List<AppointmentIssue> issues;

  final Function addIssue;
  final Function removeIssue;

  TaskIssuesList({this.issues = const [], this.addIssue, this.removeIssue});

  @override
  _TaskIssuesListState createState() => _TaskIssuesListState();
}

class _TaskIssuesListState extends State<TaskIssuesList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.issues.length,
        itemBuilder: (context, index) {
          return _buildListTile(context, index, widget.issues);
        });
  }

  ListTile _buildListTile(
      BuildContext context, int index, List<AppointmentIssue> issues) {
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

  _tileTextFormField(AppointmentIssue issue, bool enabled) {
    return TextFormField(
        decoration:
            InputDecoration(labelText: S.of(context).appointment_details_task_add_issue),
        onChanged: (value) {
          setState(() {
            issue.name = value;
          });
        },
        initialValue: issue.name,
        enabled: enabled,
        validator: (value) {
          if (value.isEmpty) {
            return S.of(context).appointment_create_error_issueCannotBeEmpty;
          } else {
            return null;
          }
        });
  }

  _isLastTile(int index) {
    return index == widget.issues.length - 1;
  }
}
