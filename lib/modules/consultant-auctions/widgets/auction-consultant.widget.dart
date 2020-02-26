import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-details.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-issue.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/service-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';
import 'package:enginizer_flutter/modules/auctions/models/auction-details.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/auction.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/bid.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/enums/estimator-mode.enum.dart';
import 'package:enginizer_flutter/modules/auctions/providers/work-estimates.provider.dart';
import 'package:enginizer_flutter/modules/auctions/widgets/estimator/estimator-modal.widget.dart';
import 'package:enginizer_flutter/modules/authentication/models/jwt-user-details.model.dart';
import 'package:enginizer_flutter/modules/authentication/providers/auth.provider.dart';
import 'package:enginizer_flutter/modules/consultant-auctions/providers/create-work-estimate.provider.dart';
import 'package:enginizer_flutter/modules/consultant-auctions/widgets/estimator/create-work-estimate-modal.widget.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class AuctionConsultantWidget extends StatefulWidget {
  final Auction auction;
  final AuctionDetail auctionDetails;
  final Function createBid;

  AuctionConsultantWidget({this.auction, this.auctionDetails, this.createBid});

  @override
  AuctionConsultantWidgetState createState() {
    return AuctionConsultantWidgetState();
  }
}

class AuctionConsultantWidgetState extends State<AuctionConsultantWidget> {
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
            if (widget.auctionDetails != null)
              for (ServiceItem serviceItem
                  in widget.auctionDetails.serviceItems)
                _appointmentServiceItem(serviceItem),
            _buildSeparator(),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                S.of(context).appointment_details_services_issues,
                style: TextHelper.customTextStyle(
                    null, gray2, FontWeight.bold, 13),
              ),
            ),
            if (widget.auctionDetails != null)
              for (int i = 0; i < widget.auctionDetails.issues.length; i++)
                _appointmentIssueType(widget.auctionDetails.issues[i], i),
            _buildSeparator(),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                S.of(context).appointment_details_services_appointment_date,
                style: TextHelper.customTextStyle(
                    null, gray2, FontWeight.bold, 13),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                children: <Widget>[
                  Text(
                    (widget.auctionDetails != null &&
                            widget.auctionDetails.scheduledDateTime != null)
                        ? widget.auctionDetails.scheduledDateTime
                            .replaceAll(" ", " ${S.of(context).general_at} ")
                        : 'N/A',
                    style: TextHelper.customTextStyle(
                        null, Colors.black, null, 18),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: _getEstimateButton(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _appointmentServiceItem(ServiceItem serviceItem) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 4),
            child: Text(
              serviceItem.name,
              style: TextHelper.customTextStyle(null, Colors.black, null, 13),
            ),
          ),
        ),
      ],
    );
  }

  Widget _appointmentIssueType(AppointmentIssue item, int index) {
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

  _createEstimate() {
    if (widget.auctionDetails != null) {
      Provider.of<CreateWorkEstimateProvider>(context)
          .setAuctionDetails(widget.auctionDetails);

      showModalBottomSheet<void>(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter state) {
              return CreateEstimatorModal(createBid: widget.createBid);
            });
          });
    }
  }

  _seeEstimate(Bid bid) {
    if (bid != null && bid.workEstimateId != 0) {
      Provider.of<WorkEstimatesProvider>(context).initValues();
      Provider.of<WorkEstimatesProvider>(context).workEstimateId =
          bid.workEstimateId;

      showModalBottomSheet<void>(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter state) {
              return EstimatorModal(
                mode: EstimatorMode.ReadOnly,
                addIssueItem: null,
                removeIssueItem: null,
              );
            });
          });
    }
  }

  _getEstimateButton() {
    if (widget.auctionDetails != null) {
      JwtUserDetails userDetails = Provider.of<Auth>(context).authUserDetails;

      if (userDetails != null) {
        Bid userBid =
            widget.auctionDetails.getConsultantBid(userDetails.userProvider.id);
        if (userBid != null) {
          return FlatButton(
            child: Text(
              // TODO - need proper translation for english version
              S.of(context).auction_bid_estimate.toUpperCase(),
              style: TextHelper.customTextStyle(null, red, FontWeight.bold, 24),
            ),
            onPressed: () {
              _seeEstimate(userBid);
            },
          );
        }
      }
    }

    return FlatButton(
      child: Text(
        // TODO - need proper translation for english version
        S.of(context).auction_create_estimate.toUpperCase(),
        style: TextHelper.customTextStyle(null, red, FontWeight.bold, 24),
      ),
      onPressed: () {
        _createEstimate();
      },
    );
  }
}
