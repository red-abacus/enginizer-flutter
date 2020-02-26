import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/auctions/services/work-estimates.service.dart';
import 'package:enginizer_flutter/modules/cars/models/car-brand.model.dart';
import 'package:enginizer_flutter/modules/cars/services/car-make.service.dart';
import 'package:enginizer_flutter/modules/consultant-estimators/enums/work-estimate-status.enum.dart';
import 'package:enginizer_flutter/modules/consultant-estimators/models/responses/work-estimate-response.model.dart';
import 'package:enginizer_flutter/modules/consultant-estimators/models/work-estimate.model.dart';
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

  Future<List<WorkEstimate>> getWorkEstimates() async {
    _workEstimateResponse = await _workEstimatesService.getWorkEstimates();
    workEstimates = _workEstimateResponse.workEstimates;
    notifyListeners();
    return workEstimates;
  }

  Future<List<CarBrand>> loadCarBrands() async {
    carBrands = await _carMakeService.getCarBrands();
    return carBrands;
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
