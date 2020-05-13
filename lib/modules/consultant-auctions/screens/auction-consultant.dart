import 'package:app/generated/l10n.dart';
import 'package:app/modules/auctions/services/auction.service.dart';
import 'package:app/modules/consultant-auctions/providers/auction-consultant.provider.dart';
import 'package:app/modules/consultant-auctions/screens/auctions-consultant.dart';
import 'package:app/modules/consultant-auctions/widgets/auction-consultant-parts.widget.dart';
import 'package:app/modules/consultant-auctions/widgets/auction-consultant.widget.dart';
import 'package:app/modules/shared/managers/permissions-auction.dart';
import 'package:app/modules/shared/managers/permissions-manager.dart';
import 'package:app/modules/work-estimate-form/models/work-estimate-request.model.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuctionConsultant extends StatefulWidget {
  static const String route = '/${AuctionsConsultant.route}/auction-consultant';

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
    if (!_initDone) {
      auctionProvider = Provider.of<AuctionConsultantProvider>(context);

      if (auctionProvider.selectedAuction != null) {
        _loadData();
      }

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
          .then((_) {
        setState(() {
          _isLoading = false;
        });
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
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _buildContent(),
          ),
        )
      ],
    );
  }

  _buildContent() {
    if (PermissionsManager.getInstance().consultantHasAccess(
        ConsultantMainPermissions.Auctions,
        auctionPermission: ConsultantAuctionPermission.AppointmentDetails)) {
      return AuctionConsultantWidget(
          auction: auctionProvider.selectedAuction,
          auctionDetails: auctionProvider.auctionDetails,
          createBid: _createBid);
    } else if (PermissionsManager.getInstance().consultantHasAccess(
        ConsultantMainPermissions.Auctions,
        auctionPermission: ConsultantAuctionPermission.CarDetails)) {
      return AuctionConsultantPartsWidget(
          auction: auctionProvider.selectedAuction,
          auctionDetails: auctionProvider.auctionDetails,
          createBid: _createBid);
    }

    return Container(child: Text('No permission !'));
  }

  _createBid(WorkEstimateRequest workEstimateRequest) {
    try {
      auctionProvider.createBid(workEstimateRequest.toJson()).then((_) {
        Navigator.pop(context);

        setState(() {
          _initDone = false;
        });
      });
    } catch (error) {
      if (error.toString().contains(AuctionsService.CREATE_BID_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_create_bid, context);
      }
    }
  }
}
