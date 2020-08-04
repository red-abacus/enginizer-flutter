import 'package:app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

class WorkEstimateSortUtils {
  static String value(WorkEstimateSort sort) {
    switch (sort) {
      case WorkEstimateSort.CreatedDate:
        return 'createdDate';
      case WorkEstimateSort.Status:
        return 'status';
    }
  }

  static String title(BuildContext context, WorkEstimateSort sort) {
    switch (sort) {
      case WorkEstimateSort.CreatedDate:
        return S.of(context).work_estimate_sort_created_date;
      case WorkEstimateSort.Status:
        return S.of(context).work_estimate_sort_status;
    }
  }

  static list() {
    return [WorkEstimateSort.CreatedDate, WorkEstimateSort.Status];
  }
}

enum WorkEstimateSort { CreatedDate, Status }
