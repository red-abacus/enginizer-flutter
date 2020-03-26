import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/model/service-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';
import 'package:enginizer_flutter/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/service-details-modal.widget.dart';
import 'package:enginizer_flutter/modules/auctions/enum/bid-status.enum.dart';
import 'package:enginizer_flutter/modules/auctions/models/bid.model.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/models/enums/estimator-mode.enum.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/models/issue.model.dart';
import 'package:enginizer_flutter/modules/auctions/providers/auction-provider.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/screens/work-estimate-form.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/date_utils.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class BidDetails extends StatefulWidget {
  static const String route = '/auctions/auctionDetails/bidDetails';

  @override
  State<StatefulWidget> createState() {
    return BidDetailsState(route: route);
  }
}

class BidDetailsState extends State<BidDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String route;

  var _initDone = false;
  var _isLoading = false;

  BidDetailsState({this.route});

  AuctionProvider auctionProvider;
  WorkEstimateProvider _createWorkEstimateProvider;

  @override
  Widget build(BuildContext context) {
    auctionProvider = Provider.of<AuctionProvider>(context);
    _createWorkEstimateProvider = Provider.of<WorkEstimateProvider>(context);

    return Consumer<AuctionProvider>(
        builder: (context, auctionProvider, _) => Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
            ),
            body: Column(
              children: <Widget>[
                new Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
            floatingActionButton: _floatingButtonsContainer(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat));
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      auctionProvider = Provider.of<AuctionProvider>(context);
      _createWorkEstimateProvider = Provider.of<WorkEstimateProvider>(context);

      setState(() {
        _isLoading = true;
      });

      auctionProvider.getBidDetails().then((bidDetails) {
        _createWorkEstimateProvider
            .getWorkEstimateDetails(bidDetails.workEstimateId)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }
    _initDone = true;
    super.didChangeDependencies();
  }

  _buildContent() {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : _getContent();
  }

  _getContent() {
    return new ListView(
      padding: EdgeInsets.only(bottom: 60),
      shrinkWrap: true,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _imageContainer(),
            _titleContainer(S.of(context).auction_bids_provider),
            _providerContainer(),
            _buildSeparator(),
            _titleContainer(S.of(context).auction_bid_services_provided),
            _servicesContainer(),
            _buildSeparator(),
            _titleContainer(S.of(context).appointment_details_services_issues),
            _issueContainer(),
            _buildSeparator(),
            _titleContainer(
                S.of(context).appointment_details_services_appointment_date),
            _appointmentDateContainer(),
            _buildSeparator(),
            _titleContainer(S.of(context).auction_bid_estimate_price),
            _priceContainer()
          ],
        )
      ],
    );
  }

  _imageContainer() {
    return Row(
      children: <Widget>[
        Container(
          color: red,
          width: 50,
          height: 50,
          child: Container(
            margin: EdgeInsets.all(8),
            child: SvgPicture.asset(
              'assets/images/statuses/in_bid.svg'
                  .toLowerCase(),
              semanticsLabel: 'Appointment Status Image',
            ),
          ),
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              '${auctionProvider.selectedAuction?.appointment?.name ?? 'N/A'}',
              maxLines: 3,
              style:
                  TextHelper.customTextStyle(null, gray3, FontWeight.bold, 16),
            ),
          ),
        ),
      ],
    );
  }

  _providerContainer() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Container(
            width: 16,
            height: 16,
            decoration: new BoxDecoration(
              color: Colors.black,
              borderRadius: new BorderRadius.circular(8),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(
                '${auctionProvider.selectedBid?.serviceProvider?.name ?? 'N/A'}',
                style: TextHelper.customTextStyle(
                    null, Colors.black, FontWeight.bold, 14),
              ),
            ),
          ),
          FlatButton(
            child: Text(
              S.of(context).auction_bid_see_provider_profile.toUpperCase(),
              style: TextHelper.customTextStyle(null, red, FontWeight.bold, 16),
            ),
            onPressed: () {
              _showServiceProviderDetails();
            },
          )
        ],
      ),
    );
  }

  _servicesContainer() {
    return Column(
      children: <Widget>[
        if (auctionProvider.appointmentDetails != null)
          for (ServiceItem serviceItem
              in auctionProvider.appointmentDetails?.serviceItems)
            _getServiceRow(serviceItem),
      ],
    );
  }

  _getServiceRow(ServiceItem serviceItem) {
    return Container(
        margin: EdgeInsets.only(top: 4),
        child: Row(
          children: <Widget>[
            _getServiceText(serviceItem),
          ],
        ));
  }

  _getServiceText(ServiceItem serviceItem) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(right: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              serviceItem.name,
              style: TextHelper.customTextStyle(null, gray, null, 14),
            ),
          ),
          Container(
            width: 30,
            height: 30,
            color: red,
          )
        ],
      ),
    ));
  }

  _issueContainer() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 5),
              child: Column(
                children: <Widget>[
                  if (auctionProvider.appointmentDetails != null)
                    for (int i = 0;
                        i < auctionProvider.appointmentDetails?.issues?.length;
                        i++)
                      _issueTextWidget(
                          auctionProvider.appointmentDetails?.issues[i], i)
                ],
              ),
            ),
          ),
          FlatButton(
            splashColor: Theme.of(context).primaryColor,
            onPressed: () => _openEstimator(context),
            child: Text(
              S.of(context).appointment_details_estimator.toUpperCase(),
              style: TextHelper.customTextStyle(
                  null, red, FontWeight.bold, 16),
            ),
          ),
        ],
      ),
    );
  }

  void _openEstimator(BuildContext ctx) {
    Provider.of<WorkEstimateProvider>(context).refreshValues();
    Provider.of<WorkEstimateProvider>(context).workEstimateId =
        Provider.of<AuctionProvider>(context).bidDetails.workEstimateId;
    Provider.of<WorkEstimateProvider>(context).serviceProviderId =
        Provider.of<AuctionProvider>(context).bidDetails.serviceProvider.id;

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WorkEstimateForm(mode: EstimatorMode.ReadOnly)),
    );
  }

  _appointmentDateContainer() {
    DateTime acceptedDate = auctionProvider.selectedBid?.getAcceptedDate();

    String dateString = (acceptedDate != null)
        ? DateUtils.stringFromDate(acceptedDate, "dd.MM.yyyy")
        : "";
    String timeString = (acceptedDate != null)
        ? DateUtils.stringFromDate(acceptedDate, "HH:mm")
        : "";

    String title = acceptedDate != null
        ? "$dateString ${S.of(context).general_at} $timeString"
        : 'N/A';

    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Text(
        title,
        style:
            TextHelper.customTextStyle(null, Colors.black, FontWeight.bold, 16),
      ),
    );
  }

  _priceContainer() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Text(
        auctionProvider.selectedBid?.cost != null
            ? '${auctionProvider.selectedBid?.cost} ${S.of(context).general_currency.toUpperCase()}'
            : 'N/A',
        style:
            TextHelper.customTextStyle(null, Colors.black, FontWeight.bold, 16),
      ),
    );
  }

  _titleContainer(String text) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: TextHelper.customTextStyle(null, gray2, FontWeight.bold, 13),
      ),
    );
  }

  Widget _issueTextWidget(Issue item, int index) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            width: 20,
            height: 20,
            decoration: new BoxDecoration(
              color: red,
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Center(
              child: Text(
                (index + 1).toString(),
                style: TextHelper.customTextStyle(
                    null, Colors.white, FontWeight.bold, 11),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                item.name,
                style: TextHelper.customTextStyle(null, Colors.black, null, 13),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 10,
          child: Container(
            margin: EdgeInsets.only(top: 15),
            height: 1,
            color: gray_20,
          ),
        )
      ],
    );
  }

  _showCancelBidAlert() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).general_warning,
              style:
                  TextHelper.customTextStyle(null, null, FontWeight.bold, 16)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  S.of(context).auction_bid_cancel_description,
                  style: TextHelper.customTextStyle(null, null, null, 16),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(S.of(context).general_no),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(S.of(context).general_yes),
              onPressed: () {
                Navigator.pop(context);
                _cancelBid(auctionProvider.selectedBid);
              },
            ),
          ],
        );
      },
    );
  }

  _cancelBid(Bid bid) {
    auctionProvider.rejectBid(bid.id).then((success) {
      if (success != null && success) {
        Provider.of<AuctionProvider>(context, listen: false).initDone = false;
        Navigator.pop(context);
      }
    });
  }

  _showAcceptBidAlert() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).general_warning,
              style:
                  TextHelper.customTextStyle(null, null, FontWeight.bold, 16)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  S.of(context).auction_bid_accept_description,
                  style: TextHelper.customTextStyle(null, null, null, 16),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(S.of(context).general_no),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(S.of(context).general_yes),
              onPressed: () {
                _acceptBid(auctionProvider.selectedBid);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _acceptBid(Bid bid) {
    auctionProvider.acceptBid(bid.id).then((success) {
      if (success != null && success) {
        Provider.of<AuctionProvider>(context, listen: false).initDone = false;
        Navigator.pop(context);
      }
    });
  }

  _showServiceProviderDetails() {
    int providerId = auctionProvider.selectedBid.serviceProvider.id;
    auctionProvider
        .getServiceProviderDetails(providerId)
        .then((serviceProvider) {
      if (serviceProvider != null) {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) {
              Provider.of<ServiceProviderDetailsProvider>(context,
                      listen: false)
                  .serviceProviderId = providerId;

              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter state) {
                return ServiceDetailsModal();
              });
            });
      }
    });
  }

  _floatingButtonsContainer() {
    if (auctionProvider.selectedBid.bidStatus() == BidStatus.REJECTED) {
      return Container();
    }

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FloatingActionButton.extended(
            heroTag: '1',
            onPressed: () {
              _showCancelBidAlert();
            },
            label: Text(
              S.of(context).general_decline.toUpperCase(),
              style: TextHelper.customTextStyle(null, red, FontWeight.bold, 20),
            ),
            backgroundColor: Colors.white,
          ),
          FloatingActionButton.extended(
            heroTag: '2',
            onPressed: () {
              _showAcceptBidAlert();
            },
            label: Text(
              S.of(context).general_accept.toUpperCase(),
              style: TextHelper.customTextStyle(null, red, FontWeight.bold, 20),
            ),
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
