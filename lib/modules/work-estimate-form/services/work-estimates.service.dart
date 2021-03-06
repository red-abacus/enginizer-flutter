import 'dart:convert';
import 'dart:io';

import 'package:app/modules/appointments/model/generic-model.dart';
import 'package:app/modules/invoices/models/invoice-details.model.dart';
import 'package:app/modules/invoices/models/requests/invoices-request.model.dart';
import 'package:app/modules/invoices/models/responses/invoices-response.model.dart';
import 'package:app/modules/work-estimate-form/models/import-item-request.model.dart';
import 'package:app/modules/work-estimate-form/models/provider-payment.model.dart';
import 'package:app/modules/work-estimate-form/models/requests/issue-item-request.model.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/modules/work-estimates/models/request/work-estimates-request.model.dart';
import 'package:app/modules/work-estimates/models/responses/work-estimate-response.model.dart';
import 'package:app/modules/work-estimates/models/work-estimate.model.dart';
import 'package:dio/dio.dart';
import 'package:app/config/injection.dart';
import 'package:app/modules/auctions/models/work-estimate-details.model.dart';
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
  static const String REJECT_WORK_ESTIMATE_EXCEPTION =
      'REJECT_WORK_ESTIMATE_EXCEPTION';
  static const String ADD_WORK_ESTIMATE_ITEM_EXCEPTION =
      'ADD_WORK_ESTIMATE_ITEM_EXCEPTION';
  static const String WORK_ESTIMATE_IMPORT_ITEM_EXCEPTION =
      'WORK_ESTIMATE_IMPORT_ITEM_EXCEPTION';
  static const String WORK_ESTIMATE_EDIT_ISSUE_ITEM_EXCEPTION =
      'WORK_ESTIMATE_EDIT_ISSUE_ITEMEXCEPTION';
  static const String GET_INVOICES_EXCEPTION = 'GET_INVOICES_EXCEPTION';
  static const String GET_INVOICE_DETAILS_EXCEPTION =
      'GET_INVOICE_DETAILS_EXCEPTION';
  static const String GET_WORK_ESTIMATE_PDF_EXCEPTION =
      'GET_WORK_ESTIMATE_PDF_EXCEPTION';
  static const String GET_INVOICE_PDF_EXCEPTION = 'GET_INVOICE_PDF_EXCEPTION';
  static const String GET_WORK_ESTIMATE_PAYMENT_EXCEPTION =
      'GET_WORK_ESTIMATE_PAYMENT_EXCEPTION';

  static String _CREATE_WORK_ESTIMATE_PATH =
      '${Environment.BIDS_BASE_API}/bids';

  static String _WORK_ESTIMATES_PATH =
      '${Environment.WORK_ESTIMATES_BASE_API}/workEstimates';

  static String _WORK_ESTIMATE_ITEMS_PREFIX =
      '${Environment.WORK_ESTIMATES_BASE_API}/workEstimates/';
  static const String _WORK_ESTIMATE_ITEMS_SUFFIX = '/items';

  static String _WORK_ESTIMATE_ACCEPT_PREFIX =
      '${Environment.WORK_ESTIMATES_BASE_API}/workEstimates/';
  static const String _WORK_ESTIMATE_ACCEPT_SUFFIX = '/accept';

  static String _WORK_ESTIMATE_REJECT_PREFIX =
      '${Environment.WORK_ESTIMATES_BASE_API}/workEstimates/';
  static const String _WORK_ESTIMATE_REJECT_SUFFIX = '/reject';

  static String _WORK_ESTIMATE_IMPORT_PREFIX =
      '${Environment.WORK_ESTIMATES_BASE_API}/workEstimates/';
  static const String _WORK_ESTIMATE_IMPORT_SUFFIX = '/items/import';

  static String _GET_WORK_ESTIMATE_PDF_PREFIX =
      '${Environment.WORK_ESTIMATES_BASE_API}/workEstimates/';
  static const String _GET_WORK_ESTIMATE_PDF_SUFFIX = '/download';

  static String _GET_INVOICES_PATH =
      '${Environment.WORK_ESTIMATES_BASE_API}/invoices';

  static String _GET_INVOICE_DETAILS_PATH =
      '${Environment.WORK_ESTIMATES_BASE_API}/invoices/';

  static String _GET_INVOICE_PDF_PREFIX =
      '${Environment.WORK_ESTIMATES_BASE_API}/invoices/';
  static const String _GET_INVOICE_PDF_SUFFIX = '/download';

  static String _GET_WORK_ESTIMATE_PAYMENT_PREFIX =
      '${Environment.WORK_ESTIMATES_BASE_API}/workEstimates/';
  static const String _GET_WORK_ESTIMATE_PAYMENT_SUFFIX = '/payment';

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

  Future<WorkEstimateResponse> getWorkEstimates(
      WorkEstimatesRequest workEstimatesRequest) async {
    try {
      final response = await _dio.get('$_WORK_ESTIMATES_PATH',
          queryParameters: workEstimatesRequest.toJson());
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

  Future<WorkEstimateDetails> addWorkEstimateItem(
      int workEstimateId, IssueItemRequest issueItemRequest) async {
    try {
      final response = await _dio.post(
          _buildWorkEstimateItemsPath(workEstimateId),
          data: jsonEncode(issueItemRequest.toCreateJson()));

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

  Future<IssueItem> workEstimateImportItem(
      int workEstimateId, ImportItemRequest importItemRequest) async {
    try {
      final response = await _dio.post(_buildImportItemPath(workEstimateId),
          data: importItemRequest.toJson());

      if (response.statusCode == 200) {
        return IssueItem.fromJson(response.data);
      } else {
        throw Exception(WORK_ESTIMATE_IMPORT_ITEM_EXCEPTION);
      }
    } catch (error) {
      throw Exception(WORK_ESTIMATE_IMPORT_ITEM_EXCEPTION);
    }
  }

  Future<IssueItem> updateAppointmentItem(
      int workEstimateId, IssueItemRequest issueItemRequest) async {
    try {
      final response = await _dio.put(
          _buildWorkEstimateItemsPath(workEstimateId),
          data: jsonEncode(issueItemRequest.toCreateJson()));

      if (response.statusCode == 200) {
        return IssueItem.fromJson(response.data);
      } else {
        throw Exception(WORK_ESTIMATE_EDIT_ISSUE_ITEM_EXCEPTION);
      }
    } catch (error) {
      throw Exception(WORK_ESTIMATE_EDIT_ISSUE_ITEM_EXCEPTION);
    }
  }

  Future<InvoicesResponse> getInvoices(InvoicesRequest request) async {
    try {
      final response =
          await _dio.get(_GET_INVOICES_PATH, queryParameters: request.toJson());

      if (response.statusCode == 200) {
        return InvoicesResponse.fromJson(response.data);
      } else {
        throw Exception(_GET_INVOICES_PATH);
      }
    } catch (error) {
      throw Exception(_GET_INVOICES_PATH);
    }
  }

  Future<InvoiceDetails> getInvoiceDetails(int invoiceId) async {
    try {
      final response =
          await _dio.get(_GET_INVOICE_DETAILS_PATH + invoiceId.toString());

      if (response.statusCode == 200) {
        return InvoiceDetails.fromJson(response.data);
      } else {
        throw Exception(GET_INVOICE_DETAILS_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_INVOICE_DETAILS_EXCEPTION);
    }
  }

  Future<File> getInvoicePdf(int invoiceId, String savePath) async {
    try {
      Response response = await _dio.get(
        _buildGetInvoicePdf(invoiceId),
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      throw Exception(GET_INVOICE_PDF_EXCEPTION);
    }
  }

  Future<File> getWorkEstimatePdf(int workEstimateId, String savePath) async {
    try {
      Response response = await _dio.get(
        _buildGetWorkEstimatePdf(workEstimateId),
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      throw Exception(GET_WORK_ESTIMATE_PDF_EXCEPTION);
    }
  }

  Future<ProviderPayment> getWorkEstimatePayment(
      String returnUrl, int workEstimateId) async {
    Map<String, dynamic> map = new Map();
    map['returnUrl'] = returnUrl;

    try {
      final response = await _dio
          .post(_buildGetWorkEstimatePayment(workEstimateId), data: returnUrl);
      if (response.statusCode == 200) {
        return ProviderPayment.fromJson(response.data);
      } else {
        throw Exception(GET_WORK_ESTIMATE_PAYMENT_EXCEPTION);
      }
    } catch (error) {
      throw Exception(GET_WORK_ESTIMATE_PAYMENT_EXCEPTION);
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

  _buildImportItemPath(int workEstimateId) {
    return _WORK_ESTIMATE_IMPORT_PREFIX +
        workEstimateId.toString() +
        _WORK_ESTIMATE_IMPORT_SUFFIX;
  }

  _buildGetWorkEstimatePdf(int workEstimateId) {
    return _GET_WORK_ESTIMATE_PDF_PREFIX +
        workEstimateId.toString() +
        _GET_WORK_ESTIMATE_PDF_SUFFIX;
  }

  _buildGetInvoicePdf(int invoiceId) {
    return _GET_INVOICE_PDF_PREFIX +
        invoiceId.toString() +
        _GET_INVOICE_PDF_SUFFIX;
  }

  _buildGetWorkEstimatePayment(int workEstimateId) {
    return _GET_WORK_ESTIMATE_PAYMENT_PREFIX +
        workEstimateId.toString() +
        _GET_WORK_ESTIMATE_PAYMENT_SUFFIX;
  }
}
