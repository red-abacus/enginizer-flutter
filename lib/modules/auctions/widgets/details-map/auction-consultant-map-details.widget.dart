import 'package:app/generated/l10n.dart';
import 'package:app/modules/auctions/models/auction-map.model.dart';
import 'package:app/modules/auctions/providers/auction-consultant.provider.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class AuctionConsultantMapDetailsWidget extends StatefulWidget {
  final Function showProviderDetails;

  AuctionConsultantMapDetailsWidget({this.showProviderDetails});

  @override
  _AuctionConsultantMapDetailsWidgetState createState() {
    return _AuctionConsultantMapDetailsWidgetState();
  }
}

class _AuctionConsultantMapDetailsWidgetState
    extends State<AuctionConsultantMapDetailsWidget> {
  AuctionConsultantProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<AuctionConsultantProvider>(context);

    return new Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 80, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _carContainer(),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text(
                    S.of(context).appointment_details_applicant,
                    style: TextHelper.customTextStyle(
                        color: gray2, weight: FontWeight.bold, size: 13),
                  ),
                ),
                _applicantContainer(),
                _buildSeparator(),
                for (int i = 0;
                    i < _provider.appointmentDetails.auctionMapDirections.destinationPoints.length;
                    i++)
                  // TODO
                  _markerContainer(
                      _provider.appointmentDetails.auctionMapDirections.destinationPoints[i], i),
                _totalDistanceContainer()
              ],
            ),
          ),
        ],
      ),
    );
  }

  _carContainer() {
    return Row(
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
              _provider.auctionDetails?.car?.registrationNumber ?? 'N/A',
              maxLines: 3,
              style:
                  TextHelper.customTextStyle(color: gray3, weight: FontWeight.bold, size: 16),
            ),
          ),
        ),
      ],
    );
  }

  _applicantContainer() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // TODO - need client image
          Container(
            width: 30,
            height: 30,
            decoration: new BoxDecoration(
              color: red,
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            child: Container(),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                _provider.appointmentDetails?.user?.name ?? 'Client Name',
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

  _markerContainer(AuctionMapLocation point, int i) {
    String logo =
        i > 0 && i < _provider.appointmentDetails.auctionMapDirections.destinationPoints.length - 1
            ? 'marker_gray.svg'
            : 'marker_red.svg';
    String title = i == 0
        ? S.of(context).auction_route_start_point
        : i == _provider.appointmentDetails.auctionMapDirections.destinationPoints.length - 1
            ? S.of(context).auction_route_destination
            : 'Service Provider';

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () {
          if (i > 0 &&
              i < _provider.appointmentDetails.auctionMapDirections.destinationPoints.length - 1) {
            widget.showProviderDetails();
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'assets/images/icons/$logo',
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
    double distanceInKm = _provider.appointmentDetails.auctionMapDirections.totalDistance / 1000;
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Text(
            '${S.of(context).auction_route_total_distance}:',
            style: TextHelper.customTextStyle(color: gray3, weight: FontWeight.bold, size: 16),
          ),
          Text(
            '${distanceInKm.toStringAsFixed(1)} km',
            style: TextHelper.customTextStyle(color: gray3, size: 16),
          ),
        ],
      ),
    );
  }
}
