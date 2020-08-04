import 'package:app/generated/l10n.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../custom-text-form-field.dart';

class IssuesListWidget extends StatefulWidget {
  List<Issue> issues;
  Function removeIssue;
  Function issueChanged;

  IssuesListWidget(
      {this.issues, this.removeIssue, this.issueChanged});

  @override
  _IssuesListWidgetState createState() => _IssuesListWidgetState();
}

class _IssuesListWidgetState extends State<IssuesListWidget> {
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

  ListTile _buildListTile(BuildContext context, int index, List<Issue> issues) {
    if (issues.length > 1) {
      return ListTile(
        title: _tileTextFormField(issues[index]),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
                onTap: () => widget.removeIssue(index),
                child: Icon(Icons.close, color: Theme.of(context).accentColor)),
          ],
        ),
      );
    } else {
      return ListTile(title: _tileTextFormField(issues[index]));
    }
  }

  _tileTextFormField(Issue issue) {
    return CustomTextFormField(
      labelText: S.of(context).appointment_create_issues,
      listener: (value) {
        issue.name = value;
      },
      currentValue: issue.name,
      errorText: S.of(context).appointment_create_error_issueCannotBeEmpty,
      validate: true,
    );
  }
}
