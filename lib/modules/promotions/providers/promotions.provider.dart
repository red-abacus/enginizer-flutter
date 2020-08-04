import 'package:app/config/injection.dart';
import 'package:app/modules/promotions/enum/promotion-status.enum.dart';
import 'package:app/modules/promotions/models/promotion.model.dart';
import 'package:app/modules/promotions/models/request/promotions-request.model.dart';
import 'package:app/modules/promotions/models/response/promotions.response.dart';
import 'package:app/modules/promotions/services/promotion.service.dart';
import 'package:flutter/cupertino.dart';

class PromotionsProvider with ChangeNotifier {
  PromotionService _promotionService = inject<PromotionService>();
  PromotionsRequest promotionsRequest;
  PromotionsResponse _promotionsResponse;
  List<Promotion> promotions = [];

  bool initDone = false;

  void initialise() {
    promotions = [];
    initDone = false;
    promotionsRequest = PromotionsRequest();
  }

  bool shouldDownload() {
    if (_promotionsResponse != null) {
      if (promotionsRequest.currentPage >= _promotionsResponse.totalPages) {
        return false;
      }
    }

    return true;
  }

  Future<List<Promotion>> getPromotions() async {
    if (!shouldDownload()) {
      return null;
    }

    try {
      this._promotionsResponse =
          await this._promotionService.getPromotions(promotionsRequest);
      this.promotions.addAll(this._promotionsResponse.items);
      promotionsRequest.currentPage += 1;
      notifyListeners();
      return promotions;
    } catch (error) {
      throw (error);
    }
  }

  void filterPromotions(
      int providerId, String searchString, PromotionStatus status) {
    _promotionsResponse = null;
    promotions = [];
    promotionsRequest = PromotionsRequest();
    promotionsRequest.providerId = providerId;
    promotionsRequest.searchString = searchString;
    promotionsRequest.status = status;
  }
}
