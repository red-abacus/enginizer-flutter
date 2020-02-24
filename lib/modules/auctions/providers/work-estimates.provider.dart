import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/auctions/models/work-estimate-details.model.dart';
import 'package:enginizer_flutter/modules/auctions/services/work-estimates.service.dart';
import 'package:flutter/foundation.dart';

class WorkEstimatesProvider with ChangeNotifier {
  static final Map<String, dynamic> initialEstimatorFormState = {
    'type': null,
    'code': null,
    'name': null,
    'quantity': '',
    'price': '',
    'priceVAT': ''
  };

  WorkEstimatesService workEstimatesService = inject<WorkEstimatesService>();

  WorkEstimateDetails workEstimateDetails;

  Map<String, dynamic> estimatorFormState = Map.from(initialEstimatorFormState);

  void initValues() {
    estimatorFormState = Map.from(initialEstimatorFormState);
  }

  Future<WorkEstimateDetails> getWorkEstimateDetails(int workEstimateId) async {
    workEstimateDetails =
        await this.workEstimatesService.getWorkEstimateDetails(workEstimateId);
    notifyListeners();
    return workEstimateDetails;
  }
}
