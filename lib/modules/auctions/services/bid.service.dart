import 'package:dio/dio.dart';
import 'package:app/config/injection.dart';
import 'package:app/modules/auctions/models/bid-details.model.dart';
import 'package:app/modules/auctions/models/response/bid-response.model.dart';
import 'package:app/utils/environment.constants.dart';

class BidsService {
  static const String GET_BIDS_EXCEPTION = 'GET_BIDS_EXCEPTION';
  static const String GET_BID_DETAILS_EXCEPTION = 'GET_BID_DETAILS_EXCEPTION';
  static const String ACCEPT_BID_EXCEPTION = 'ACCEPT_BID_EXCEPTION';
  static const String REJECT_BID_EXCEPTION = 'REJECT_BID_EXCEPTION';

  static const String _BIDS_PATH = '${Environment.BIDS_BASE_API}/bids';

  static const String _AUCTION_BIDS_PREFIX =
      '${Environment.BIDS_BASE_API}/auctions/';
  static const String _AUCTION_BIDS_SUFFIX = '/bids';

  static const String _ACCEPT_BID_PREFIX = '${Environment.BIDS_BASE_API}/bids/';
  static const String _ACCEPT_BID_SUFFIX = '/accept';

  static const String _REJECT_BID_PREFIX = '${Environment.BIDS_BASE_API}/bids/';
  static const String _REJECT_BID_SUFFIX = '/reject';

  Dio _dio = inject<Dio>();

  BidsService();

  Future<BidResponse> getBids(int auctionId) async {
    try {
      final response = await _dio.get(_buildBidsPath(auctionId));

      if (response.statusCode == 200) {
        return BidResponse.fromJson(response.data);
      } else {
        throw Exception(GET_BIDS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_BIDS_EXCEPTION);
    }
  }

  Future<BidDetails> getBidDetails(int id) async {
    try {
      final response = await _dio.get('$_BIDS_PATH/$id');

      if (response.statusCode < 300) {
        return BidDetails.fromJson(response.data);
      } else {
        throw Exception(GET_BID_DETAILS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_BID_DETAILS_EXCEPTION);
    }
  }

  _buildBidsPath(int auctionId) {
    return _AUCTION_BIDS_PREFIX + auctionId.toString() + _AUCTION_BIDS_SUFFIX;
  }

  Future<bool> acceptBid(int bidId) async {
    try {
      final response = await _dio.patch(_buildAcceptBidPath(bidId));
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(ACCEPT_BID_EXCEPTION);
      }
    } catch (error) {
      throw Exception(ACCEPT_BID_EXCEPTION);
    }
  }

  _buildAcceptBidPath(int bidId) {
    return _ACCEPT_BID_PREFIX + bidId.toString() + _ACCEPT_BID_SUFFIX;
  }

  Future<bool> rejectBid(int bidId) async {
    try {
      final response = await _dio.patch(_buildRejectBidPath(bidId));
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(REJECT_BID_EXCEPTION);
      }
    } catch (error) {
      throw Exception(REJECT_BID_EXCEPTION);
    }
  }

  _buildRejectBidPath(int bidId) {
    return _REJECT_BID_PREFIX + bidId.toString() + _REJECT_BID_SUFFIX;
  }
}
