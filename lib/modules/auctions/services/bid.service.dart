import 'package:dio/dio.dart';
import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/auctions/models/bid-details.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/response/bid-response.model.dart';
import 'package:enginizer_flutter/utils/environment.constants.dart';

class BidsService {
  static const String BIDS_PATH = '${Environment.BIDS_BASE_API}/bids';

  Dio _dio = inject<Dio>();

  BidsService();

  Future<BidResponse> getBids() async {
    final response = await _dio.get(BIDS_PATH);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.

      return BidResponse.fromJson(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('LOAD_BIDS_FAILED');
    }
  }

  Future<BidDetails> getBidDetails(int id) async {
    final response = await _dio.get('$BIDS_PATH/$id');

    if (response.statusCode < 300) {
      // If server returns an OK response, parse the JSON.

      return BidDetails.fromJson(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('BID_DETAILS_FAILED');
    }
  }
}
