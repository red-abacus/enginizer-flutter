import 'dart:io';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/enum/task-priority.enum.dart';
import 'package:app/modules/appointments/model/personnel/mechanic-task-issue.model.dart';
import 'package:app/modules/shared/widgets/custom-text-form-field.dart';
import 'package:app/modules/shared/widgets/image-picker.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsDetailsMechanicTaskIssueModal extends StatefulWidget {
  final MechanicTaskIssue mechanicTaskIssue;
  final Function mechanicTaskIssueAdded;

  AppointmentDetailsDetailsMechanicTaskIssueModal(
      {this.mechanicTaskIssue, this.mechanicTaskIssueAdded});

  @override
  _AppointmentDetailsDetailsMechanicTaskIssueModalState createState() =>
      _AppointmentDetailsDetailsMechanicTaskIssueModalState();
}

class _AppointmentDetailsDetailsMechanicTaskIssueModalState
    extends State<AppointmentDetailsDetailsMechanicTaskIssueModal> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(5.0),
        child: Container(
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0))),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                  child: Container(
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _descriptionContainer(context),
                    _priorityContainer(context),
                    _bottomContainer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                          color: red,
                          onPressed: () => _setIssueParameters(),
                          child: Text(
                              S
                                  .of(context)
                                  .mechanic_appointment_task_issue_finish,
                              style: TextHelper.customTextStyle(
                                  color: Colors.white))),
                    ),
                  ],
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }

  _setIssueParameters() {
    if (_formKey.currentState.validate()) {
      Navigator.pop(context);
      widget.mechanicTaskIssueAdded(widget.mechanicTaskIssue);
    }
  }

  _descriptionContainer(BuildContext context) {
    return CustomTextFormField(
      labelText: S.of(context).mechanic_appointment_task_add_recommendation,
      errorText:
          S.of(context).mechanic_appointment_task_add_recommendation_error,
      listener: (value) {
        setState(() {
          widget.mechanicTaskIssue.name = value;
        });
      },
      currentValue: widget.mechanicTaskIssue.name,
      validate: true,
      textInputType: TextInputType.text,
    );
  }

  _priorityContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: DropdownButtonFormField(
        validator: (value) {
          if (value == null) {
            return S.of(context).mechanic_appointment_task_add_priority_error;
          } else {
            return null;
          }
        },
        isDense: true,
        value: widget.mechanicTaskIssue.priority,
        hint: Text(S.of(context).mechanic_appointment_task_add_priority),
        items: _priorityDropdownItems(context),
        onChanged: (newValue) {
          setState(() {
            widget.mechanicTaskIssue.priority = newValue;
          });
        },
      ),
    );
  }

  _bottomContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          Container(
            height: 60,
            child: FlatButton(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _imageContainer(),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(Icons.camera_alt, color: red),
                    ),
                  )
                ],
              ),
              onPressed: () {
                showCameraDialog();
              },
            ),
          ),
        ],
      ),
    );
  }

  _imageContainer() {
    return widget.mechanicTaskIssue.image == null
        ? Text(
            S.of(context).mechanic_appointment_task_add_image,
            style: TextHelper.customTextStyle(color: red),
          )
        : Container(
            width: 60,
            height: 60,
            child: Image.file(widget.mechanicTaskIssue.image));
  }

  _priorityDropdownItems(BuildContext context) {
    List<DropdownMenuItem<TaskPriority>> list = [];

    var statuses = [TaskPriority.LOW, TaskPriority.MEDIUM, TaskPriority.HIGH];

    statuses.forEach((status) {
      list.add(DropdownMenuItem(
          value: status,
          child: Text(TaskPriorityUtils.title(context, status))));
    });

    return list;
  }

  showCameraDialog() {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (context) => ImagePickerWidget(imageSelected: _imageSelected));
  }

  _imageSelected(File file) {
    setState(() {
      widget.mechanicTaskIssue.image = file;
    });
  }
}
