import 'dart:convert';

import 'package:app/modules/auctions/enum/auction-status.enum.dart';
import 'package:dio/dio.dart';
import 'package:app/modules/auctions/models/auction-details.model.dart';
import 'package:app/modules/auctions/models/response/auction-response.model.dart';
import 'package:app/modules/auctions/models/work-estimate-details.model.dart';

import '../../../config/injection.dart';
import '../../../utils/environment.constants.dart';

class AuctionsService {
  static const String GET_AUCTION_EXCEPTION = 'GET_AUCTION_EXCEPTION';
  static const String GET_AUCTION_DETAILS_EXCEPTION =
      'GET_AUCTION_DETAILS_EXCEPTION';
  static const String CREATE_BID_EXCEPTION = 'CREATE_BID_EXCEPTION';

  static const String _AUCTIONS_PATH = '${Environment.BIDS_BASE_API}/auctions';

  static const String _CREATE_BID_PATH_PREFIX =
      '${Environment.BIDS_BASE_API}/auctions/';
  static const String _CREATE_BID_PATH_SUFFIX = '/bids';

  Dio _dio = inject<Dio>();

  AuctionsService();

  Future<AuctionResponse> getAuctions(int page,
      {String status, String searchString, int pageSize}) async {
    Map<String, dynamic> queryParameters = {'page': '$page'};

    if (status != null) {
      queryParameters['status'] = status;
    }

    if (searchString != null) {
      queryParameters['search'] = searchString;
    }

    if (pageSize != null) {
      queryParameters['pageSize'] = '$pageSize';
    }

    try {
      final response =
          await _dio.get(_AUCTIONS_PATH, queryParameters: queryParameters);

      if (response.statusCode == 200) {
        return AuctionResponse.fromJson(response.data);
      } else {
        throw Exception(GET_AUCTION_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_AUCTION_EXCEPTION);
    }
  }

  Future<AuctionDetail> getAuctionDetails(int auctionId) async {
    try {
      final response =
          await _dio.get(_AUCTIONS_PATH + "/" + auctionId.toString());

      if (response.statusCode == 200) {
        return AuctionDetail.fromJson(response.data);
      } else {
        throw Exception(GET_AUCTION_DETAILS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_AUCTION_DETAILS_EXCEPTION);
    }
  }

  Future<WorkEstimateDetails> createBid(
      Map<String, dynamic> map, int auctionId) async {
    try {
      final response = await _dio.post(_buildCreateBidPath(auctionId),
          data: jsonEncode(map));

      if (response.statusCode == 201) {
        return WorkEstimateDetails.fromJson(response.data);
      } else {
        throw Exception(CREATE_BID_EXCEPTION);
      }
    } catch (error) {
      throw Exception(CREATE_BID_EXCEPTION);
    }
  }

  _buildCreateBidPath(int auctionId) {
    return _CREATE_BID_PATH_PREFIX +
        auctionId.toString() +
        _CREATE_BID_PATH_SUFFIX;
  }
}
