
import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppointmentDetailsMechanicWidget extends StatelessWidget {
  final Appointment appointment;
  final AppointmentDetail appointmentDetail;
  final Function viewEstimate;

  AppointmentDetailsMechanicWidget({this.appointment, this.appointmentDetail, this.viewEstimate});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
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
                    color: appointment.status.resolveStatusColor(),
                    width: 50,
                    height: 50,
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: SvgPicture.asset(
                        appointment?.status?.assetName(),
                        semanticsLabel: 'Appointment Status Image',
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        '${appointment?.car?.registrationNumber}',
                        maxLines: 3,
                        style: TextHelper.customTextStyle(
                            color: gray3, weight: FontWeight.bold, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
              _buildTitleContainer(S.of(context).mechanic_appointment_number),
              _defaultTextWidget(appointment?.name),
              _buildSeparator(),
              _buildTitleContainer(S.of(context).appointment_details_applicant),
              _applicantWidget(),
              _buildSeparator(),
              _buildTitleContainer(
                  S.of(context).appointment_details_services_title),
              for (ServiceProviderItem item in appointmentDetail.serviceItems)
                _serviceItemText(item, context),
              _buildSeparator(),
              _buildTitleContainer(
                  S.of(context).appointment_details_services_issues),
              _issuesContainer(context),
              _buildSeparator(),
              _buildTitleContainer(_getAppointmentDateTitle(context)),
              _defaultTextWidget(appointment.scheduleDateTime
                  .replaceAll(" ", " ${S.of(context).general_at} ")),
              _buildSeparator(),
              _buildTitleContainer(S.of(context).mechanic_appointment_mechanic_distributed),
              _buildMechanicWidget(context)
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
            onPressed: () => {
              viewEstimate()
            },
            child: Text(
              S.of(context).appointment_details_estimator.toUpperCase(),
              style: TextHelper.customTextStyle(color: red, weight: FontWeight.bold, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  String _getAppointmentDateTitle(BuildContext context) {
    switch (appointment.status.getState()) {
      case AppointmentStatusState.PENDING:
      case AppointmentStatusState.SCHEDULED:
        return S.of(context).auction_bid_date_schedule;
      default:
        return S.of(context).appointment_details_services_appointment_date;
    }
  }

  _serviceItemText(ServiceProviderItem serviceItem, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.check_box,
            size: 20,
            color: red,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 4),
              child: Text(
                serviceItem.getTranslatedServiceName(context),
                style: TextHelper.customTextStyle(size: 13),
              ),
            ),
          )
        ],
      ),
    );
  }

  _appointmentIssueType(Issue item, int index) {
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
              color: gray3,
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

  _buildSeparator() {
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
        '$text:',
        style: TextHelper.customTextStyle(color: gray3, weight: FontWeight.bold, size: 13),
      ),
    );
  }

  _applicantWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
                color: red,
                borderRadius: new BorderRadius.all(Radius.circular(12))),
            width: 24,
            height: 24,
            child: Container(),
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                '${appointmentDetail.user?.name}',
                maxLines: 3,
                style: TextHelper.customTextStyle(
                    color: gray3, weight: FontWeight.bold, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _defaultTextWidget(String content) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            appointment.name,
            style: TextHelper.customTextStyle(size: 13),
          ),
        )),
      ],
    );
  }

  _buildMechanicWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          FadeInImage.assetNetwork(
            image: appointmentDetail?.personnel?.profilePhoto ?? '',
            placeholder: 'assets/images/defaults/default_profile_icon.png',
            fit: BoxFit.fitHeight,
            height: 24,
            width: 24,
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                appointmentDetail?.personnel?.name ?? '',
                maxLines: 3,
                style: TextHelper.customTextStyle(
                    color: gray3, weight: FontWeight.bold, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
