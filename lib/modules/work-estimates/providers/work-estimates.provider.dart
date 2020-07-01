import 'package:app/config/injection.dart';
import 'package:app/modules/work-estimate-form/models/requests/work-estimate-request.model.dart';
import 'package:app/modules/work-estimate-form/services/work-estimates.service.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/work-estimate-form/enums/work-estimate-status.enum.dart';
import 'package:app/modules/work-estimates/enums/work-estimate-sort.enum.dart';
import 'package:app/modules/work-estimates/models/request/work-estimates-request.model.dart';
import 'package:app/modules/work-estimates/models/responses/work-estimate-response.model.dart';
import 'package:app/modules/work-estimates/models/work-estimate.model.dart';
import 'package:flutter/cupertino.dart';

class WorkEstimatesProvider with ChangeNotifier {
  final WorkEstimatesService _workEstimatesService =
      inject<WorkEstimatesService>();

  WorkEstimateResponse _workEstimateResponse;
  WorkEstimatesRequest workEstimatesRequest;

  List<WorkEstimate> workEstimates = [];

  void initialise() {
    workEstimates = [];
    _workEstimateResponse = null;

    workEstimatesRequest = WorkEstimatesRequest();
  }

  bool shouldDownload() {
    if (_workEstimateResponse != null) {
      if (workEstimatesRequest.currentPage >=
          _workEstimateResponse.totalPages) {
        return false;
      }
    }

    return true;
  }

  Future<List<WorkEstimate>> getWorkEstimates() async {
    try {
      _workEstimateResponse = await _workEstimatesService
          .getWorkEstimates(this.workEstimatesRequest);
      this.workEstimates.addAll(this._workEstimateResponse.workEstimates);
      workEstimatesRequest.currentPage += 1;
      notifyListeners();
      return workEstimates;
    } catch (error) {
      if (_workEstimateResponse != null) {
        _workEstimateResponse.totalPages = 0;
      }
      throw (error);
    }
  }

  filterWorkEstimates(String filterString, WorkEstimateStatus filterStatus,
      WorkEstimateSort sort, DateTime startDate, DateTime endDate) async {
    _workEstimateResponse = null;
    workEstimates = [];
    workEstimatesRequest = WorkEstimatesRequest();
    workEstimatesRequest.searchString = filterString;
    workEstimatesRequest.workEstimateStatus = filterStatus;
    workEstimatesRequest.workEstimateSort = sort;
    workEstimatesRequest.startDate = startDate;
    workEstimatesRequest.endDate = endDate;
  }
}
