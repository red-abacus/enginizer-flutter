import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/appointments/screens/appointment-details.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/models/auction-details.model.dart';
import 'package:app/modules/auctions/models/auction.model.dart';
import 'package:app/modules/auctions/models/bid.model.dart';
import 'package:app/modules/auctions/models/response/bid-response.model.dart';
import 'package:app/modules/auctions/models/work-estimate-details.model.dart';
import 'package:app/modules/auctions/services/auction.service.dart';
import 'package:app/modules/auctions/services/bid.service.dart';
import 'package:flutter/cupertino.dart';

class AuctionConsultantProvider with ChangeNotifier {
  AppointmentsService appointmentsService = inject<AppointmentsService>();
  ProviderService providerService = inject<ProviderService>();
  AuctionsService _auctionsService = inject<AuctionsService>();

  Auction selectedAuction;
  AuctionDetail auctionDetails;
  AppointmentDetail appointmentDetails;

  bool initDone = false;

  Future<AuctionDetail> getAuctionDetails(int auctionId) async {
    try {
      auctionDetails = await this._auctionsService.getAuctionDetails(auctionId);
      notifyListeners();
      return auctionDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future<AppointmentDetail> getAppointmentDetails(int appointmentId) async {
    try {
      appointmentDetails = await this.appointmentsService.getAppointmentDetails(appointmentId);
      notifyListeners();
      return appointmentDetails;
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

  Future<WorkEstimateDetails> createBid(Map<String, dynamic> content) async {
    try {
      WorkEstimateDetails workEstimateDetails =
          await _auctionsService.createBid(content, selectedAuction.id);
      notifyListeners();
      return workEstimateDetails;
    } catch (error) {
      throw (error);
    }
  }
}
