import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-details.model.dart';
import 'package:enginizer_flutter/modules/appointments/services/appointments.service.dart';
import 'package:enginizer_flutter/modules/auctions/models/auction.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/bid.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/response/bid-response.model.dart';
import 'package:enginizer_flutter/modules/auctions/services/bid.service.dart';
import 'package:flutter/cupertino.dart';

class AuctionProvider with ChangeNotifier {
  AppointmentsService appointmentsService = inject<AppointmentsService>();
  BidsService bidsService = inject<BidsService>();

  BidResponse bidResponse;

  Auction selectedAuction;
  AppointmentDetail appointmentDetails;
  Bid selectedBid;

  Future<AppointmentDetail> getAppointmentDetails(int appointmentId) async {
    appointmentDetails = await this.appointmentsService.getAppointmentDetails(appointmentId);
    notifyListeners();
    return appointmentDetails;
  }

  Future<BidResponse> loadBids(int auctionId) async {
    this.bidResponse = await this.bidsService.getBids(auctionId);
    notifyListeners();
    return bidResponse;
  }
//
  List<Bid> getBids() {
    return this.bidResponse.bids;
  }
}