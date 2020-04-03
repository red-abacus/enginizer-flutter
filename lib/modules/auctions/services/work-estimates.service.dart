import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:app/config/injection.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/auctions/models/work-estimate-details.model.dart';
import 'package:app/modules/consultant-estimators/models/responses/work-estimate-response.model.dart';
import 'package:app/modules/consultant-estimators/models/work-estimate.model.dart';
import 'package:app/utils/environment.constants.dart';

class WorkEstimatesService {
  static const String WORK_ESTIMATES_PATH =
      '${Environment.WORK_ESTIMATES_BASE_API}/workEstimates';

  static const String WORK_ESTIMATE_ITEMS_PREFIX =
      '${Environment.WORK_ESTIMATES_BASE_API}/workEstimates/';
  static const String WORK_ESTIMATE_ITEMS_SUFFIX = '/items';

  static const String WORK_ESTIMATE_ACCEPT_PREFIX =
      '${Environment.WORK_ESTIMATES_BASE_API}/workEstimates/';
  static const String WORK_ESTIMATE_ACCEPT_SUFFIX = '/accept';

  Dio _dio = inject<Dio>();

  WorkEstimatesService();

  Future<WorkEstimateDetails> addNewWorkEstimate(
      Map<String, dynamic> content) async {
    final response =
        await _dio.post('$WORK_ESTIMATES_PATH', data: jsonEncode(content));

    if (response.statusCode == 200) {
      return WorkEstimateDetails.fromJson(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('ADD_NEW_WORK_ESTIMATE_FAILED');
    }
  }

  Future<WorkEstimateResponse> getWorkEstimates() async {
    final response = await _dio.get('$WORK_ESTIMATES_PATH');

    if (response.statusCode < 300) {
      // If server returns an OK response, parse the JSON.

      return WorkEstimateResponse.fromJson(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('WORK_ESTIMATE_DETAILS_FAILED');
    }
  }

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

  Future<bool> deleteWorkEstimateItem(int id, int itemId) async {
    final response =
        await _dio.delete('${_buildWorkEstimateItemsPath(id)}/$itemId');

    if (response.statusCode == 200) {
      // If server returns an OK response, return true.
      return true;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('DELETE_WORK_ESTIMATE_ITEM_FAILED');
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

  Future<WorkEstimate> acceptWorkEstimate(
      int workEstimateId, String proposedDate) async {
    Map<String, dynamic> map = new Map();
    
    final response = await _dio.patch(_buildAcceptWorkEstimate(workEstimateId),
        data: jsonEncode(map));

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return WorkEstimate.fromJson(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('ADD_WORK_ESTIMATE_ITEM_FAILED');
    }
  }

  _buildAcceptWorkEstimate(int workEstimateId) {
    return WORK_ESTIMATE_ACCEPT_PREFIX +
        workEstimateId.toString() +
        WORK_ESTIMATE_ACCEPT_SUFFIX;
  }
}
