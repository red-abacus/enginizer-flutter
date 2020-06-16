import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppointmentGenericDetailsWidget extends StatefulWidget {
  AppointmentDetail appointmentDetail;

  Function cancelAppointment;
  Function viewEstimate;
  Function seeCamera;

  AppointmentGenericDetailsWidget(
      {this.appointmentDetail,
      this.cancelAppointment,
      this.viewEstimate,
      this.seeCamera});

  @override
  AppointmentGenericDetailsWidgetState createState() {
    return AppointmentGenericDetailsWidgetState();
  }
}

class AppointmentGenericDetailsWidgetState
    extends State<AppointmentGenericDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _content(),
        floatingActionButton: _floatingButtonsContainer(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  _content() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      padding: EdgeInsets.only(top: 20, bottom: 20),
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
                    color: widget.appointmentDetail.status.resolveStatusColor(),
                    width: 50,
                    height: 50,
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: SvgPicture.asset(
                        'assets/images/statuses/${widget.appointmentDetail?.status?.assetName()}.svg'
                            .toLowerCase(),
                        semanticsLabel: 'Appointment Status Image',
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        '${widget.appointmentDetail?.car?.brand?.name} ${widget.appointmentDetail?.car?.model?.name} - ${widget.appointmentDetail?.status?.name}',
                        maxLines: 3,
                        style: TextHelper.customTextStyle(
                            null, gray3, FontWeight.bold, 16),
                      ),
                    ),
                  ),
                ],
              ),
              _titleContainer(S.of(context).appointment_details_services_title),
              for (ServiceProviderItem item in widget.appointmentDetail.serviceItems)
                _serviceItemText(item),
              _buildSeparator(),
              _titleContainer(
                  S.of(context).appointment_details_services_issues),
              _issuesContainer(),
              _buildSeparator(),
              if (widget.appointmentDetail.status.getState() ==
                  AppointmentStatusState.IN_WORK)
                _videoFeedContainer(),
              _titleContainer(_getAppointmentDateTitle(context)),
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  children: <Widget>[
                    Text(
                      widget.appointmentDetail.scheduledDate
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

  _issuesContainer() {
    if (!widget.appointmentDetail.hasWorkEstimate()) {
      return Column(
        children: <Widget>[
          for (int i = 0; i < widget.appointmentDetail.issues.length; i++)
            _appointmentIssueType(widget.appointmentDetail.issues[i], i)
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
                  if (widget.appointmentDetail != null)
                    for (int i = 0;
                        i < widget.appointmentDetail?.issues?.length;
                        i++)
                      _appointmentIssueType(
                          widget.appointmentDetail.issues[i], i)
                ],
              ),
            ),
          ),
          FlatButton(
            splashColor: Theme.of(context).primaryColor,
            onPressed: () => {widget.viewEstimate(widget.appointmentDetail)},
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
    switch (widget.appointmentDetail.status.getState()) {
      case AppointmentStatusState.PENDING:
      case AppointmentStatusState.SCHEDULED:
        return S.of(context).auction_bid_date_schedule;
      default:
        return S.of(context).appointment_details_services_appointment_date;
    }
  }

  Widget _serviceItemText(ServiceProviderItem serviceItem) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            serviceItem.getTranslatedServiceName(context),
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

  _titleContainer(String text) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Text(
        text,
        style: TextHelper.customTextStyle(null, gray2, FontWeight.bold, 13),
      ),
    );
  }

  _floatingButtonsContainer() {
    switch (widget.appointmentDetail.status.getState()) {
      case AppointmentStatusState.SUBMITTED:
        return _getSubmittedFloatingButtons();
      case AppointmentStatusState.PENDING:
        return _getPendingFloatingButtons();
      default:
        return Container();
    }
  }

  Widget _getSubmittedFloatingButtons() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Spacer(),
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () {
              widget.cancelAppointment(widget.appointmentDetail);
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

  Widget _getPendingFloatingButtons() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () {
              widget.cancelAppointment(widget.appointmentDetail);
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
        ],
      ),
    );
  }

  _videoFeedContainer() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _titleContainer(S.of(context).appointment_video_streaming_title),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: FlatButton(
                  splashColor: Theme.of(context).primaryColor,
                  onPressed: () => {widget.seeCamera()},
                  child: Text(
                    S.of(context).appointment_video_button_title.toUpperCase(),
                    style: TextHelper.customTextStyle(
                        null, red, FontWeight.bold, 16),
                  ),
                ),
              )
            ],
          ),
          _buildSeparator()
        ],
      ),
    );
  }
}
