import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/work-estimate-details.model.dart';
import 'package:enginizer_flutter/utils/environment.constants.dart';

class WorkEstimatesService {
  static const String WORK_ESTIMATES_PATH =
      '${Environment.WORK_ESTIMATES_BASE_API}/workEstimates';

  static const String WORK_ESTIMATE_ITEMS_PREFIX =
      '${Environment.WORK_ESTIMATES_BASE_API}/workEstimates/';
  static const String WORK_ESTIMATE_ITEMS_SUFFIX = '/items';

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

  Future<Issue> addWorkEstimateItem(int id, Issue issue) async {
    final response = await _dio.post(_buildWorkEstimateItemsPath(id),
        data: jsonEncode(issue.toJson()));

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return _mapIssue(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('ADD_WORK_ESTIMATE_ITEM_FAILED');
    }
  }

  _buildWorkEstimateItemsPath(int workEstimateId) {
    return WORK_ESTIMATE_ITEMS_PREFIX +
        workEstimateId.toString() +
        WORK_ESTIMATE_ITEMS_SUFFIX;
  }

  Issue _mapIssue(dynamic response) {
    return Issue.fromJson(response);
  }
}
