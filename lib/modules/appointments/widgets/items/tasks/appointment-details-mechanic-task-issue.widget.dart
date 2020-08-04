import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/enum/task-priority.enum.dart';
import 'package:app/modules/appointments/model/personnel/mechanic-task-issue.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsTaskIssueWidget extends StatelessWidget {
  final MechanicTaskIssue mechanicTaskIssue;
  final Function showMechanicTaskIssueModal;

  AppointmentDetailsTaskIssueWidget(
      {this.mechanicTaskIssue, this.showMechanicTaskIssueModal});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 80),
      child: Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: mechanicTaskIssue.priority == null
                    ? gray_80
                    : TaskPriorityUtils.color(
                        context, mechanicTaskIssue.priority),
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
              child: GestureDetector(
                onTap: () => showMechanicTaskIssueModal(mechanicTaskIssue),
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
              ))),
    );
  }

  _descriptionContainer(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 6, bottom: 6, right: 10),
        child: Text(mechanicTaskIssue.name.isEmpty
            ? S.of(context).mechanic_appointment_task_add_recommendation
            : mechanicTaskIssue.name),
      ),
    );
  }

  _imageContainer() {
    return Align(
        child: GestureDetector(
      child: mechanicTaskIssue.image != null
          ? Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Image.file(mechanicTaskIssue.image),
              ),
            )
          : Container(),
    ));
  }

  _finishContainer(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: mechanicTaskIssue.id == -1
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
              padding: EdgeInsets.only(top: 4, bottom: 4, right: 8, left: 8),
              margin: EdgeInsets.only(right: 10),
              color: red,
              child: Text(
                S.of(context).mechanic_appointment_task_issue_edit,
                style: TextHelper.customTextStyle(color: Colors.white),
              ),
            ),
    );
  }
}
