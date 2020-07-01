import 'package:app/modules/work-estimate-form/enums/work-estimate-status.enum.dart';
import 'package:app/modules/work-estimates/enums/work-estimate-sort.enum.dart';
import 'package:app/utils/date_utils.dart';

class WorkEstimatesRequest {
  String searchString;
  DateTime startDate;
  DateTime endDate;
  WorkEstimateStatus workEstimateStatus;
  WorkEstimateSort workEstimateSort;
  int pageSize = 20;
  int currentPage = 0;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'pageSize': pageSize.toString(),
      'page': currentPage.toString()
    };

    if (searchString != null && searchString.isNotEmpty) {
      propMap['search'] = searchString;
    }

    if (startDate != null) {
      propMap['startDate'] = DateUtils.stringFromDate(startDate, 'dd/MM/yyyy');
    }

    if (endDate != null) {
      propMap['endDate'] = DateUtils.stringFromDate(endDate, 'dd/MM/yyyy');
    }

    if (workEstimateStatus != null) {
      String value = WorkEstimateStatusUtils.value(workEstimateStatus);

      if (value != null) {
        propMap['status'] = value;
      }
    }

    if (workEstimateSort != null) {
      propMap['sortBy'] = WorkEstimateSortUtils.value(workEstimateSort);
    }

    propMap['isSortingAscending'] = false;

    return propMap;
  }
}
