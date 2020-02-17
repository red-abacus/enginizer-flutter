import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/auctions/models/work-estimate-details.model.dart';
import 'package:enginizer_flutter/modules/auctions/services/work-estimates.service.dart';
import 'package:flutter/foundation.dart';

class WorkEstimatesProvider with ChangeNotifier {
  WorkEstimatesService workEstimatesService = inject<WorkEstimatesService>();

  WorkEstimateDetails workEstimateDetails;

  Future<WorkEstimateDetails> getWorkEstimateDetails(int workEstimateId) async {
    workEstimateDetails =
        await this.workEstimatesService.getWorkEstimateDetails(workEstimateId);
    return workEstimateDetails;
  }

  void resetParameters() {
    workEstimateDetails = null;
  }
}
