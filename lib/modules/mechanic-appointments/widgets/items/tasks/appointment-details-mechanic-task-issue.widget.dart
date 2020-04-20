import 'package:app/generated/l10n.dart';
import 'package:app/modules/mechanic-appointments/enums/task-priority.enum.dart';
import 'package:app/modules/mechanic-appointments/widgets/appointment-details-mechanic-task-issue-modal.widget.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsTaskIssueWidget extends StatelessWidget {
  final Issue issue;
  final Function issueAdded;

  AppointmentDetailsTaskIssueWidget({this.issue, this.issueAdded});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 60),
      child: Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: issue.priority == null ? gray_80 : TaskPriorityUtils.color(context, issue.priority),
                offset: Offset(0.5, 0.5),
                blurRadius: 0.5,
              ),
            ],
          ),
          child: Container(
            margin: EdgeInsets.only(left: 30),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(3),
                    bottomRight: Radius.circular(3))),
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _descriptionContainer(context),
                  _imageContainer(),
                  _finishContainer(context),
                ],
              ),
            ),
          )),
    );
  }

  _descriptionContainer(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 6, bottom: 6, right: 10),
        child: Text(issue.name.isEmpty
            ? S.of(context).mechanic_appointment_task_add_recommendation
            : issue.name),
      ),
    );
  }

  _imageContainer() {
    return Align(
        child: GestureDetector(
      child: issue.image != null
          ? Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Image.file(issue.image),
              ),
            )
          : Container(),
    ));
  }

  _finishContainer(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () => _showIssueModal(context),
          child: issue.id == -1
              ? Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                      color: red,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Icon(Icons.add, color: Colors.white),
                )
              : Container(
                  padding:
                      EdgeInsets.only(top: 4, bottom: 4, right: 8, left: 8),
                  margin: EdgeInsets.only(right: 10),
                  color: red,
                  child: Text(
                      S.of(context).mechanic_appointment_task_issue_edit,
                      style: TextHelper.customTextStyle(
                          null, Colors.white, null, 14))),
        ));
  }

  _showIssueModal(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AppointmentDetailsDetailsMechanicTaskIssueModal(
              issue: this.issue,
              issueAdded: this.issueAdded,
            );
          });
        });
  }
}
