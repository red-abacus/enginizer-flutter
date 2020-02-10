import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-details.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-type.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/issue-item.model.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppointmentDetailsWidget extends StatefulWidget {
  Appointment appointment;
  AppointmentDetail appointmentDetail;

  AppointmentDetailsWidget({this.appointment, this.appointmentDetail});

  @override
  AppointmentDetailsWidgetState createState() {
    return AppointmentDetailsWidgetState();
  }
}

class AppointmentDetailsWidgetState extends State<AppointmentDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return new ListView(
      shrinkWrap: true,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  color: gray2,
                  width: 50,
                  height: 50,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      'assets/images/statuses/${widget.appointment?.status?.name}.svg'
                          .toLowerCase(),
                      semanticsLabel: 'Appointment Status Image',
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      '${widget.appointment?.car?.brand?.name} ${widget.appointment?.car?.model?.name} - ${widget.appointment?.status?.name}',
                      maxLines: 3,
                      style: TextHelper.customTextStyle(
                          null, gray3, FontWeight.bold, 16),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                S.of(context).appointment_details_services_title,
                style: TextHelper.customTextStyle(
                    null, gray2, FontWeight.bold, 13),
              ),
            ),
            for (AppointmentType type in widget.appointment.appointmentTypes)
              _appointmentTypeText(type),
            _buildSeparator(),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                S.of(context).appointment_details_services_issues,
                style: TextHelper.customTextStyle(
                    null, gray2, FontWeight.bold, 13),
              ),
            ),
            for (int i = 0; i < widget.appointmentDetail.issues.length; i++)
              _appointmentIssueType(widget.appointmentDetail.issues[i], i),
            _buildSeparator(),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                S.of(context).appointment_details_services_appointment_cancel,
                style: TextHelper.customTextStyle(
                    null, gray2, FontWeight.bold, 13),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                children: <Widget>[
                  Text(
                    widget.appointment.scheduleDateTime
                        .replaceAll(" ", " ${S.of(context).general_at} "),
                    style: TextHelper.customTextStyle(
                        null, Colors.black, null, 18),
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _appointmentTypeText(AppointmentType type) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            type.name,
            style: TextHelper.customTextStyle(null, Colors.black, null, 13),
          ),
        )),
      ],
    );
  }

  Widget _appointmentIssueType(IssueItem item, int index) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 20,
            height: 20,
            decoration: new BoxDecoration(
              color: red,
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Center(
              child: Text(
                (index + 1).toString(),
                style: TextHelper.customTextStyle(
                    null, Colors.white, FontWeight.bold, 11),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                item.description,
                style: TextHelper.customTextStyle(null, Colors.black, null, 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 10,
          child: Container(
            margin: EdgeInsets.only(top: 15),
            height: 1,
            color: gray_20,
          ),
        )
      ],
    );
  }
}
