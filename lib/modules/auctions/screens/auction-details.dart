import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/auctions/enum/auction-details-state.enum.dart';
import 'package:enginizer_flutter/modules/auctions/models/bid.model.dart';
import 'package:enginizer_flutter/modules/auctions/providers/auctions-provider.dart';
import 'package:enginizer_flutter/modules/auctions/screens/bid-details.dart';
import 'package:enginizer_flutter/modules/auctions/widgets/details/auction-appointment-details.widget.dart';
import 'package:enginizer_flutter/modules/auctions/widgets/details/auction-bids.widget.dart';
import 'package:enginizer_flutter/modules/shared/widgets/estimator/estimator-modal.widget.dart';
import 'package:enginizer_flutter/modules/shared/widgets/estimator/models/issue-item-type.model.dart';
import 'package:enginizer_flutter/modules/shared/widgets/estimator/models/issue-item.model.dart';
import 'package:enginizer_flutter/modules/shared/widgets/estimator/models/issue.model.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuctionDetails extends StatefulWidget {
  static const String route = '/auctions/auctionDetails';

  @override
  State<StatefulWidget> createState() {
    return AuctionDetailsState(route: route);
  }
}

class AuctionDetailsState extends State<AuctionDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String route;

  var _initDone = false;
  var _isLoading = false;

  AuctionDetailsScreenState currentState =
      AuctionDetailsScreenState.APPOINTMENT;

  AuctionsProvider auctionsProvider;

  AuctionDetailsState({this.route});

  @override
  Widget build(BuildContext context) {
    auctionsProvider = Provider.of<AuctionsProvider>(context, listen: false);

    return Consumer<AuctionsProvider>(
        builder: (context, appointmentsProvider, _) => Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: _titleText(),
              iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
            ),
            body: _contentWidget()));
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      auctionsProvider = Provider.of<AuctionsProvider>(context, listen: false);

      setState(() {
        _isLoading = true;
      });

      auctionsProvider
          .getAppointmentDetails(
              auctionsProvider.selectedAuction.appointment.id)
          .then((_) {
        auctionsProvider.loadBids().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }
    _initDone = true;
    super.didChangeDependencies();
  }

  _titleText() {
    return Text(
      auctionsProvider.selectedAuction.appointment?.name,
      style:
          TextHelper.customTextStyle(null, Colors.white, FontWeight.bold, 20),
    );
  }

  _contentWidget() {
    return Column(
      children: <Widget>[
        Container(
          child: Container(
            child: _buildTabBar(),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: _buildContent(),
          ),
        )
      ],
    );
  }

  _buildContent() {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : _getContent();
  }

  _getContent() {
    switch (this.currentState) {
      case AuctionDetailsScreenState.APPOINTMENT:
        return AuctionAppointmentDetailsWidget(
            auction: auctionsProvider.selectedAuction,
            appointmentDetail: auctionsProvider.appointmentDetails,
            openEstimator: _openEstimator);
      case AuctionDetailsScreenState.AUCTIONS:
        return AuctionBidsWidget(auction: null, selectBid: _selectBid);
        break;
    }
    return Container();
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 40,
      child: new Row(
        children: <Widget>[
          _buildTabBarButton(AuctionDetailsScreenState.APPOINTMENT),
          _buildTabBarButton(AuctionDetailsScreenState.AUCTIONS)
        ],
      ),
    );
  }

  Widget _buildTabBarButton(AuctionDetailsScreenState state) {
    Color bottomColor = (currentState == state) ? red : gray_80;
    return Expanded(
      flex: 1,
      child: Container(
          child: Center(
            child: FlatButton(
              child: Text(
                stateTitle(state, context),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Lato",
                    color: red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
              onPressed: () {
                setState(() {
                  currentState = state;
                });
              },
            ),
          ),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(width: 1.0, color: bottomColor),
          ))),
    );
  }

  String stateTitle(AuctionDetailsScreenState state, BuildContext context) {
    switch (state) {
      case AuctionDetailsScreenState.APPOINTMENT:
        return S.of(context).auction_details_title;
      case AuctionDetailsScreenState.AUCTIONS:
        return S.of(context).auction_bids_title;
    }
  }

  void _openEstimator(BuildContext ctx) {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            List<Issue> issues = _mockIssues;
            return EstimatorModal(issues: issues);
          });
        });
  }

  _selectBid(Bid bid) {
    auctionsProvider.selectedBid = bid;
    Navigator.of(context).pushNamed(BidDetails.route);
  }

  List<Issue> get _mockIssues {
    return [
      new Issue(id: 1, description: 'Bataie fata stanga', items: [
        new IssueItem(
            id: 1,
            type: new IssueItemType(id: 1, name: 'Service'),
            code: 'KX231',
            name: 'Manopera',
            quantity: 1,
            priceNoVAT: 1000,
            price: 1190),
        new IssueItem(
            id: 2,
            type: new IssueItemType(id: 2, name: 'Product'),
            code: 'MX121',
            name: 'Cap bara',
            quantity: 2,
            priceNoVAT: 200,
            price: 238),
        new IssueItem(
            id: 3,
            type: new IssueItemType(id: 1, name: 'Service'),
            code: 'KX234',
            name: 'Schimbare placute frana',
            quantity: 1,
            priceNoVAT: 600,
            price: 839),
        new IssueItem(
            id: 4,
            type: new IssueItemType(id: 2, name: 'Product'),
            code: 'MX157',
            name: 'Placute frana',
            quantity: 2,
            priceNoVAT: 800,
            price: 1049),
        new IssueItem(
            id: 5,
            type: new IssueItemType(id: 1, name: 'Service'),
            code: 'KX235',
            name: 'Schimbat anvelopa fata stanga',
            quantity: 1,
            priceNoVAT: 1000,
            price: 1190),
        new IssueItem(
            id: 6,
            type: new IssueItemType(id: 2, name: 'Product'),
            code: 'MX183',
            name: 'Anvelopa fata stanga',
            quantity: 1,
            priceNoVAT: 150,
            price: 219)
      ]),
      new Issue(id: 1, description: 'Moare bateria foarte usor', items: [
        new IssueItem(
            id: 1,
            type: new IssueItemType(id: 1, name: 'Service'),
            code: 'KX251',
            name: 'Verificare / schimbare pompa apa',
            quantity: 1,
            priceNoVAT: 300,
            price: 374),
        new IssueItem(
            id: 2,
            type: new IssueItemType(id: 2, name: 'Product'),
            code: 'MX111',
            name: 'Pompa apa',
            quantity: 1,
            priceNoVAT: 180,
            price: 213)
      ]),
      new Issue(id: 1, description: 'Bec marsarier nefunctional', items: [
        new IssueItem(
            id: 1,
            type: new IssueItemType(id: 1, name: 'Service'),
            code: 'KX248',
            name: 'Montare bulb marsarier',
            quantity: 1,
            priceNoVAT: 120,
            price: 143),
        new IssueItem(
            id: 2,
            type: new IssueItemType(id: 2, name: 'Product'),
            code: 'MX148',
            name: 'Bulb marsarier',
            quantity: 1,
            priceNoVAT: 150,
            price: 172)
      ])
    ];
  }
}
