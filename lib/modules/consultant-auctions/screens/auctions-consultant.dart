import 'package:app/generated/l10n.dart';
import 'package:app/modules/auctions/enum/auction-status.enum.dart';
import 'package:app/modules/auctions/models/auction.model.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car-query.model.dart';
import 'package:app/modules/cars/services/car-make.service.dart';
import 'package:app/modules/consultant-auctions/providers/auction-consultant.provider.dart';
import 'package:app/modules/consultant-auctions/providers/auctions-consultant.provider.dart';
import 'package:app/modules/consultant-auctions/screens/auction-consultant.dart';
import 'package:app/modules/consultant-auctions/widgets/auctions-consultant-list.widget.dart';
import 'package:app/utils/locale.manager.dart';
import 'package:app/utils/snack_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuctionsConsultant extends StatefulWidget {
  static const String route = '/auctions-consultant';
  static final IconData icon = Icons.dashboard;

  @override
  State<StatefulWidget> createState() {
    return AuctionsConsultantState(route: route);
  }
}

class AuctionsConsultantState extends State<AuctionsConsultant> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String route;
  var _initDone = false;
  var _isLoading = false;

  AuctionsConsultantProvider auctionsProvider;

  AuctionsConsultantState({this.route});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuctionsConsultantProvider>(
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
    try {
      auctionsProvider = Provider.of<AuctionsConsultantProvider>(context);
      auctionsProvider.resetParameters();

      await auctionsProvider
          .loadCarBrands(CarQuery(language: LocaleManager.language(context)))
          .then((_) {
        auctionsProvider.loadAuctions().then((_) {
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

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  _renderAuctions(bool _isLoading) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : AuctionsConsultantList(
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
    AuctionConsultantProvider provider =
        Provider.of<AuctionConsultantProvider>(context, listen: false);
    provider.selectedAuction = auction;

    Navigator.of(context).pushNamed(AuctionConsultant.route);
  }
}
