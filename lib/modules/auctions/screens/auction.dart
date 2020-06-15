import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/enum/auction-details-state.enum.dart';
import 'package:app/modules/auctions/models/bid.model.dart';
import 'package:app/modules/auctions/providers/auction-provider.dart';
import 'package:app/modules/auctions/screens/bid-details.dart';
import 'package:app/modules/auctions/services/bid.service.dart';
import 'package:app/modules/auctions/widgets/details/auction-appointment-details.widget.dart';
import 'package:app/modules/auctions/widgets/details/auction-bids.widget.dart';
import 'package:app/modules/notifications/screens/notifications.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auctions.dart';

class AuctionDetails extends StatefulWidget {
  static const String route = '${Auctions.route}/auctionDetails';
  static const String notificationRoute =
      '${Notifications.route}/auctionDetails';

  @override
  State<StatefulWidget> createState() {
    return AuctionDetailsState(route: route);
  }
}

class AuctionDetailsState extends State<AuctionDetails> {
  String route;

  AuctionDetailsScreenState currentState =
      AuctionDetailsScreenState.APPOINTMENT;

  AuctionDetailsState({this.route});

  AuctionProvider _provider;

  bool _initDone = false;
  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    if (_provider != null && _provider.selectedAuction == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
    }

    return Consumer<AuctionProvider>(
        builder: (context, appointmentsProvider, _) => Scaffold(
            appBar: AppBar(
              title: _titleText(),
              iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
            ),
            body: _contentWidget()));
  }

  @override
  void didChangeDependencies() {
    _provider = Provider.of<AuctionProvider>(context);
    _initDone = _initDone == false ? false : _provider.initDone;

    if (!_initDone) {
      if (_provider.selectedAuction != null) {
        setState(() {
          _isLoading = true;
        });

        _loadData();
      }
    }

    _provider.initDone = true;
    _initDone = true;

    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _provider
          .getAppointmentDetails(_provider.selectedAuction.appointment.id)
          .then((_) async {
        await _provider
            .loadBids(_provider.selectedAuction.id)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.GET_APPOINTMENT_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_appointment_details, context);
      } else if (error.toString().contains(BidsService.GET_BIDS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_bids, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _titleText() {
    return Text(
      _provider.selectedAuction?.appointment?.name ?? 'N/A',
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
    if (!_isLoading && _provider.redirectBid != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _selectBid(_provider.redirectBid);
        _provider.redirectBid = null;
      });
    }
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : _getContent();
  }

  _getContent() {
    switch (this.currentState) {
      case AuctionDetailsScreenState.APPOINTMENT:
        return AuctionAppointmentDetailsWidget(
            auction: _provider.selectedAuction,
            appointmentDetail: _provider.appointmentDetails);
      case AuctionDetailsScreenState.AUCTIONS:
        _provider.resetFilterParameters();

        return AuctionBidsWidget(
            bids: _provider.bids,
            filterSearchString: _provider.filterSearchString,
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
    _provider.selectedBid = bid;
    Navigator.of(context).pushNamed(BidDetails.route);
  }

  _filterBids(String filterSearchString) {
    _provider.filterBids(filterSearchString);
  }
}
