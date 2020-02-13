import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/model/issue-item.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IssuesListWidget extends StatefulWidget {
  List<IssueItem> issues;
  Function removeIssue;
  Function addIssue;
  Function issueChanged;

  IssuesListWidget(
      {this.issues, this.removeIssue, this.addIssue, this.issueChanged});

  @override
  _IssuesListWidgetState createState() => _IssuesListWidgetState();
}

class _IssuesListWidgetState extends State<IssuesListWidget> {
  @override
  Widget build(BuildContext context) {
    var listbox = buildIssuesListBox(context, widget.issues);
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child:
                widget.issues != null ? listbox : CircularProgressIndicator(),
          ),
          FloatingActionButton(
              onPressed: widget.addIssue, child: Icon(Icons.add))
        ],
      ),
    );
  }

  Widget buildIssuesListBox(BuildContext context, List<IssueItem> issues) {
    return ListView.builder(
        itemCount: issues.length,
        itemBuilder: (context, index) {
          return _buildListTile(context, index, issues);
        });
  }

  ListTile _buildListTile(
      BuildContext context, int index, List<IssueItem> issues) {
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
      return ListTile(
          title: _tileTextFormField(issues[index])
      );
    }
  }

  _tileTextFormField(IssueItem issueItem) {
    return TextFormField(
        decoration: InputDecoration(
            labelText: S.of(context).appointment_create_issues),
        onChanged: (value) {
          setState(() {
            issueItem.description = value;
          });
        },
        controller: TextEditingController(text: issueItem.description),
        validator: (value) {
          if (value.isEmpty) {
            return S
                .of(context)
                .appointment_create_error_issueCannotBeEmpty;
          } else {
            return null;
          }
        });
  }
}

class CustomTextFormField extends TextFormField {

}
