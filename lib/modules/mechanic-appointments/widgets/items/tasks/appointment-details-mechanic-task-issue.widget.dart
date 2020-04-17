import 'package:app/generated/l10n.dart';
import 'package:app/modules/mechanic-appointments/widgets/appointment-details-mechanic-task-issue-modal.widget.dart';
import 'package:app/modules/shared/widgets/custom-text-form-field.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsTaskIssueWidget extends StatelessWidget {
  final Issue issue;

  AppointmentDetailsTaskIssueWidget({this.issue});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: gray_80,
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
                topRight: Radius.circular(8), bottomRight: Radius.circular(8))),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _descriptionContainer(context),
            _imageContainer(),
            _finishContainer(context),
          ],
        ),
      ),
    );
  }

  _descriptionContainer(BuildContext context) {
    return Expanded(
      child: CustomTextFormField(
        labelText: S.of(context).estimator_percent,
        listener: (value) {
        },
        currentValue: '',
        errorText: S.of(context).estimator_percent_warning,
        validate: true,
        textInputType: TextInputType.number,
      ),
    );
  }

  _imageContainer() {
    return Align(
        child: GestureDetector(
      child: Icon(Icons.camera_alt, color: red),
    ));
  }

  _finishContainer(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
          margin: EdgeInsets.only(left: 10),
          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          decoration: BoxDecoration(
            color: red,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: GestureDetector(
              onTap: () => _showIssueModal(context),
            child: Text(
              S.of(context).mechanic_appointment_task_issue_finish,
              style: TextHelper.customTextStyle(
                  null, Colors.white, FontWeight.normal, 14),
            ),
          )),
    );
  }

  _showIssueModal(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return StatefulBuilder(builder:
              (BuildContext context, StateSetter state) {
            return AppointmentDetailsDetailsMechanicTaskIssueModal(issue: this.issue);
          });
        });
  }
}
