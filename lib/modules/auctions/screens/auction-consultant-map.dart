import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/widgets/details/service-provider/service-provider-details.modal.dart';
import 'package:app/modules/auctions/models/bid.model.dart';
import 'package:app/modules/auctions/screens/auctions.dart';
import 'package:app/modules/auctions/services/auction.service.dart';
import 'package:app/modules/auctions/widgets/details-map/auction-consultant-map-details.widget.dart';
import 'package:app/modules/auctions/widgets/details-map/auction-consultant-map.widget.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/auctions/providers/auction-consultant.provider.dart';
import 'package:app/modules/notifications/screens/notifications.dart';
import 'package:app/modules/shared/managers/permissions/permissions-appointment.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
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
  static const String route = '${Auctions.route}/auction-consultant-map';
  static const String notificationsRoute =
      '${Notifications.route}/auction-consultant-map';

  @override
  State<StatefulWidget> createState() {
    return AuctionConsultantMapState(route: route);
  }
}

class AuctionConsultantMapState extends State<AuctionConsultantMap>
    with TickerProviderStateMixin {
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
            floatingActionButton:
                _isLoading ? Container() : _floatActionButtonContainer(),
            body: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _contentWidget()));
  }

  @override
  Future<void> didChangeDependencies() async {
    _provider = Provider.of<AuctionConsultantProvider>(context);
    _initDone = _initDone == false ? false : _provider.initDone;

    if (!_initDone) {
      _initDone = true;
      _provider.initDone = true;

      setState(() {
        _isLoading = true;
      });

      try {
        await _provider
            .getAuctionDetails(_provider.selectedAuction.id)
            .then((_) async {
          await _provider
              .getAppointmentDetails(_provider.selectedAuction.appointment.id)
              .then((value) async {
            await _provider.appointmentDetails
                .loadMapData(context)
                .then((value) {
              setState(() {
                _isLoading = false;
              });
            });
          });
        });
      } catch (error) {
        if (error
            .toString()
            .contains(AuctionsService.GET_AUCTION_DETAILS_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_get_auction_details, context);
        } else if (error
            .toString()
            .contains(AuctionsService.GET_POINTS_DISTANCE_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_get_points_distance, context);
        } else if (error
            .toString()
            .contains(AppointmentsService.GET_APPOINTMENT_DETAILS_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_get_appointment_details, context);
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
    setState(() {});
  }

  _floatActionButtonContainer() {
    Bid providerBid;

    for (Bid bid in _provider.auctionDetails.bids) {
      if (bid.serviceProvider.id ==
          Provider.of<Auth>(context).authUser.providerId) {
        providerBid = bid;
        break;
      }
    }

    var button = Container();

    if (providerBid != null) {
      FloatingActionButton.extended(
        heroTag: null,
        onPressed: () {
          _seeEstimate();
        },
        label: Text(
          S.of(context).appointment_details_estimator,
          style: TextHelper.customTextStyle(
              color: red, weight: FontWeight.bold, size: 16),
        ),
        backgroundColor: Colors.white,
      );
    } else if (PermissionsManager.getInstance().hasAccess(
        MainPermissions.Appointments,
        PermissionsAppointment.MANAGE_WORK_ESTIMATES)) {
      FloatingActionButton.extended(
        heroTag: null,
        onPressed: () {
          _createEstimate();
        },
        label: Text(
          S.of(context).auction_create_estimate.toUpperCase(),
          style: TextHelper.customTextStyle(
              color: red, weight: FontWeight.bold, size: 16),
        ),
        backgroundColor: Colors.white,
      );
    }

    return _tabController.index == 0
        ? Container(
            margin: EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                button,
              ],
            ),
          )
        : Container();
  }

  _titleText() {
    return Text(
      _provider.selectedAuction?.appointment?.name ?? 'N/A',
      style: TextHelper.customTextStyle(
          color: Colors.white, weight: FontWeight.bold, size: 20),
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
    if (_provider.auctionDetails != null &&
        _provider.appointmentDetails != null) {
      Provider.of<WorkEstimateProvider>(context)
          .refreshValues(EstimatorMode.CreatePr);
      Provider.of<WorkEstimateProvider>(context)
          .setIssues(context, _provider.appointmentDetails.issues);
      Provider.of<WorkEstimateProvider>(context).serviceProviderId =
          Provider.of<Auth>(context).authUser.providerId;
      Provider.of<WorkEstimateProvider>(context).selectedAuctionDetails =
          _provider.auctionDetails;
      Provider.of<WorkEstimateProvider>(context).defaultQuantity =
          (_provider.appointmentDetails.auctionMapDirections.totalDistance /
                  1000)
              .round() as double;
      Provider.of<WorkEstimateProvider>(context).maxDate = _provider
          .appointmentDetails
          .auctionMapDirections
          .destinationPoints[0]
          .dateTime;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WorkEstimateForm(mode: EstimatorMode.CreatePr)),
      );
    }
  }

  _seeEstimate() {
    // TODO - need to populate
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

  _showProviderDetails() {
    Provider.of<ServiceProviderDetailsProvider>(context).serviceProviderId = 7;

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return ServiceProviderDetailsModal();
          });
        });
  }
}
