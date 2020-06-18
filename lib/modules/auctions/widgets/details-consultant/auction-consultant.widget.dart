import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/auctions/models/auction-details.model.dart';
import 'package:app/modules/auctions/models/auction.model.dart';
import 'package:app/modules/auctions/models/bid.model.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/authentication/models/jwt-user-details.model.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/work-estimate-form/screens/work-estimate-form.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class AuctionConsultantWidget extends StatefulWidget {
  final Auction auction;
  final AuctionDetail auctionDetails;
  final Function createEstimate;

  AuctionConsultantWidget(
      {this.auction, this.auctionDetails, this.createEstimate});

  @override
  AuctionConsultantWidgetState createState() {
    return AuctionConsultantWidgetState();
  }
}

class AuctionConsultantWidgetState extends State<AuctionConsultantWidget> {
  @override
  Widget build(BuildContext context) {
    bool showIssues = false;

    if (widget.auctionDetails != null &&
        widget.auctionDetails.issues.length > 0) {
      showIssues = true;
    }

    return new Container(
      padding: EdgeInsets.only(left: 20, top: 20, right: 20),
      child: ListView(
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
              if (widget.auctionDetails != null)
                for (ServiceProviderItem serviceItem
                    in widget.auctionDetails.serviceItems)
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
                for (int i = 0; i < widget.auctionDetails.issues.length; i++)
                  _appointmentIssueType(widget.auctionDetails.issues[i], i),
              if (showIssues) _buildSeparator(),
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
                      (widget.auctionDetails != null &&
                              widget.auctionDetails.scheduledDateTime != null)
                          ? widget.auctionDetails.scheduledDateTime
                              .replaceAll(" ", " ${S.of(context).general_at} ")
                          : 'N/A',
                      style: TextHelper.customTextStyle(
                          size: 18),
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
      ),
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

  _seeEstimate(Bid bid) {
    if (bid != null && bid.workEstimateId != 0) {
      Provider.of<WorkEstimateProvider>(context)
          .refreshValues(EstimatorMode.ReadOnly);
      Provider.of<WorkEstimateProvider>(context).workEstimateId =
          bid.workEstimateId;
      Provider.of<WorkEstimateProvider>(context).serviceProviderId =
          bid.serviceProvider.id;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WorkEstimateForm(mode: EstimatorMode.ReadOnly)),
      );
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
              S.of(context).appointment_details_estimator.toUpperCase(),
              style: TextHelper.customTextStyle(color: red, weight: FontWeight.bold, size: 24),
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
        S.of(context).auction_create_estimate.toUpperCase(),
        style: TextHelper.customTextStyle(color: red, weight: FontWeight.bold, size: 24),
      ),
      onPressed: () {
        widget.createEstimate();
      },
    );
  }
}
