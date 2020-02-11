import 'package:enginizer_flutter/modules/auctions/enum/auction-status.enum.dart';
import 'package:enginizer_flutter/modules/auctions/providers/auctions-provider.dart';
import 'package:enginizer_flutter/modules/auctions/widgets/auctions-list.dart';
import 'package:enginizer_flutter/modules/cars/models/car-brand.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auctions-provider.dart';

class Auctions extends StatefulWidget {
  static const String route = '/auctions';
  static final IconData icon = Icons.card_travel;

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
    auctionsProvider = Provider.of<AuctionsProvider>(context, listen: false);

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

      auctionsProvider = Provider.of<AuctionsProvider>(context, listen: false);

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
            searchString: auctionsProvider.searchString,
            auctionStatus: auctionsProvider.filterStatus,
            carBrand: auctionsProvider.filterCarBrand);
  }

  _filterAuctions(String value, AuctionStatus status, CarBrand carBrand) {
    auctionsProvider.filterAuctions(value, status, carBrand);
  }
}
