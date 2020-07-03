import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/auctions/models/work-estimate-details.model.dart';
import 'package:app/modules/work-estimate-form/enums/work-estimate-status.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppointmentDetailsConsultantWidget extends StatefulWidget {
  AppointmentDetail appointmentDetail;
  WorkEstimateDetails workEstimateDetails;
  List<ServiceProviderItem> serviceProviderItems;
  final Function declineAppointment;
  final Function createEstimate;
  final Function viewEstimate;
  final Function assignMechanic;
  final Function createPickUpCarForm;
  final Function createHandoverCarForm;
  final Function seeCamera;
  final Function finishAppointment;

  AppointmentDetailsConsultantWidget(
      {this.appointmentDetail,
      this.serviceProviderItems = const [],
      this.declineAppointment,
      this.createEstimate,
      this.viewEstimate,
      this.assignMechanic,
      this.createHandoverCarForm,
      this.createPickUpCarForm,
      this.workEstimateDetails,
      this.seeCamera,
      this.finishAppointment});

  @override
  _AppointmentDetailsConsultantWidgetState createState() {
    return _AppointmentDetailsConsultantWidgetState();
  }
}

class _AppointmentDetailsConsultantWidgetState
    extends State<AppointmentDetailsConsultantWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _content(),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: _buttonsWidget(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _content() {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      margin: EdgeInsets.only(left: 20, right: 20),
      child: ListView(
        padding: EdgeInsets.only(bottom: 80),
        shrinkWrap: true,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      color: widget.appointmentDetail?.status
                          ?.resolveStatusColor(),
                      width: 50,
                      height: 50,
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: SvgPicture.asset(
                          'assets/images/statuses/${widget.appointmentDetail?.status?.assetName()}.svg'
                              .toLowerCase(),
                          semanticsLabel: 'Appointment Status Image',
                        ),
                      )),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "${widget.appointmentDetail?.name ?? 'N/A'}",
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
              if (widget.appointmentDetail.status.getState() ==
                  AppointmentStatusState.SCHEDULED)
                _scheduledSpecificContainer(),
              if (widget.appointmentDetail.status.getState() ==
                  AppointmentStatusState.READY_FOR_PICKUP)
                _readyForPickUpSpecificContainer(),
              if (widget.appointmentDetail.status.getState() ==
                  AppointmentStatusState.IN_WORK)
                _inWorkSpecificContainer(),
              _titleContainer(S.of(context).appointment_details_services_title),
              _servicesContainer(),
              _buildSeparator(),
              _titleContainer(
                  S.of(context).appointment_details_services_issues),
              _issuesContainer(),
              _buildSeparator(),
              if (widget.appointmentDetail.status.getState() ==
                  AppointmentStatusState.IN_WORK)
                _videoFeedContainer(),
              _titleContainer(
                  S.of(context).appointment_details_services_appointment_date),
              _appointmentDateContainer(),
            ],
          )
        ],
      ),
    );
  }

  _buttonsWidget() {
    List<Widget> buttons = [];

    switch (widget.appointmentDetail.status.getState()) {
      case AppointmentStatusState.PENDING:
        buttons.add(FloatingActionButton.extended(
          heroTag: null,
          onPressed: () {
            widget.declineAppointment();
          },
          label: Text(
            S.of(context).general_decline.toUpperCase(),
            style: TextHelper.customTextStyle(
                color: red, weight: FontWeight.bold, size: 16),
          ),
          backgroundColor: Colors.white,
        ));

        if (widget.workEstimateDetails != null &&
            widget.workEstimateDetails.status == WorkEstimateStatus.Rejected) {
          buttons.add(FloatingActionButton.extended(
            heroTag: null,
            onPressed: () {
              widget.createEstimate();
            },
            label: Text(
              S.of(context).auction_create_estimate.toUpperCase(),
              style: TextHelper.customTextStyle(
                  color: red, weight: FontWeight.bold, size: 16),
            ),
            backgroundColor: Colors.white,
          ));
        }
        break;
      case AppointmentStatusState.SUBMITTED:
        buttons.add(FloatingActionButton.extended(
          heroTag: null,
          onPressed: () {
            widget.declineAppointment();
          },
          label: Text(
            S.of(context).general_decline.toUpperCase(),
            style: TextHelper.customTextStyle(
                color: red, weight: FontWeight.bold, size: 16),
          ),
          backgroundColor: Colors.white,
        ));

        buttons.add(FloatingActionButton.extended(
          heroTag: null,
          onPressed: () {
            widget.createEstimate();
          },
          label: Text(
            S.of(context).auction_create_estimate.toUpperCase(),
            style: TextHelper.customTextStyle(
                color: red, weight: FontWeight.bold, size: 16),
          ),
          backgroundColor: Colors.white,
        ));
        break;
      case AppointmentStatusState.IN_REVIEW:
        buttons.add(FloatingActionButton.extended(
          heroTag: 'putInWork',
          onPressed: () {
            // TODO
          },
          label: Text(
            S.of(context).appointment_put_in_work,
            style: TextHelper.customTextStyle(
                color: red, weight: FontWeight.bold, size: 14),
          ),
          backgroundColor: Colors.white,
        ));

        buttons.add(FloatingActionButton.extended(
          heroTag: 'finishAppointment',
          onPressed: () {
            widget.finishAppointment();
          },
          label: Text(
            S.of(context).appointment_finish_appointment,
            style: TextHelper.customTextStyle(
                color: red, weight: FontWeight.bold, size: 14),
          ),
          backgroundColor: Colors.white,
        ));
        break;
      default:
        break;
    }

    if (buttons.length == 0) {
      return Container();
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buttons,
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

    String buttonTitle =
        S.of(context).appointment_details_estimator.toUpperCase();

    if (widget.workEstimateDetails != null &&
        widget.workEstimateDetails.status == WorkEstimateStatus.Rejected) {
      buttonTitle =
          '${S.of(context).appointment_details_estimator.toUpperCase()} (${S.of(context).general_rejected.toUpperCase()})';
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
            onPressed: () => {widget.viewEstimate()},
            child: Text(
              buttonTitle,
              style: TextHelper.customTextStyle(
                  color: red, weight: FontWeight.bold, size: 16),
            ),
          ),
        ],
      ),
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
        style: TextHelper.customTextStyle(
            color: gray2, weight: FontWeight.bold, size: 13),
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
        if (widget.appointmentDetail.serviceItems != null)
          for (ServiceProviderItem item
              in widget.appointmentDetail.serviceItems)
            _getServiceRow(item),
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
                    child: Icon(
                      Icons.check_box,
                      color: red,
                    ),
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
                (widget.appointmentDetail != null &&
                        widget.appointmentDetail.scheduledDate != null)
                    ? widget.appointmentDetail.scheduledDate
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

  _scheduledSpecificContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _titleContainer(S.of(context).mechanic_appointment_receive_form_title),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 20,
                height: 20,
                decoration: new BoxDecoration(
                  color: gray,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    S.of(context).appointment_consultant_no_pick_up_car_form,
                    style: TextHelper.customTextStyle(
                        color: red, weight: FontWeight.bold, size: 15),
                  ),
                ),
              ),
              FlatButton(
                child: Text(
                  S.of(context).general_create.toUpperCase(),
                  style: TextHelper.customTextStyle(
                      color: red, weight: FontWeight.bold, size: 15),
                ),
                onPressed: () {
                  widget.createPickUpCarForm();
                },
              )
            ],
          ),
        ),
        _buildSeparator(),
      ],
    );
  }

  _readyForPickUpSpecificContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _titleContainer(S.of(context).mechanic_appointment_hand_form_title),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 20,
                height: 20,
                decoration: new BoxDecoration(
                  color: gray,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    S.of(context).appointment_consultant_no_handover_car_form,
                    style: TextHelper.customTextStyle(
                        color: red, weight: FontWeight.bold, size: 15),
                  ),
                ),
              ),
              FlatButton(
                child: Text(
                  S.of(context).general_create.toUpperCase(),
                  style: TextHelper.customTextStyle(
                      color: red, weight: FontWeight.bold, size: 15),
                ),
                onPressed: () {
                  widget.createHandoverCarForm();
                },
              )
            ],
          ),
        ),
        _buildSeparator(),
      ],
    );
  }

  _inWorkSpecificContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _titleContainer(S.of(context).appointment_details_assiged_mechanic),
        _mechanicRow(),
        _buildSeparator(),
      ],
    );
  }

  _mechanicRow() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FadeInImage.assetNetwork(
            image: widget.appointmentDetail?.personnel?.profilePhoto ?? '',
            placeholder: 'assets/images/defaults/default_profile_icon.png',
            fit: BoxFit.fitHeight,
            height: 30,
            width: 30,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                widget.appointmentDetail?.personnel?.name ?? '',
                style: TextHelper.customTextStyle(size: 13),
              ),
            ),
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
                        color: red, weight: FontWeight.bold, size: 16),
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
