import 'package:app/generated/l10n.dart';
import 'package:app/modules/auctions/enum/auction-status.enum.dart';
import 'package:app/modules/auctions/models/auction.model.dart';
import 'package:app/modules/auctions/providers/auction-provider.dart';
import 'package:app/modules/auctions/providers/auctions-provider.dart';
import 'package:app/modules/auctions/screens/auction-details.dart';
import 'package:app/modules/auctions/services/auction.service.dart';
import 'package:app/modules/auctions/widgets/auctions-list.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car-query.model.dart';
import 'package:app/modules/cars/services/car-make.service.dart';
import 'package:app/utils/locale.manager.dart';
import 'package:app/utils/snack_bar.helper.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String route;
  var _initDone = false;
  var _isLoading = false;

  AuctionsProvider auctionsProvider;

  AuctionsState({this.route});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuctionsProvider>(
      builder: (context, appointmentsProvider, _) => Scaffold(
        key: _scaffoldKey,
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
      _loadData();
    }

    _initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
    auctionsProvider = Provider.of<AuctionsProvider>(context);
    auctionsProvider.resetParameters();

    try {
      await auctionsProvider
          .loadCarBrands(CarQuery(language: LocaleManager.language(context)))
          .then((_) async {
        await auctionsProvider.loadAuctions().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(CarMakeService.LOAD_CAR_BRANDS_FAILED_EXCEPTION)) {
        SnackBarManager.showSnackBar(S.of(context).general_error,
            S.of(context).exception_load_car_brands, _scaffoldKey.currentState);
      } else if (error
          .toString()
          .contains(AuctionsService.GET_AUCTION_EXCEPTION)) {
        SnackBarManager.showSnackBar(S.of(context).general_error,
            S.of(context).exception_get_auctions, _scaffoldKey.currentState);
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
