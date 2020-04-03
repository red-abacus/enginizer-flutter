import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:app/modules/auctions/models/auction-details.model.dart';
import 'package:app/modules/auctions/models/response/auction-response.model.dart';
import 'package:app/modules/auctions/models/work-estimate-details.model.dart';

import '../../../config/injection.dart';
import '../../../utils/environment.constants.dart';

class AuctionsService {
  static const String AUCTIONS_PATH =
      '${Environment.BIDS_BASE_API}/auctions';

  static const String CREATE_BID_PATH_PREFIX =
      '${Environment.BIDS_BASE_API}/auctions/';
  static const String CREATE_BID_PATH_SUFFIX = '/bids';

  Dio _dio = inject<Dio>();

  AuctionsService();

  Future<AuctionResponse> getAuctions() async {
    final response = await _dio.get(AUCTIONS_PATH);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.

      return AuctionResponse.fromJson(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('LOAD_SERVICES_FAILED');
    }
  }

  Future<AuctionDetail> getAuctionDetails(int auctionId) async {
    final response = await _dio.get(AUCTIONS_PATH + "/" + auctionId.toString());

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.

      return AuctionDetail.fromJson(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('LOAD_AUCTION_DETAILS_ERROR');
    }
  }

  Future<WorkEstimateDetails> createBid(Map<String, dynamic> map, int auctionId) async {
    final response = await _dio.post(_buildCreateBidPath(auctionId),
        data: jsonEncode(map));

    if (response.statusCode == 201) {
      return WorkEstimateDetails.fromJson(response.data);
    } else {
      throw Exception('CREATE_BID_FAILED');
    }
  }

  _buildCreateBidPath(int auctionId) {
    return CREATE_BID_PATH_PREFIX +
        auctionId.toString() +
        CREATE_BID_PATH_SUFFIX;
  }
}
