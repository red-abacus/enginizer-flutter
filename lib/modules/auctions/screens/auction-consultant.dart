import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/widgets/service-details-modal.widget.dart';
import 'package:app/modules/auctions/models/bid.model.dart';
import 'package:app/modules/auctions/screens/auctions.dart';
import 'package:app/modules/auctions/services/auction.service.dart';
import 'package:app/modules/auctions/widgets/details-consultant/auction-consultant-parts.widget.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/auctions/providers/auction-consultant.provider.dart';
import 'package:app/modules/auctions/widgets/details-consultant/auction-consultant.widget.dart';
import 'package:app/modules/notifications/screens/notifications.dart';
import 'package:app/modules/shared/managers/permissions/permissions-auction.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/work-estimate-form/screens/work-estimate-form.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuctionConsultant extends StatefulWidget {
  static const String route = '/${Auctions.route}/auction-consultant';
  static const String notificationRoute = '/${Notifications.route}/auction-consultant';

  @override
  State<StatefulWidget> createState() {
    return AuctionConsultantState(route: route);
  }
}

class AuctionConsultantState extends State<AuctionConsultant> {
  String route;

  var _initDone = false;
  var _isLoading = false;

  AuctionConsultantState({this.route});

  AuctionConsultantProvider auctionProvider;

  @override
  Widget build(BuildContext context) {
    auctionProvider =
        Provider.of<AuctionConsultantProvider>(context, listen: false);

    if (auctionProvider.selectedAuction == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
    }

    return Consumer<AuctionConsultantProvider>(
        builder: (context, appointmentsProvider, _) => Scaffold(
            appBar: AppBar(
              title: _titleText(),
              iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
            ),
            body: _contentWidget()));
  }

  @override
  void didChangeDependencies() {
    auctionProvider = Provider.of<AuctionConsultantProvider>(context);
    _initDone = _initDone == false ? false : auctionProvider.initDone;

    if (!_initDone) {
      if (auctionProvider.selectedAuction != null) {
        _loadData();
      }

      auctionProvider.initDone = true;
      _initDone = true;
    }
    super.didChangeDependencies();
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await auctionProvider
          .getAuctionDetails(auctionProvider.selectedAuction.id)
          .then((_) async {
        if (PermissionsManager.getInstance().hasAccess(
            MainPermissions.Auctions, PermissionsAuction.CAR_DETAILS)) {
          await auctionProvider
              .getAppointmentDetails(
                  auctionProvider.selectedAuction.appointment.id)
              .then((_) async {
            setState(() {
              _isLoading = false;
            });
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AuctionsService.GET_AUCTION_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_auction_details, context);
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

  _titleText() {
    return Text(
      auctionProvider.selectedAuction?.appointment?.name ?? 'N/A',
      style:
          TextHelper.customTextStyle(null, Colors.white, FontWeight.bold, 20),
    );
  }

  _contentWidget() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _buildContent(),
          ),
        )
      ],
    );
  }

  _buildContent() {
    if (PermissionsManager.getInstance().hasAccess(
        MainPermissions.Auctions, PermissionsAuction.APPOINTMENT_DETAILS)) {
      return AuctionConsultantWidget(
          auction: auctionProvider.selectedAuction,
          auctionDetails: auctionProvider.auctionDetails,
          createEstimate: _createEstimate);
    } else if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Auctions, PermissionsAuction.CAR_DETAILS)) {
      Bid providerBid;

      for (Bid bid in auctionProvider.auctionDetails.bids) {
        if (bid.serviceProvider.id ==
            Provider.of<Auth>(context).authUser.providerId) {
          providerBid = bid;
          break;
        }
      }
      return AuctionConsultantPartsWidget(
          auctionDetails: auctionProvider.auctionDetails,
          createEstimate: providerBid == null ? _createPartEstimate : null,
          seeEstimate: providerBid != null ? _seeEstimate : null,
          showProviderDetails: _showProviderDetails);
    }

    return Container(child: Text('No permission !'));
  }

  _createEstimate() {
    if (auctionProvider.auctionDetails != null) {
      Provider.of<WorkEstimateProvider>(context)
          .refreshValues(EstimatorMode.Create);
      Provider.of<WorkEstimateProvider>(context)
          .setIssues(context, auctionProvider.auctionDetails.issues);
      Provider.of<WorkEstimateProvider>(context).serviceProviderId =
          Provider.of<Auth>(context).authUserDetails.userProvider.id;
      Provider.of<WorkEstimateProvider>(context).selectedAuctionDetails =
          auctionProvider.auctionDetails;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkEstimateForm(mode: EstimatorMode.Create)),
      );
    }
  }

  _createPartEstimate() {
    if (auctionProvider.auctionDetails != null) {
      Provider.of<WorkEstimateProvider>(context)
          .refreshValues(EstimatorMode.CreatePart);
      Provider.of<WorkEstimateProvider>(context).selectedAuctionDetails =
          auctionProvider.auctionDetails;
      Provider.of<WorkEstimateProvider>(context)
          .setIssuesWithRecommendations(auctionProvider.auctionDetails.issues);
      Provider.of<WorkEstimateProvider>(context).serviceProviderId =
          Provider.of<Auth>(context).authUserDetails.userProvider.id;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WorkEstimateForm(mode: EstimatorMode.CreatePart)),
      );
    }
  }

  _seeEstimate() {
    Provider.of<WorkEstimateProvider>(context)
        .refreshValues(EstimatorMode.ReadOnly);

    Bid providerBid;
    for (Bid bid in auctionProvider.auctionDetails.bids) {
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
    if (auctionProvider.appointmentDetails.serviceProvider != null) {
      Provider.of<ServiceProviderDetailsProvider>(context).serviceProviderId =
          auctionProvider.appointmentDetails.serviceProvider.id;

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
}
