import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/models/auction.model.dart';
import 'package:app/modules/auctions/models/bid-details.model.dart';
import 'package:app/modules/auctions/models/bid.model.dart';
import 'package:app/modules/auctions/models/response/bid-response.model.dart';
import 'package:app/modules/auctions/services/bid.service.dart';
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
  Bid redirectBid;
  BidDetails bidDetails;

  String filterSearchString = "";

  void initialise() {
    bidResponse = null;
    bids = [];
    selectedAuction = null;
    appointmentDetails = null;
    selectedBid = null;
    filterSearchString = "";
    isLoading = false;
    initDone = false;
    redirectBid = null;
  }

  void resetFilterParameters() {
    filterSearchString = "";
  }

  Future<AppointmentDetail> getAppointmentDetails(int appointmentId) async {
    try {
      appointmentDetails =
          await this.appointmentsService.getAppointmentDetails(appointmentId);
      notifyListeners();
      return appointmentDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<Bid>> loadBids(int auctionId) async {
    try {
      this.bidResponse = await this.bidsService.getBids(auctionId);
      bids = bidResponse.bids;
      notifyListeners();
      return bids;
    } catch (error) {}
  }

  Future<BidDetails> getBidDetails() async {
    try {
      bidDetails = await this.bidsService.getBidDetails(selectedBid.id);
      notifyListeners();
      return bidDetails;
    } catch (error) {
      throw (error);
    }
  }

  List<Bid> filterBids(String filterSearchString) {
    this.filterSearchString = filterSearchString;

    bids = bidResponse.bids;
    bids = bids.where((bid) => bid.filtered(this.filterSearchString)).toList();
    notifyListeners();
    return bids;
  }

  Future<bool> acceptBid(int bidId) async {
    try {
      return await this.bidsService.acceptBid(bidId);
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> rejectBid(int bidId) async {
    try {
      return await this.bidsService.rejectBid(bidId);
    } catch (error) {
      throw (error);
    }
  }

  Future<ServiceProvider> getServiceProviderDetails(int providerId) async {
    try {
      return await this.providerService.getProviderDetails(providerId);
    } catch (error) {
      throw (error);
    }
  }
}
