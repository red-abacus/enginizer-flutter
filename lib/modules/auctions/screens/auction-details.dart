import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/enum/auction-details-state.enum.dart';
import 'package:app/modules/auctions/models/bid.model.dart';
import 'package:app/modules/auctions/providers/auction-provider.dart';
import 'package:app/modules/auctions/screens/bid-details.dart';
import 'package:app/modules/auctions/widgets/details/auction-appointment-details.widget.dart';
import 'package:app/modules/auctions/widgets/details/auction-bids.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/snack_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
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

  AuctionDetailsScreenState currentState =
      AuctionDetailsScreenState.APPOINTMENT;

  AuctionDetailsState({this.route});

  AuctionProvider auctionProvider;

  @override
  Widget build(BuildContext context) {
    if (auctionProvider != null && auctionProvider.selectedAuction == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
    }

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
    auctionProvider = Provider.of<AuctionProvider>(context);

    if (!auctionProvider.initDone) {
      if (auctionProvider.selectedAuction != null) {
        setState(() {
          auctionProvider.isLoading = true;
        });

        _loadData();
      }

      auctionProvider.initDone = true;
    }
    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await auctionProvider
          .getAppointmentDetails(auctionProvider.selectedAuction.appointment.id)
          .then((_) {
        auctionProvider.loadBids(auctionProvider.selectedAuction.id).then((_) {
          setState(() {
            auctionProvider.isLoading = false;
          });
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.GET_APPOINTMENT_DETAILS_EXCEPTION)) {
        SnackBarManager.showSnackBar(
            S.of(context).general_error,
            S.of(context).exception_get_appointment_details,
            _scaffoldKey.currentState);
      }

      setState(() {
        auctionProvider.isLoading = false;
      });
    }
  }

  _titleText() {
    return Text(
      auctionProvider.selectedAuction?.appointment?.name ?? 'N/A',
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
    return Provider.of<AuctionProvider>(context).isLoading
        ? Center(child: CircularProgressIndicator())
        : _getContent();
  }

  _getContent() {
    switch (this.currentState) {
      case AuctionDetailsScreenState.APPOINTMENT:
        return AuctionAppointmentDetailsWidget(
            auction: auctionProvider.selectedAuction,
            appointmentDetail: auctionProvider.appointmentDetails);
      case AuctionDetailsScreenState.AUCTIONS:
        auctionProvider.resetFilterParameters();

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
    auctionProvider.selectedBid = bid;
    Navigator.of(context).pushNamed(BidDetails.route);
  }

  _filterBids(String filterSearchString) {
    Provider.of<AuctionProvider>(context).filterBids(filterSearchString);
  }
}
