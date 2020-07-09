import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/auctions/enum/auction-status.enum.dart';
import 'package:app/modules/auctions/models/auction.model.dart';
import 'package:app/modules/auctions/providers/auction-consultant.provider.dart';
import 'package:app/modules/auctions/providers/auction-provider.dart';
import 'package:app/modules/auctions/providers/auctions-provider.dart';
import 'package:app/modules/auctions/screens/auction-consultant-map.dart';
import 'package:app/modules/auctions/screens/auction-consultant.dart';
import 'package:app/modules/auctions/screens/auction.dart';
import 'package:app/modules/auctions/services/auction.service.dart';
import 'package:app/modules/auctions/widgets/auctions-list.dart';
import 'package:app/modules/shared/managers/permissions/permissions-auction.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auctions-provider.dart';

class Auctions extends StatefulWidget {
  static const String route = '/auctions';
  static final IconData icon = Icons.dashboard;

  @override
  State<StatefulWidget> createState() {
    return AuctionsState(route: route);
  }
}

class AuctionsState extends State<Auctions> {
  String route;
  var _initDone = false;
  var _isLoading = false;

  AuctionsProvider _provider;

  AuctionsState({this.route});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuctionsProvider>(
      builder: (context, appointmentsProvider, _) => Scaffold(
        body: Center(
          child: _renderAuctions(_isLoading),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });

      _provider = Provider.of<AuctionsProvider>(context);
      _provider.resetParameters();
      _loadData();
    }

    _initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _provider.loadAuctions().then((_) async {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error.toString().contains(AuctionsService.GET_AUCTION_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_auctions, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _renderAuctions(bool _isLoading) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : AuctionsList(
            auctions: _provider.auctions,
            filterAuctions: _filterAuctions,
            selectAuction: _selectAuction,
            searchString: _provider.auctionRequest.searchString,
            auctionStatus: _provider.auctionRequest.filterStatus,
            downloadNextPage: _loadData);
  }

  _filterAuctions(String value, AuctionStatus status) {
    _provider.filterAuctions(value, status);
    _loadData();
  }

  _selectAuction(Auction auction) async {
    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Auctions, PermissionsAuction.BID_AUCTIONS)) {
      setState(() {
        _isLoading = false;
      });

      try {
        await _provider.getAuctionDetails(auction.id).then((auctionDetail) {
          setState(() {
            _isLoading = false;
          });

          if (auctionDetail.serviceItems.length > 0) {
            ServiceProviderItem item = auctionDetail.serviceItems.first;

            if (item.isTowService() || item.isPickUpAndReturnService()) {
              AuctionConsultantProvider provider =
                  Provider.of<AuctionConsultantProvider>(context);
              provider.initialise();
              provider.selectedAuction = auction;

              Navigator.of(context).pushNamed(AuctionConsultantMap.route);
            } else {
              AuctionConsultantProvider provider =
                  Provider.of<AuctionConsultantProvider>(context,
                      listen: false);
              provider.selectedAuction = auction;

              Navigator.of(context).pushNamed(AuctionConsultant.route);
            }
          }
        });
      } catch (error) {
        if (error
            .toString()
            .contains(AuctionsService.GET_AUCTION_DETAILS_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_get_auction_details, context);
        }

        setState(() {
          _isLoading = false;
        });
      }
    } else if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Auctions, PermissionsAuction.VIEW_BIDS)) {
      AuctionProvider provider =
          Provider.of<AuctionProvider>(context, listen: false);
      provider.initialise();
      provider.selectedAuction = auction;

      Navigator.of(context).pushNamed(AuctionDetails.route);
    }
  }
}
