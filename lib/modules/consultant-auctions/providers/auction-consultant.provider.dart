import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/modules/appointments/services/appointments.service.dart';
import 'package:enginizer_flutter/modules/appointments/services/provider.service.dart';
import 'package:enginizer_flutter/modules/auctions/models/auction-details.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/auction.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/work-estimate-details.model.dart';
import 'package:enginizer_flutter/modules/auctions/services/auction.service.dart';
import 'package:flutter/cupertino.dart';

class AuctionConsultantProvider with ChangeNotifier {
  AppointmentsService appointmentsService = inject<AppointmentsService>();
  ProviderService providerService = inject<ProviderService>();
  AuctionsService _auctionsService = inject<AuctionsService>();

  Auction selectedAuction;
  AuctionDetail auctionDetails;

  Future<AuctionDetail> getAuctionDetails(int auctionId) async {
    auctionDetails = await this._auctionsService.getAuctionDetails(auctionId);
    notifyListeners();
    return auctionDetails;
  }

  Future<ServiceProvider> getServiceProviderDetails(int providerId) async {
    return await this.providerService.getProviderDetails(providerId);
  }

  Future<WorkEstimateDetails> createBid(Map<String, dynamic> content) async {
    WorkEstimateDetails workEstimateDetails =
        await _auctionsService.createBid(content, selectedAuction.id);
    notifyListeners();
    return workEstimateDetails;
  }
}
