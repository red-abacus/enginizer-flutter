import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/auctions/enum/bid-status.enum.dart';
import 'package:app/modules/auctions/models/bid.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BidCard extends StatelessWidget {
  final Bid bid;
  final Function selectBid;

  BidCard({this.bid, this.selectBid});

  @override
  Widget build(BuildContext context) {
    double opacity = 1.0;

    if (bid != null && bid.bidStatus() == BidStatus.REJECTED) {
      opacity = 0.6;
    }
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Material(
        elevation: 1,
        color: Colors.white,
        borderRadius: new BorderRadius.circular(5.0),
        child: InkWell(
          splashColor: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          onTap: () => {selectBid(bid)},
          child: ClipRRect(
              borderRadius: new BorderRadius.circular(10.0),
              child: Opacity(
                opacity: opacity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _imageContainer(),
                    _textContainer(context),
                    _detailsContainer(context),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  _imageContainer() {
    return FadeInImage.assetNetwork(
      width: 100,
      height: 100,
      image: bid.serviceProvider?.image,
      placeholder: ServiceProvider.defaultImage(),
      fit: BoxFit.contain,
    );
  }

  _textContainer(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 10),
        height: 120,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text("${bid.serviceProvider?.name}",
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 1.5)),
                Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/images/icons/star_icon.svg',
                      semanticsLabel: 'Review Image',
                      height: 14,
                      width: 14,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        "${bid.serviceProvider?.rating?.value ?? '0'} (${bid.serviceProvider?.rating?.reviews ?? '0'})",
                        style: TextHelper.customTextStyle(null, gray, null, 11),
                      ),
                    ),
                  ],
                ),
                _servicesText(context),
                _priceText(context),
                SizedBox(height: 10),
              ],
            ),
            _dateScheduleContainer(context),
          ],
        ),
      ),
    );
  }

  _detailsContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Text(
        S.of(context).general_details,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: red,
            fontFamily: "Lato"),
      ),
    );
  }

  _servicesText(BuildContext context) {
    String title = "";
    Color color = red;

    if (bid.requestedServicesCount == bid.coveredServicesCount) {
      title =
          "${S.of(context).general_services}: ${S.of(context).auction_bid_all_services}";
      color = green;
    } else if (bid.coveredServicesCount == 0) {
      title =
          "${S.of(context).general_services}: ${S.of(context).auction_bid_no_services}";
    } else {
      String servicesCount = bid.coveredServicesCount == 1
          ? S.of(context).general_service
          : S.of(context).general_services;

      title =
          "${S.of(context).general_services}: ${S.of(context).general_only} ${bid.coveredServicesCount} $servicesCount";

      color = yellow;
    }

    return Text(title,
        style: TextStyle(
            color: color,
            fontFamily: 'Lato',
            fontWeight: FontWeight.normal,
            fontSize: 12.8,
            height: 1.5));
  }

  _priceText(BuildContext context) {
    String text =
        "${S.of(context).general_price}: ${bid.cost} ${S.of(context).general_currency}";
    return Text(text,
        style: TextStyle(
            color: gray,
            fontFamily: 'Lato',
            fontWeight: FontWeight.normal,
            fontSize: 10,
            height: 1.5));
  }

  _dateScheduleContainer(BuildContext context) {
    if (bid.bidStatus() == BidStatus.REJECTED) {
      return Positioned(
        child: Align(
            alignment: FractionalOffset.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(S.of(context).general_rejected.toUpperCase(),
                  style: TextStyle(
                      color: red,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      height: 1.5)),
            )),
      );
    }

    DateTime acceptedDate = bid.getAcceptedDate();

    String dateString = (acceptedDate != null)
        ? DateUtils.stringFromDate(acceptedDate, "dd.MM.yyyy")
        : "";
    String timeString = (acceptedDate != null)
        ? DateUtils.stringFromDate(acceptedDate, "HH:mm")
        : "";

    String title =
        "${S.of(context).auction_bid_date_schedule}: $dateString ${S.of(context).general_at} $timeString";

    return Positioned(
      child: Align(
          alignment: FractionalOffset.bottomLeft,
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(title,
                style: TextStyle(
                    color: gray,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.normal,
                    fontSize: 10,
                    height: 1.5)),
          )),
    );
  }
}
