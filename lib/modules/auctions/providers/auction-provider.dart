import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-details.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/modules/appointments/services/appointments.service.dart';
import 'package:enginizer_flutter/modules/appointments/services/provider.service.dart';
import 'package:enginizer_flutter/modules/auctions/models/auction.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/bid-details.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/bid.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/response/bid-response.model.dart';
import 'package:enginizer_flutter/modules/auctions/services/bid.service.dart';
import 'package:flutter/cupertino.dart';

class AuctionProvider with ChangeNotifier {
  AppointmentsService appointmentsService = inject<AppointmentsService>();
  BidsService bidsService = inject<BidsService>();
  ProviderService providerService = inject<ProviderService>();

  bool isLoading = false;
  bool initDone = false;

  BidResponse bidResponse;
  List<Bid> bids = [];

  Auction selectedAuction;
  AppointmentDetail appointmentDetails;
  Bid selectedBid;
  BidDetails bidDetails;

  String filterSearchString = "";

  void initialiseParameters() {
    bidResponse = null;
    bids = [];
    selectedAuction = null;
    appointmentDetails = null;
    selectedBid = null;
    filterSearchString = "";
    isLoading = false;
    initDone = false;
  }

  void resetFilterParameters() {
    filterSearchString = "";
  }

  Future<AppointmentDetail> getAppointmentDetails(int appointmentId) async {
    appointmentDetails =
        await this.appointmentsService.getAppointmentDetails(appointmentId);
    notifyListeners();
    return appointmentDetails;
  }

  Future<List<Bid>> loadBids(int auctionId) async {
    this.bidResponse = await this.bidsService.getBids(auctionId);
    bids = bidResponse.bids;
    notifyListeners();
    return bids;
  }

  Future<BidDetails> getBidDetails() async {
    bidDetails = await this.bidsService.getBidDetails(selectedBid.id);
    notifyListeners();
    return bidDetails;
  }

  List<Bid> filterBids(String filterSearchString) {
    this.filterSearchString = filterSearchString;

    bids = bidResponse.bids;
    bids = bids
        .where((bid) => bid.filtered(this.filterSearchString))
        .toList();
    notifyListeners();
    return bids;
  }

  Future<bool> acceptBid(int bidId) async {
    return await this.bidsService.acceptBid(bidId);
  }

  Future<bool> rejectBid(int bidId) async {
    return await this.bidsService.rejectBid(bidId);
  }

  Future<ServiceProvider> getServiceProviderDetails(int providerId) async {
    return await this.providerService.getProviderDetails(providerId);
  }
}
