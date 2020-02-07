import 'package:enginizer_flutter/generated/i18n.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-type.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppointmentDetailsWidget extends StatefulWidget {
  Appointment appointment;

  AppointmentDetailsWidget({this.appointment});

  @override
  AppointmentDetailsWidgetState createState() {
    return AppointmentDetailsWidgetState();
  }
}

class AppointmentDetailsWidgetState extends State<AppointmentDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
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
            margin: EdgeInsets.only(top: 20),
            child: Text(
              S.of(context).appointment_details_services_title,
              style: TextHelper.customTextStyle(null, gray2, null, 13),
            ),
          ),
          for (AppointmentType type in widget.appointment.appointmentTypes)
            _appointmentTypeText(type),
          Row(
            children: <Widget>[
              Expanded(
                flex: 10,
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 1,
                  color: gray_80,
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              S.of(context).appointment_details_services_issues,
              style: TextHelper.customTextStyle(null, gray2, null, 13),
            ),
          ),
        ],
      ),
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
          )
        ),
      ],
    );
  }
}
