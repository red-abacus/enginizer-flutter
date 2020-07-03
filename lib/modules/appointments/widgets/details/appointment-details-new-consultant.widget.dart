import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppointmentDetailsNewConsultantWidget extends StatefulWidget {
  Appointment appointment;
  AppointmentDetail appointmentDetail;
  List<ServiceProviderItem> serviceItems;
  List<ServiceProviderItem> serviceProviderItems;

  AppointmentDetailsNewConsultantWidget(
      {this.appointment,
      this.appointmentDetail,
      this.serviceItems = const [],
      this.serviceProviderItems = const []});

  @override
  AppointmentDetailsNewConsultantWidgetState createState() {
    return AppointmentDetailsNewConsultantWidgetState();
  }
}

class AppointmentDetailsNewConsultantWidgetState
    extends State<AppointmentDetailsNewConsultantWidget> {
  @override
  Widget build(BuildContext context) {
    return new ListView(
      padding: EdgeInsets.only(bottom: 60),
      shrinkWrap: true,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                    color: widget.appointment?.status.resolveStatusColor(),
                    width: 50,
                    height: 50,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      child: SvgPicture.asset(
                        'assets/images/statuses/${widget.appointment?.status?.name}.svg'
                            .toLowerCase(),
                        semanticsLabel: 'Appointment Status Image',
                      ),
                    )),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "${widget.appointment?.name ?? 'N/A'}",
                      maxLines: 3,
                      style: TextHelper.customTextStyle(
                          color: gray3, weight: FontWeight.bold, size: 16),
                    ),
                  ),
                ),
              ],
            ),
            _titleContainer(S.of(context).appointment_details_applicant),
            _applicantContainer(),
            _buildSeparator(),
            _titleContainer(S.of(context).appointment_details_services_title),
            _servicesContainer(),
            _buildSeparator(),
            _titleContainer(S.of(context).appointment_details_services_issues),
            if (widget.appointmentDetail != null)
              for (int i = 0; i < widget.appointmentDetail.issues.length; i++)
                _appointmentIssueType(widget.appointmentDetail.issues[i], i),
            _buildSeparator(),
            _titleContainer(
                S.of(context).appointment_details_services_appointment_date),
            _appointmentDateContainer(),
            _buildButtons()
          ],
        )
      ],
    );
  }

  Widget _appointmentIssueType(Issue item, int index) {
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
                    color: Colors.white, weight: FontWeight.bold, size: 11),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                item.name,
                style: TextHelper.customTextStyle(size: 13),
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

  _titleContainer(String text) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: TextHelper.customTextStyle(color: gray2, weight: FontWeight.bold, size: 13),
      ),
    );
  }

  _applicantContainer() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 30,
            height: 30,
            decoration: new BoxDecoration(
              color: red,
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            child: Container(
                // TODO - need to add icon for user
                ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                "${widget.appointmentDetail?.user?.name ?? "N/A"}",
                style: TextHelper.customTextStyle(size: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _servicesContainer() {
    return Column(
      children: <Widget>[
        if (widget.serviceItems != null)
          for (ServiceProviderItem item in widget.serviceItems) _getServiceRow(item),
      ],
    );
  }

  _getServiceRow(ServiceProviderItem item) {
    return Container(
        margin: EdgeInsets.only(top: 4),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      item.name,
                      style: TextHelper.customTextStyle(),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    color: red,
                  )
                ],
              ),
            ))
          ],
        ));
  }

  _appointmentDateContainer() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(
                (widget.appointment != null &&
                        widget.appointment.scheduleDateTime != null)
                    ? widget.appointment.scheduleDateTime
                        .replaceAll(" ", " ${S.of(context).general_at} ")
                    : 'N/A',
                style: TextHelper.customTextStyle(size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildButtons() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: new Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: FlatButton(
              child: Text(
                S.of(context).general_decline.toUpperCase(),
                style:
                    TextHelper.customTextStyle(color: red, weight: FontWeight.bold, size: 24),
              ),
              onPressed: () {},
            ),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
              child: Text(
                S.of(context).general_estimator.toUpperCase(),
                style:
                    TextHelper.customTextStyle(color: red, weight: FontWeight.bold, size: 24),
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
