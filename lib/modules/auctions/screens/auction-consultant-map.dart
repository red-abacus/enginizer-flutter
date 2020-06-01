import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/modules/appointments/widgets/service-details-modal.widget.dart';
import 'package:app/modules/auctions/models/bid.model.dart';
import 'package:app/modules/auctions/screens/auctions.dart';
import 'package:app/modules/auctions/services/auction.service.dart';
import 'package:app/modules/auctions/widgets/details-map/auction-consultant-map-details.widget.dart';
import 'package:app/modules/auctions/widgets/details-map/auction-consultant-map.widget.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/auctions/providers/auction-consultant.provider.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/work-estimate-form/screens/work-estimate-form.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
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
    _tabController.addListener(_setActiveTabIndex);
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
            floatingActionButton: _floatActionButtonContainer(),
            body: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _contentWidget()));
  }

  @override
  Future<void> didChangeDependencies() async {
    _provider = Provider.of<AuctionConsultantProvider>(context);
    _initDone = _initDone == false ? false : _provider.initDone;

    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _provider.loadAuctionMapData(context).then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      } catch (error) {
        if (error
            .toString()
            .contains(AuctionsService.GET_POINTS_DISTANCE_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_get_points_distance, context);
        }

        setState(() {
          _isLoading = false;
        });
      }
    }

    _initDone = true;
    _provider.initDone = true;

    super.didChangeDependencies();
  }

  _setActiveTabIndex() {
    setState(() {
    });
  }

  _floatActionButtonContainer() {
    return _tabController.index == 0
        ? Container(
            child: FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {
//          widget.createEstimate();
              },
              label: Text(
                S.of(context).auction_create_estimate.toUpperCase(),
                style:
                    TextHelper.customTextStyle(null, red, FontWeight.bold, 16),
              ),
              backgroundColor: Colors.white,
            ),
          )
        : Container();
  }

  _titleText() {
    return Text(
      _provider.selectedAuction?.appointment?.name ?? 'N/A',
      style:
          TextHelper.customTextStyle(null, Colors.white, FontWeight.bold, 20),
    );
  }

  _contentWidget() {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      controller: _tabController,
      children: [
        AuctionConsultantMapDetailsWidget(
            showProviderDetails: _showProviderDetails),
        AuctionConsultantMapWidget()
      ],
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

  _showProviderDetails() {
    Provider.of<ServiceProviderDetailsProvider>(context).serviceProviderId = 7;

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return ServiceDetailsModal();
          });
        });
  }
}
