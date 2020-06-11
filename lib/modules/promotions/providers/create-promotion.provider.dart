import 'dart:io';

import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/generic-model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/promotions/models/promotion.model.dart';
import 'package:app/modules/promotions/models/request/create-promotion-request.model.dart';
import 'package:app/modules/promotions/services/promotion.service.dart';
import 'package:flutter/cupertino.dart';

class CreatePromotionProvider with ChangeNotifier {
  PromotionService _promotionService = inject<PromotionService>();
  ProviderService _providerService = inject<ProviderService>();

  GlobalKey<FormState> informationFormState;

  CreatePromotionRequest createPromotionRequest;

  ServiceProviderItemsResponse serviceProviderItemsResponse;

  initialise(int providerId, {Promotion promotion}) {
    informationFormState = null;
    serviceProviderItemsResponse = null;

    createPromotionRequest =
        CreatePromotionRequest(providerId, promotion: promotion);
  }

  Future<ServiceProviderItemsResponse> getServiceProviderItems(
      int providerId) async {
    try {
      this.serviceProviderItemsResponse =
          await this._providerService.getProviderServiceItems(providerId);
      notifyListeners();
      return this.serviceProviderItemsResponse;
    } catch (error) {
      throw (error);
    }
  }

  Future<Promotion> addPromotion(
      CreatePromotionRequest createPromotionRequest) async {
    try {
      Promotion promotion =
          await this._promotionService.addPromotion(createPromotionRequest);
      notifyListeners();
      return promotion;
    } catch (error) {
      throw (error);
    }
  }

  Future<Promotion> editPromotion(
      CreatePromotionRequest createPromotionRequest) async {
    try {
      Promotion promotion =
          await this._promotionService.editPromotion(createPromotionRequest);
      notifyListeners();
      return promotion;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<GenericModel>> addPromotionImages(
      int providerId, int promotionId, List<File> images) async {
    try {
      List<GenericModel> items = await this
          ._promotionService
          .addPromotionImages(providerId, promotionId, images);
      notifyListeners();
      return items;
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> deletePromotionImage(
      int providerId, int promotionId, int imageId) async {
    try {
      bool response = await this
          ._promotionService
          .deletePromotionImage(providerId, promotionId, imageId);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }
}
