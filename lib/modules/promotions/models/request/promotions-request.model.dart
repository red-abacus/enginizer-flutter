import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/promotions/enum/promotion-status.enum.dart';
import 'package:app/utils/date_utils.dart';

class PromotionsRequest {
  int providerId;
  String searchString;
  PromotionStatus status;
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

    // TODO - filtering with status does not work
    if (status != null) {
      propMap['status'] = PromotionStatusUtils.status(status);
    }

    return propMap;
  }
}