import 'package:enginizer_flutter/modules/auctions/enum/auction-status.enum.dart';
import 'package:enginizer_flutter/modules/auctions/models/auction.model.dart';
import 'package:enginizer_flutter/modules/auctions/providers/auction-provider.dart';
import 'package:enginizer_flutter/modules/auctions/providers/auctions-provider.dart';
import 'package:enginizer_flutter/modules/auctions/screens/auction-details.dart';
import 'package:enginizer_flutter/modules/auctions/widgets/auctions-list.dart';
import 'package:enginizer_flutter/modules/cars/models/car-brand.model.dart';
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

  AuctionsProvider auctionsProvider;

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
        _isLoading = false;
        _isLoading = true;
      });

      auctionsProvider = Provider.of<AuctionsProvider>(context);
      auctionsProvider.resetParameters();

      auctionsProvider.loadCarBrands().then((_) {
        auctionsProvider.loadAuctions().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }

    _initDone = true;

    super.didChangeDependencies();
  }

  _renderAuctions(bool _isLoading) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : AuctionsList(
            carBrands: auctionsProvider.carBrands,
            auctions: auctionsProvider.auctions,
            filterAuctions: _filterAuctions,
            selectAuction: _selectAuction,
            searchString: auctionsProvider.searchString,
            auctionStatus: auctionsProvider.filterStatus,
            carBrand: auctionsProvider.filterCarBrand);
  }

  _filterAuctions(String value, AuctionStatus status, CarBrand carBrand) {
    auctionsProvider.filterAuctions(value, status, carBrand);
  }

  _selectAuction(Auction auction) {
    AuctionProvider provider =
        Provider.of<AuctionProvider>(context, listen: false);
    provider.initialiseParameters();
    provider.selectedAuction = auction;

    Navigator.of(context).pushNamed(AuctionDetails.route);
  }
}
