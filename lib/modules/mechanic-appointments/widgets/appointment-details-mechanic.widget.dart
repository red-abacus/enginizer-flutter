import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/model/service-item.model.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppointmentDetailsMechanicWidget extends StatelessWidget {
  final Appointment appointment;
  AppointmentDetail appointmentDetail;

  AppointmentDetailsMechanicWidget({this.appointment, this.appointmentDetail});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    color: appointment.resolveStatusColor(),
                    width: 50,
                    height: 50,
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: SvgPicture.asset(
                        'assets/images/statuses/${appointment?.assetName()}.svg'
                            .toLowerCase(),
                        semanticsLabel: 'Appointment Status Image',
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        '${appointment?.car?.brand?.name} ${appointment?.car?.model?.name} - ${appointment?.status?.name}',
                        maxLines: 3,
                        style: TextHelper.customTextStyle(
                            null, gray3, FontWeight.bold, 16),
                      ),
                    ),
                  ),
                ],
              ),
              _buildTitleContainer(
                  S.of(context).appointment_details_services_title),
              for (ServiceItem item in appointmentDetail.serviceItems)
                _serviceItemText(item),
              _buildSeparator(),
              _buildTitleContainer(
                  S.of(context).appointment_details_services_issues),
              _issuesContainer(context),
              _buildSeparator(),
              _buildTitleContainer(_getAppointmentDateTitle(context)),
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  children: <Widget>[
                    Text(
                      appointment.scheduleDateTime
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
      ),
    );
  }

  _issuesContainer(BuildContext context) {
    if (!appointmentDetail.hasWorkEstimate()) {
      return Column(
        children: <Widget>[
          for (int i = 0; i < appointmentDetail.issues.length; i++)
            _appointmentIssueType(appointmentDetail.issues[i], i)
        ],
      );
    }

    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                children: <Widget>[
                  if (appointmentDetail != null)
                    for (int i = 0; i < appointmentDetail?.issues?.length; i++)
                      _appointmentIssueType(appointmentDetail.issues[i], i)
                ],
              ),
            ),
          ),
          FlatButton(
            splashColor: Theme.of(context).primaryColor,
            onPressed: () => {},
            child: Text(
              S.of(context).appointment_details_estimator.toUpperCase(),
              style: TextHelper.customTextStyle(null, red, FontWeight.bold, 16),
            ),
          ),
        ],
      ),
    );
  }

  String _getAppointmentDateTitle(BuildContext context) {
    switch (appointment.getState()) {
      case AppointmentStatusState.PENDING:
      case AppointmentStatusState.SCHEDULED:
        return S.of(context).auction_bid_date_schedule;
      default:
        return S.of(context).appointment_details_services_appointment_date;
    }
  }

  Widget _serviceItemText(ServiceItem serviceItem) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            serviceItem.name,
            style: TextHelper.customTextStyle(null, Colors.black, null, 13),
          ),
        )),
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
                    null, Colors.white, FontWeight.bold, 11),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                item.name,
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

  _buildTitleContainer(String text) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Text(
        text,
        style: TextHelper.customTextStyle(null, gray2, FontWeight.bold, 13),
      ),
    );
  }

  _floatingButtonsContainer(BuildContext context) {
    switch (appointment.getState()) {
      case AppointmentStatusState.SUBMITTED:
        return _getSubmittedFloatingButtons(context);
      case AppointmentStatusState.PENDING:
        return _getPendingFloatingButtons(context);
      default:
        return Container();
    }
  }

  Widget _getSubmittedFloatingButtons(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Spacer(),
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () {

            },
            label: Text(
              S
                  .of(context)
                  .appointment_details_services_appointment_cancel
                  .toUpperCase(),
              style: TextHelper.customTextStyle(null, red, FontWeight.bold, 20),
            ),
            backgroundColor: Colors.white,
          )
        ],
      ),
    );
  }

  Widget _getPendingFloatingButtons(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () {
            },
            label: Text(
              S
                  .of(context)
                  .appointment_details_services_appointment_cancel
                  .toUpperCase(),
              style: TextHelper.customTextStyle(null, red, FontWeight.bold, 20),
            ),
            backgroundColor: Colors.white,
          ),
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () {
            },
            label: Text(
              S.of(context).general_accept.toUpperCase(),
              style: TextHelper.customTextStyle(null, red, FontWeight.bold, 20),
            ),
            backgroundColor: Colors.white,
          )
        ],
      ),
    );
  }
}
