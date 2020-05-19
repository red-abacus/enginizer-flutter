import 'dart:collection';
import 'dart:convert';

import 'package:app/modules/work-estimate-form/models/issue-item-request.model.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/modules/work-estimate-form/models/issue-recommendation.model.dart';
import 'package:dio/dio.dart';
import 'package:app/config/injection.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/auctions/models/work-estimate-details.model.dart';
import 'package:app/modules/consultant-estimators/models/responses/work-estimate-response.model.dart';
import 'package:app/modules/consultant-estimators/models/work-estimate.model.dart';
import 'package:app/utils/environment.constants.dart';

class WorkEstimatesService {
  static const String GET_WORK_ESTIMATES_EXCEPTION =
      'GET_WORK_ESTIMATE_EXCEPTION';
  static const String ADD_NEW_WORK_ESTIMATE_EXCEPTION =
      'ADD_NEW_WORK_ESTIMATE_EXCEPTION';
  static const String GET_WORK_ESTIMATE_DETAILS_EXCEPTION =
      'GET_WORK_ESTIMATE_DETIALS_EXCEPTION';
  static const String ACCEPT_WORK_ESTIMATE_EXCEPTION =
      'ACCEPT_WORK_ESTIMATE_EXCEPTION';
  static const String REJECT_WORK_ESTIMATE_EXCEPTION = 'REJECT_WORK_ESTIMATE_EXCEPTION';
  static const String ADD_WORK_ESTIMATE_ITEM_EXCEPTION = 'ADD_WORK_ESTIMATE_ITEM_EXCEPTION';

  static const String _CREATE_WORK_ESTIMATE_PATH =
      '${Environment.BIDS_BASE_API}/bids';

  static const String _WORK_ESTIMATES_PATH =
      '${Environment.WORK_ESTIMATES_BASE_API}/workEstimates';

  static const String _WORK_ESTIMATE_ITEMS_PREFIX =
      '${Environment.WORK_ESTIMATES_BASE_API}/workEstimates/';
  static const String _WORK_ESTIMATE_ITEMS_SUFFIX = '/items';

  static const String _WORK_ESTIMATE_ACCEPT_PREFIX =
      '${Environment.WORK_ESTIMATES_BASE_API}/workEstimates/';
  static const String _WORK_ESTIMATE_ACCEPT_SUFFIX = '/accept';

  static const String _WORK_ESTIMATE_REJECT_PREFIX =
      '${Environment.WORK_ESTIMATES_BASE_API}/workEstimates/';
  static const String _WORK_ESTIMATE_REJECT_SUFFIX = '/reject';

  Dio _dio = inject<Dio>();

  WorkEstimatesService();

  Future<WorkEstimateDetails> addNewWorkEstimate(
      Map<String, dynamic> content) async {
    try {
      final response = await _dio.post('$_CREATE_WORK_ESTIMATE_PATH',
          data: jsonEncode(content));

      if (response.statusCode == 201 || response.statusCode == 200) {
        return WorkEstimateDetails.fromJson(response.data);
      } else {
        throw Exception(ADD_NEW_WORK_ESTIMATE_EXCEPTION);
      }
    } catch (error) {
      throw Exception(ADD_NEW_WORK_ESTIMATE_EXCEPTION);
    }
  }

  Future<WorkEstimateResponse> getWorkEstimates() async {
    try {
      final response = await _dio.get('$_WORK_ESTIMATES_PATH');

      if (response.statusCode < 300) {
        return WorkEstimateResponse.fromJson(response.data);
      } else {
        throw Exception(GET_WORK_ESTIMATES_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_WORK_ESTIMATES_EXCEPTION);
    }
  }

  Future<WorkEstimateDetails> getWorkEstimateDetails(int id) async {
    try {
      final response = await _dio.get('$_WORK_ESTIMATES_PATH/$id');
      if (response.statusCode < 300) {
        return WorkEstimateDetails.fromJson(response.data);
      } else {
        throw Exception(GET_WORK_ESTIMATE_DETAILS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_WORK_ESTIMATE_DETAILS_EXCEPTION);
    }
  }

  Future<WorkEstimateDetails> addWorkEstimateItem(int workEstimateId, IssueItemRequest issueItemRequest) async {
    try {
      final response = await _dio.post(_buildWorkEstimateItemsPath(workEstimateId),
          data: jsonEncode(issueItemRequest.toJson()));

      if (response.statusCode == 200) {
        return WorkEstimateDetails.fromJson(response.data);
      } else {
        throw Exception(ADD_WORK_ESTIMATE_ITEM_EXCEPTION);
      }
    } catch (error) {
      throw Exception(ADD_WORK_ESTIMATE_ITEM_EXCEPTION);
    }
  }

  Future<bool> deleteWorkEstimateItem(int id, int itemId) async {
    try {
      final response =
          await _dio.delete('${_buildWorkEstimateItemsPath(id)}/$itemId');

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('TODO');
      }
    } catch (error) {
      throw Exception('TODO');
    }
  }

  Future<WorkEstimate> acceptWorkEstimate(
      int workEstimateId, String proposedDate) async {
    try {
      Map<String, dynamic> map = new Map();

      final response = await _dio.patch(
          _buildAcceptWorkEstimate(workEstimateId),
          data: jsonEncode(map));

      if (response.statusCode == 200) {
        return WorkEstimate.fromJson(response.data);
      } else {
        throw Exception(ACCEPT_WORK_ESTIMATE_EXCEPTION);
      }
    } catch (error) {
      throw Exception(ACCEPT_WORK_ESTIMATE_EXCEPTION);
    }
  }

  Future<bool> rejectWorkEstimate(int workEstimateId) async {
    try {
      final response =
          await _dio.patch(_buildRejectWorkEstimate(workEstimateId));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(REJECT_WORK_ESTIMATE_EXCEPTION);
      }
    } catch (error) {
      throw Exception(REJECT_WORK_ESTIMATE_EXCEPTION);
    }
  }

  _buildAcceptWorkEstimate(int workEstimateId) {
    return _WORK_ESTIMATE_ACCEPT_PREFIX +
        workEstimateId.toString() +
        _WORK_ESTIMATE_ACCEPT_SUFFIX;
  }

  _buildRejectWorkEstimate(int workEstimateId) {
    return _WORK_ESTIMATE_REJECT_PREFIX +
        workEstimateId.toString() +
        _WORK_ESTIMATE_REJECT_SUFFIX;
  }

  _buildWorkEstimateItemsPath(int workEstimateId) {
    return _WORK_ESTIMATE_ITEMS_PREFIX +
        workEstimateId.toString() +
        _WORK_ESTIMATE_ITEMS_SUFFIX;
  }

  Issue _mapIssue(dynamic response) {
    return Issue.fromJson(response);
  }
}
