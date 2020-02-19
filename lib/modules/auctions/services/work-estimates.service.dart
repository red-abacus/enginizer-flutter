import 'package:dio/dio.dart';
import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/auctions/models/work-estimate-details.model.dart';
import 'package:enginizer_flutter/utils/environment.constants.dart';

class WorkEstimatesService {
  static const String WORK_ESTIMATES_PATH =
      '${Environment.WORK_ESTIMATES_BASE_API}/workEstimates';

  Dio _dio = inject<Dio>();

  WorkEstimatesService();

  Future<WorkEstimateDetails> getWorkEstimateDetails(int id) async {
    final response = await _dio.get('$WORK_ESTIMATES_PATH/$id');

    if (response.statusCode < 300) {
      // If server returns an OK response, parse the JSON.

      return WorkEstimateDetails.fromJson(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('WORK_ESTIMATE_DETAILS_FAILED');
    }
  }
}
