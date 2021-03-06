import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/auctions/models/auction-map.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppointmentDetailsChildrenWidget extends StatefulWidget {
  final AppointmentDetail appointmentDetail;
  final Function showProviderDetails;
  final Function showMap;
  final Function seeEstimate;

  AppointmentDetailsChildrenWidget(
      {this.appointmentDetail,
      this.showProviderDetails,
      this.showMap,
      this.seeEstimate});

  @override
  _AppointmentDetailsChildrenWidgetState createState() {
    return _AppointmentDetailsChildrenWidgetState();
  }
}

class _AppointmentDetailsChildrenWidgetState
    extends State<AppointmentDetailsChildrenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _content(),
      floatingActionButton: Container(
        child: _floatingButtonsContainer(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _content() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: new ListView(
        padding: EdgeInsets.only(bottom: 60, top: 20),
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
                        widget.appointmentDetail?.status?.assetName(),
                        semanticsLabel: 'Appointment Status Image',
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.appointmentDetail.name ?? '',
                            style: TextHelper.customTextStyle(
                                color: gray3,
                                weight: FontWeight.bold,
                                size: 16),
                          ),
                          Text(
                            '${AppointmentStatusStateUtils.title(context, widget.appointmentDetail?.status?.getState())}',
                            maxLines: 3,
                            style: TextHelper.customTextStyle(
                                color: gray3,
                                weight: FontWeight.bold,
                                size: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              _providerContainer(),
              _buildSeparator(),
              _titleContainer(S.of(context).appointment_details_services_title),
              _issuesContainer(),
              _buildSeparator(),
              _titleContainer(S.of(context).auction_route_title),
              _directionsContainer(),
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
                      style: TextHelper.customTextStyle(size: 18),
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

  _providerContainer() {
    return widget.appointmentDetail.serviceProvider != null
        ? Container(
            margin: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FadeInImage.assetNetwork(
                  width: 50,
                  height: 50,
                  image: widget.appointmentDetail?.serviceProvider?.image ?? '',
                  // TODO - need to ask image from API
                  placeholder: ServiceProvider.defaultImage(),
                  fit: BoxFit.contain,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      '${widget.appointmentDetail?.serviceProvider?.name}',
                      style: TextHelper.customTextStyle(
                          color: gray3, weight: FontWeight.bold, size: 16),
                    ),
                  ),
                ),
                FlatButton(
                  splashColor: Theme.of(context).primaryColor,
                  onPressed: () => {
                    widget.showProviderDetails(
                        widget.appointmentDetail.serviceProvider.id)
                  },
                  child: Text(
                    S.of(context).general_details.toUpperCase(),
                    style: TextHelper.customTextStyle(
                        color: red, weight: FontWeight.bold, size: 16),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  _directionsContainer() {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                children: <Widget>[
                  if (widget.appointmentDetail != null)
                    for (int i = 0;
                        i <
                            widget.appointmentDetail.auctionMapDirections
                                .destinationPoints.length;
                        i++)
                      _markerContainer(
                          widget.appointmentDetail.auctionMapDirections
                              .destinationPoints[i],
                          i),
                  _totalDistanceContainer()
                ],
              ),
            ),
          ),
          FlatButton(
            splashColor: Theme.of(context).primaryColor,
            onPressed: () => {widget.showMap(widget.appointmentDetail)},
            child: Text(
              S.of(context).general_map.toUpperCase(),
              style: TextHelper.customTextStyle(
                  color: red, weight: FontWeight.bold, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  _markerContainer(AuctionMapLocation point, int i) {
    String title = i == 0
        ? S.of(context).auction_route_start_point
        : i ==
                widget.appointmentDetail.auctionMapDirections.destinationPoints
                        .length -
                    1
            ? S.of(context).auction_route_destination
            : 'Service Provider';

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () {
          if (i > 0 &&
              i <
                  widget.appointmentDetail.auctionMapDirections
                          .destinationPoints.length -
                      1) {
//            widget.showProviderDetails();
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'assets/images/icons/marker_red.svg',
              width: 24,
              height: 24,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '$title:',
                      style: TextHelper.customTextStyle(
                          color: gray3, weight: FontWeight.bold),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        point.address,
                        style: TextHelper.customTextStyle(
                            color: gray3, weight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      child: Text(
                        point.dateTime != null
                            ? DateUtils.stringFromDate(
                                point.dateTime, 'dd.MM.yyyy')
                            : '',
                        style: TextHelper.customTextStyle(
                            color: gray3, weight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      child: Text(
                        point.dateTime != null
                            ? DateUtils.stringFromDate(point.dateTime, 'HH:mm')
                            : '',
                        style: TextHelper.customTextStyle(
                            color: gray3, weight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _totalDistanceContainer() {
    double distanceInKm =
        widget.appointmentDetail.auctionMapDirections.totalDistance / 1000;
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Text(
            '${S.of(context).auction_route_total_distance}:',
            style: TextHelper.customTextStyle(
                color: gray3, weight: FontWeight.bold, size: 16),
          ),
          Text(
            '${distanceInKm.toStringAsFixed(1)} km',
            style: TextHelper.customTextStyle(color: gray3, size: 16),
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

  Widget _generalTitleContent(String title) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            title,
            style: TextHelper.customTextStyle(size: 13),
          ),
        )),
      ],
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
        style: TextHelper.customTextStyle(
            color: gray2, weight: FontWeight.bold, size: 13),
      ),
    );
  }

  Widget _getSubmittedFloatingButtons() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Spacer(),
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () {
//              widget.cancelAppointment(widget.appointmentDetail);
            },
            label: Text(
              S
                  .of(context)
                  .appointment_details_services_appointment_cancel
                  .toUpperCase(),
              style: TextHelper.customTextStyle(
                  color: red, weight: FontWeight.bold, size: 20),
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
//              widget.cancelAppointment(widget.appointmentDetail);
            },
            label: Text(
              S
                  .of(context)
                  .appointment_details_services_appointment_cancel
                  .toUpperCase(),
              style: TextHelper.customTextStyle(
                  color: red, weight: FontWeight.bold, size: 20),
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
                  onPressed: () => {},
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

  _issuesContainer() {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                children: <Widget>[
                  for (ServiceProviderItem item
                      in widget.appointmentDetail.serviceItems)
                    _generalTitleContent(
                        item.getTranslatedServiceName(context)),
                ],
              ),
            ),
          ),
          if (widget.appointmentDetail.hasWorkEstimate())
            FlatButton(
              splashColor: Theme.of(context).primaryColor,
              onPressed: () => {widget.seeEstimate(widget.appointmentDetail)},
              child: Text(
                S.of(context).appointment_details_estimator.toUpperCase(),
                style: TextHelper.customTextStyle(
                    color: red, weight: FontWeight.bold, size: 16),
              ),
            ),
        ],
      ),
    );
  }
}
