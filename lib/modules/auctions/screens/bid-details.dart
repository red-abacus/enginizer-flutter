import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/auctions/providers/auctions-provider.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class BidDetails extends StatefulWidget {
  static const String route = '/auctions/auctionDetails/bidDetails';

  @override
  State<StatefulWidget> createState() {
    return BidDetailsState(route: route);
  }
}

class BidDetailsState extends State<BidDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String route;

  BidDetailsState({this.route});

  AuctionsProvider auctionsProvider;

  @override
  Widget build(BuildContext context) {
    auctionsProvider = Provider.of<AuctionsProvider>(context, listen: false);

    return Consumer<AuctionsProvider>(
      builder: (context, appointmentsProvider, _) => Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
          ),
          body: Column(
            children: <Widget>[
              new Expanded(
                  child: Container(
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: new ListView(
                  padding: EdgeInsets.only(bottom: 60),
                  shrinkWrap: true,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _imageContainer(),
                        _titleContainer(S.of(context).auction_bids_provider),
                        _providerContainer(),
                        _buildSeparator(),
                        _titleContainer(
                            S.of(context).auction_bid_services_provided),
                        _servicesContainer(),
                        _buildSeparator(),
                        _titleContainer(
                            S.of(context).appointment_details_services_issues),
                        _issueContainer(),
                        _buildSeparator(),
                        _titleContainer(S
                            .of(context)
                            .appointment_details_services_appointment_date),
                        _appointmentDateContainer(),
                        _buildSeparator(),
                        _titleContainer(S.of(context).auction_bid_estimate_price),
                        _priceContainer(),
                        _buildButtons(),
                      ],
                    )
                  ],
                ),
              ))
            ],
          )),
    );
  }

  _imageContainer() {
    return Row(
      children: <Widget>[
        Container(
          color: red,
          width: 50,
          height: 50,
          child: Container(
            margin: EdgeInsets.all(8),
            child: SvgPicture.asset(
              'assets/images/statuses/in_bid.svg'.toLowerCase(),
              semanticsLabel: 'Appointment Status Image',
            ),
          ),
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              auctionsProvider.selectedAuction.appointment.name,
              maxLines: 3,
              style:
                  TextHelper.customTextStyle(null, gray3, FontWeight.bold, 16),
            ),
          ),
        ),
      ],
    );
  }

  _providerContainer() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Container(
            width: 16,
            height: 16,
            decoration: new BoxDecoration(
              color: Colors.black,
              borderRadius: new BorderRadius.circular(8),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(
                "Provider name",
                style: TextHelper.customTextStyle(
                    null, Colors.black, FontWeight.bold, 14),
              ),
            ),
          ),
          FlatButton(
            child: Text(
              S.of(context).auction_bid_see_provider_profile.toUpperCase(),
              style: TextHelper.customTextStyle(null, red, FontWeight.bold, 16),
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  _servicesContainer() {
    return Column(
      children: <Widget>[
        _getServiceRow(),
        _getServiceRow(),
        _getServiceRow(),
        _getServiceRow(),
        _getServiceRow(),
      ],
    );
  }

  _getServiceRow() {
    return Container(
        margin: EdgeInsets.only(top: 4),
        child: Row(
          children: <Widget>[
            _getServiceText(),
            _getServiceText(),
          ],
        ));
  }

  _getServiceText() {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(right: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "Servicii auto",
              style: TextHelper.customTextStyle(null, gray, null, 14),
            ),
          ),
          Container(
            width: 30,
            height: 30,
            color: red,
          )
        ],
      ),
    ));
  }

  _issueContainer() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 5),
              child: Column(
                children: <Widget>[
                  for (int i = 0; i < 10; i++) _issueTextWidget(i)
                ],
              ),
            ),
          ),
          FlatButton(
            child: Text(
              S.of(context).auction_bid_estimate.toUpperCase(),
              style: TextHelper.customTextStyle(null, red, FontWeight.bold, 16),
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  _appointmentDateContainer() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Text(
        "15.01.2020 ${S.of(context).general_at} 09:00",
        style:
            TextHelper.customTextStyle(null, Colors.black, FontWeight.bold, 16),
      ),
    );
  }

  _priceContainer() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Text(
        "2000 RON",
        style:
            TextHelper.customTextStyle(null, Colors.black, FontWeight.bold, 16),
      ),
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

  _buildButtons() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: new Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: FlatButton(
              child: Text(
                S.of(context).general_decline.toUpperCase(),
                style:
                    TextHelper.customTextStyle(null, red, FontWeight.bold, 24),
              ),
              onPressed: () {
                _cancelBid();
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
              child: Text(
                S.of(context).general_accept.toUpperCase(),
                style:
                    TextHelper.customTextStyle(null, red, FontWeight.bold, 24),
              ),
              onPressed: () {
                _acceptBid();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _issueTextWidget(int index) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
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
                "Bataie fata stanga",
                style: TextHelper.customTextStyle(null, Colors.black, null, 13),
              ),
            ),
          )
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

  _cancelBid() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).general_warning,
              style:
                  TextHelper.customTextStyle(null, null, FontWeight.bold, 16)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  S.of(context).auction_bid_cancel_description,
                  style: TextHelper.customTextStyle(null, null, null, 16),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(S.of(context).general_no),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(S.of(context).general_yes),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _acceptBid() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).general_warning,
              style:
              TextHelper.customTextStyle(null, null, FontWeight.bold, 16)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  S.of(context).auction_bid_accept_description,
                  style: TextHelper.customTextStyle(null, null, null, 16),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(S.of(context).general_no),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(S.of(context).general_yes),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
