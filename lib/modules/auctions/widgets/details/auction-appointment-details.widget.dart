import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/auctions/models/auction.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AuctionAppointmentDetailsWidget extends StatefulWidget {
  final Auction auction;
  final AppointmentDetail appointmentDetail;

  AuctionAppointmentDetailsWidget({this.auction, this.appointmentDetail});

  @override
  AuctionAppointmentDetailsWidgetState createState() {
    return AuctionAppointmentDetailsWidgetState();
  }
}

class AuctionAppointmentDetailsWidgetState
    extends State<AuctionAppointmentDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    bool showIssues = false;

    if (widget.appointmentDetail != null &&
        widget.appointmentDetail.issues.length > 0) {
      showIssues = true;
    }

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
                  color: red,
                  width: 50,
                  height: 50,
                  child: SvgPicture.asset(
                    'assets/images/statuses/in_bid.svg'.toLowerCase(),
                    semanticsLabel: 'Appointment Status Image',
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      widget.auction?.car?.registrationNumber ?? 'N/A',
//                      ${widget.auction?.status?.name}
                      maxLines: 3,
                      style: TextHelper.customTextStyle(
                          color: gray3, weight: FontWeight.bold, size: 16),
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
                    color: gray2, weight: FontWeight.bold, size: 13),
              ),
            ),
            if (widget.appointmentDetail != null)
              for (ServiceProviderItem serviceItem
                  in widget.appointmentDetail.serviceItems)
                _appointmentServiceItem(serviceItem),
            _buildSeparator(),
            if (showIssues)
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  S.of(context).appointment_details_services_issues,
                  style: TextHelper.customTextStyle(
                      color: gray2, weight: FontWeight.bold, size: 13),
                ),
              ),
            if (showIssues)
              if (widget.appointmentDetail != null)
                for (int i = 0; i < widget.appointmentDetail.issues.length; i++)
                  _appointmentIssueType(widget.appointmentDetail.issues[i], i),
            _buildSeparator(),
            if (showIssues)
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  S.of(context).appointment_details_services_appointment_date,
                  style: TextHelper.customTextStyle(
                      color: gray2, weight: FontWeight.bold, size: 13),
                ),
              ),
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                children: <Widget>[
                  Text(
                    (widget.appointmentDetail != null &&
                            widget.appointmentDetail.scheduledDate != null)
                        ? widget.appointmentDetail.scheduledDate
                            .replaceAll(" ", " ${S.of(context).general_at} ")
                        : 'N/A',
                    style: TextHelper.customTextStyle(
                        size: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _appointmentServiceItem(ServiceProviderItem serviceItem) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 4),
            child: Text(
              serviceItem.getTranslatedServiceName(context),
              style: TextHelper.customTextStyle(size: 13),
            ),
          ),
        ),
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
}
