import 'package:app/generated/l10n.dart';
import 'package:app/modules/auctions/models/bid.model.dart';
import 'package:app/modules/auctions/screens/auctions.dart';
import 'package:app/modules/auctions/widgets/details-map/auction-consultant-map-details.widget.dart';
import 'package:app/modules/auctions/widgets/details-map/auction-consultant-map.widget.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/auctions/providers/auction-consultant.provider.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/work-estimate-form/screens/work-estimate-form.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuctionConsultantMap extends StatefulWidget {
  static const String route = '/${Auctions.route}/auction-consultant-map';

  @override
  State<StatefulWidget> createState() {
    return AuctionConsultantMapState(route: route);
  }
}

class AuctionConsultantMapState extends State<AuctionConsultantMap>
    with SingleTickerProviderStateMixin {
  String route;

  var _initDone = false;
  var _isLoading = false;

  AuctionConsultantMapState({this.route});

  AuctionConsultantProvider _provider;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuctionConsultantProvider>(
        builder: (context, appointmentsProvider, _) => Scaffold(
            appBar: AppBar(
              title: _titleText(),
              iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
              bottom: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: S.of(context).general_details),
                  Tab(text: S.of(context).auction_route_title),
                ],
              ),
            ),
            body: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _contentWidget()));
  }

  @override
  void didChangeDependencies() {
    _provider = Provider.of<AuctionConsultantProvider>(context);
    _initDone = _initDone == false ? false : _provider.initDone;

    if (!_initDone) {}

    super.didChangeDependencies();
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
    });

    setState(() {
      _isLoading = false;
    });
  }

  _titleText() {
    return Text(
      _provider.selectedAuction?.appointment?.name ?? 'N/A',
      style:
          TextHelper.customTextStyle(null, Colors.white, FontWeight.bold, 20),
    );
  }

  _contentWidget() {
    List<Widget> list = [
      AuctionConsultantMapDetailsWidget(
        auctionDetails: _provider.auctionDetails,
      ),
      AuctionConsultantMapWidget()
    ];

    return TabBarView(
      controller: _tabController,
      children: list,
    );
  }

  _createEstimate() {
    if (_provider.auctionDetails != null) {
      Provider.of<WorkEstimateProvider>(context)
          .refreshValues(EstimatorMode.Create);
      Provider.of<WorkEstimateProvider>(context)
          .setIssues(context, _provider.auctionDetails.issues);
      Provider.of<WorkEstimateProvider>(context).serviceProviderId =
          Provider.of<Auth>(context).authUserDetails.userProvider.id;
      Provider.of<WorkEstimateProvider>(context).selectedAuctionDetails =
          _provider.auctionDetails;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkEstimateForm(mode: EstimatorMode.Create)),
      );
    }
  }


  _seeEstimate() {
    Provider.of<WorkEstimateProvider>(context)
        .refreshValues(EstimatorMode.ReadOnly);

    Bid providerBid;
    for (Bid bid in _provider.auctionDetails.bids) {
      if (bid.serviceProvider.id ==
          Provider.of<Auth>(context).authUser.providerId) {
        providerBid = bid;
        break;
      }
    }
    if (providerBid != null) {
      Provider.of<WorkEstimateProvider>(context).workEstimateId =
          providerBid.workEstimateId;
      Provider.of<WorkEstimateProvider>(context).serviceProviderId =
          providerBid.serviceProvider.id;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WorkEstimateForm(mode: EstimatorMode.ReadOnly)),
    );
  }
}
