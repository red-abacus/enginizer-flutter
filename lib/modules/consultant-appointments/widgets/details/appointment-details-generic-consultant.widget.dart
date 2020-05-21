import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/service-item.model.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/auctions/models/work-estimate-details.model.dart';
import 'package:app/modules/work-estimate-form/enums/work-estimate-status.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppointmentDetailsGenericConsultantWidget extends StatefulWidget {
  AppointmentDetail appointmentDetail;
  WorkEstimateDetails workEstimateDetails;
  List<ServiceItem> serviceItems;
  List<ServiceProviderItem> serviceProviderItems;
  final Function declineAppointment;
  final Function createEstimate;
  final Function viewEstimate;
  final Function assignMechanic;
  final Function createPickUpCarForm;
  final Function requestPartsProvider;

  AppointmentDetailsGenericConsultantWidget(
      {this.appointmentDetail,
      this.serviceItems = const [],
      this.serviceProviderItems = const [],
      this.declineAppointment,
      this.createEstimate,
      this.viewEstimate,
      this.assignMechanic,
      this.createPickUpCarForm,
      this.workEstimateDetails,
      this.requestPartsProvider});

  @override
  AppointmentDetailsGenericConsultantWidgetState createState() {
    return AppointmentDetailsGenericConsultantWidgetState();
  }
}

class AppointmentDetailsGenericConsultantWidgetState
    extends State<AppointmentDetailsGenericConsultantWidget> {
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
                            null, gray3, FontWeight.bold, 16),
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
                  AppointmentStatusState.IN_WORK)
                _inWorkSpecificContainer(),
              _titleContainer(S.of(context).appointment_details_services_title),
              _servicesContainer(),
              _buildSeparator(),
              _titleContainer(
                  S.of(context).appointment_details_services_issues),
              _issuesContainer(),
              _buildSeparator(),
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
            style: TextHelper.customTextStyle(null, red, FontWeight.bold, 16),
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
              style: TextHelper.customTextStyle(null, red, FontWeight.bold, 16),
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
            style: TextHelper.customTextStyle(null, red, FontWeight.bold, 16),
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
            style: TextHelper.customTextStyle(null, red, FontWeight.bold, 16),
          ),
          backgroundColor: Colors.white,
        ));
        break;
      case AppointmentStatusState.SCHEDULED:
      case AppointmentStatusState.IN_UNIT:
      case AppointmentStatusState.IN_WORK:
      case AppointmentStatusState.ON_HOLD:
        buttons.add(FloatingActionButton.extended(
          heroTag: null,
          onPressed: () {
            widget.requestPartsProvider();
          },
          label: Text(
            S.of(context).appointment_request_items.toUpperCase(),
            style: TextHelper.customTextStyle(null, red, FontWeight.bold, 16),
          ),
          backgroundColor: Colors.white,
        ));
        break;
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
              style: TextHelper.customTextStyle(null, red, FontWeight.bold, 16),
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
      margin: EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: TextHelper.customTextStyle(null, gray2, FontWeight.bold, 13),
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
                style: TextHelper.customTextStyle(null, Colors.black, null, 13),
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
          for (ServiceItem item in widget.serviceItems) _getServiceRow(item),
      ],
    );
  }

  _getServiceRow(ServiceItem item) {
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
                      style: TextHelper.customTextStyle(
                          null, Colors.black, null, 14),
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
                style: TextHelper.customTextStyle(null, Colors.black, null, 18),
              ),
            ),
          ),
          _requestReprogrammingButton(),
        ],
      ),
    );
  }

  _requestReprogrammingButton() {
    if (widget.appointmentDetail.status.getState() ==
        AppointmentStatusState.CANCELED) {
      return Container();
    }

    return FlatButton(
      child: Text(
        "(${S.of(context).appointment_details_request_reprogramming.toLowerCase()})",
        style: TextHelper.customTextStyle(null, red, FontWeight.bold, 12),
      ),
      onPressed: () {
        widget.viewEstimate();
      },
    );
  }

  _scheduledSpecificContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _titleContainer(S.of(context).mechanic_appointment_receive_form_title),
        _pickUpCarForm(),
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
                // TODO - need to add icon for mechanic
                ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                // TODO - need to add mechanic name
                'Mechanic name',
                style: TextHelper.customTextStyle(null, Colors.black, null, 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _pickUpCarForm() {
    return Container(
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
                // TODO - need proper translation
                S.of(context).appointment_consultant_no_pick_up_car_form,
                style:
                    TextHelper.customTextStyle(null, red, FontWeight.bold, 15),
              ),
            ),
          ),
          FlatButton(
            child: Text(
              S.of(context).general_create.toUpperCase(),
              style: TextHelper.customTextStyle(null, red, FontWeight.bold, 15),
            ),
            onPressed: () {
              widget.createPickUpCarForm();
            },
          )
        ],
      ),
    );
  }
}
