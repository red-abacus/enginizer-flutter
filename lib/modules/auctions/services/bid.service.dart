import 'package:dio/dio.dart';
import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/auctions/models/response/bid-response.model.dart';
import 'package:enginizer_flutter/utils/environment.constants.dart';

class BidsService {
  static const String BIDS_PATH =
      '${Environment.AUCTIONS_BASE_API}/bids';

  static const String AUCTION_BIDS_PREFIX =
      '${Environment.AUCTIONS_BASE_API}/auctions/';
  static const String AUCTION_BIDS_SUFFIX = '/bids';

  Dio _dio = inject<Dio>();

  BidsService();

  Future<BidResponse> getBids(int auctionId) async {
    final response = await _dio.get(_buildBidsPath(auctionId));

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.

      return BidResponse.fromJson(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('LOAD_BIDS_FAILEd');
    }
  }

  _buildBidsPath(int auctionId) {
    return AUCTION_BIDS_PREFIX +
    auctionId.toString() +
    AUCTION_BIDS_SUFFIX;
  }
}