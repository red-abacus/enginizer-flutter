import 'package:app/config/injection.dart';
import 'package:app/modules/auctions/services/work-estimates.service.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car-query.model.dart';
import 'package:app/modules/cars/services/car-make.service.dart';
import 'package:app/modules/consultant-estimators/enums/work-estimate-status.enum.dart';
import 'package:app/modules/consultant-estimators/models/responses/work-estimate-response.model.dart';
import 'package:app/modules/consultant-estimators/models/work-estimate.model.dart';
import 'package:flutter/cupertino.dart';

class WorkEstimatesConsultantProvider with ChangeNotifier {
  final WorkEstimatesService _workEstimatesService =
      inject<WorkEstimatesService>();
  final CarMakeService _carMakeService = inject<CarMakeService>();

  WorkEstimateResponse _workEstimateResponse;

  List<WorkEstimate> workEstimates = [];
  List<CarBrand> carBrands = [];
  WorkEstimateStatus filterStatus;
  String filterSearchString;
  CarBrand filterCarBrand;

  void resetParameters() {
    workEstimates = [];
    carBrands = [];
    filterStatus = null;
    filterSearchString = null;
    filterCarBrand = null;
  }

  Future<List<WorkEstimate>> getWorkEstimates() async {
    _workEstimateResponse = await _workEstimatesService.getWorkEstimates();
    workEstimates = _workEstimateResponse.workEstimates;
    notifyListeners();
    return workEstimates;
  }

  Future<List<CarBrand>> loadCarBrands(CarQuery carQuery) async {
    try {
      carBrands = await _carMakeService.getCarBrands(carQuery);
      return carBrands;
    }
    catch(error) {
      throw(error);
    }
  }

  Future<List<WorkEstimate>> filterWorkEstimates(String filterString,
      WorkEstimateStatus filterStatus, CarBrand filterCarBrand) async {
    this.filterSearchString = filterString;
    this.filterStatus = filterStatus;
    this.filterCarBrand = filterCarBrand;

    workEstimates = _workEstimateResponse.workEstimates;

    workEstimates = workEstimates
        .where((workEstimate) => workEstimate.filtered(
            this.filterSearchString, this.filterStatus, this.filterCarBrand))
        .toList();
    notifyListeners();
    return workEstimates;
  }
}
