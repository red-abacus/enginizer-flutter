import 'package:dio/dio.dart';
import 'package:enginizer_flutter/modules/auctions/models/response/auction-response.model.dart';

import '../../../config/injection.dart';
import '../../../utils/environment.constants.dart';

class AuctionsService {
  static const String AUCTIONS_PATH =
      '${Environment.AUCTIONS_BASE_API}/auctions';

  Dio _dio = inject<Dio>();

  AuctionsService();

  Future<AuctionResponse> getAuctions() async {
    print("get auctions ?");
    final response = await _dio.get(AUCTIONS_PATH);
    print("finish response !");

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.

      return AuctionResponse.fromJson(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('LOAD_SERVICES_FAILED');
    }
  }
}
