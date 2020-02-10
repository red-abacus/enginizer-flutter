import 'package:enginizer_flutter/modules/auctions/providers/auctions-provider.dart';
import 'package:enginizer_flutter/modules/auctions/widgets/auctions-list.dart';
import 'package:enginizer_flutter/modules/cars/models/car-brand.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  AuctionsState({this.route});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuctionsProvider>(
      builder: (context, appointmentsProvider, _) =>
          Scaffold(
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

      Provider.of<AuctionsProvider>(context, listen: false).loadCarBrands().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _initDone = true;

    super.didChangeDependencies();
  }

  _renderAuctions(bool _isLoading) {
    List<CarBrand> brands = Provider.of<AuctionsProvider>(context, listen: false).carBrands;

    return _isLoading
        ? CircularProgressIndicator()
        : AuctionsList(carBrands: brands);
  }
}
