import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/auctions/enum/auction-details-state.enum.dart';
import 'package:enginizer_flutter/modules/auctions/models/bid.model.dart';
import 'package:enginizer_flutter/modules/auctions/providers/auction-provider.dart';
import 'package:enginizer_flutter/modules/auctions/screens/bid-details.dart';
import 'package:enginizer_flutter/modules/auctions/widgets/details/auction-appointment-details.widget.dart';
import 'package:enginizer_flutter/modules/auctions/widgets/details/auction-bids.widget.dart';
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

  AuctionDetailsState({this.route});

  @override
  Widget build(BuildContext context) {
    _isLoading = Provider.of<AuctionProvider>(context).isLoading;

    return Consumer<AuctionProvider>(
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
    _isLoading = Provider.of<AuctionProvider>(context).isLoading;
    _initDone = Provider.of<AuctionProvider>(context).initDone;

    if (!_initDone) {
      AuctionProvider auctionProvider = Provider.of<AuctionProvider>(context);

      setState(() {
        Provider.of<AuctionProvider>(context, listen: false).isLoading = true;
      });

      auctionProvider
          .getAppointmentDetails(auctionProvider.selectedAuction.appointment.id)
          .then((_) {
        auctionProvider.loadBids(auctionProvider.selectedAuction.id).then((_) {
          setState(() {
            Provider.of<AuctionProvider>(context, listen: false).isLoading = false;
          });
        });
      });
    }

    Provider.of<AuctionProvider>(context, listen: false).initDone = true;
    super.didChangeDependencies();
  }

  _titleText() {
    return Text(
      Provider.of<AuctionProvider>(context).selectedAuction.appointment?.name,
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
    AuctionProvider auctionProvider = Provider.of<AuctionProvider>(context);

    switch (this.currentState) {
      case AuctionDetailsScreenState.APPOINTMENT:
        return AuctionAppointmentDetailsWidget(
            auction: auctionProvider.selectedAuction,
            appointmentDetail: auctionProvider.appointmentDetails);
      case AuctionDetailsScreenState.AUCTIONS:
        return AuctionBidsWidget(
            bids: auctionProvider.bids,
            filterSearchString: auctionProvider.filterSearchString,
          selectBid: _selectBid,
        filterBids: _filterBids);
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

  _selectBid(Bid bid) {
    Provider.of<AuctionProvider>(context).selectedBid = bid;
    Navigator.of(context).pushNamed(BidDetails.route);
  }

  _filterBids(String filterSearchString) {
    Provider.of<AuctionProvider>(context).filterBids(filterSearchString);
  }
}
