import 'package:app/generated/l10n.dart';
import 'package:app/modules/auctions/models/auction-details.model.dart';
import 'package:app/modules/auctions/providers/auction-provider.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class AuctionConsultantMapDetailsWidget extends StatefulWidget {
  final AuctionDetail auctionDetails;

  AuctionConsultantMapDetailsWidget({this.auctionDetails});

  @override
  _AuctionConsultantMapDetailsWidgetState createState() {
    return _AuctionConsultantMapDetailsWidgetState();
  }
}

class _AuctionConsultantMapDetailsWidgetState
    extends State<AuctionConsultantMapDetailsWidget> {
  AuctionProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<AuctionProvider>(context);

    return new Container(
      padding: EdgeInsets.only(left: 20, top: 20, right: 20),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _carContainer(),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  S.of(context).appointment_details_applicant,
                  style: TextHelper.customTextStyle(
                      null, gray2, FontWeight.bold, 13),
                ),
              ),
              _applicantContainer(),
              _buildSeparator(),
            ],
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
              widget.auctionDetails?.car?.registrationNumber ?? 'N/A',
//                      ${widget.auction?.status?.name}
              maxLines: 3,
              style:
                  TextHelper.customTextStyle(null, gray3, FontWeight.bold, 16),
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
                _provider.appointmentDetails?.user?.name,
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
}
