import 'dart:io';

import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/generic-model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/cars/enums/car-status.enum.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/promotions/models/promotion.model.dart';
import 'package:app/modules/promotions/models/request/create-promotion-request.model.dart';
import 'package:app/modules/promotions/services/promotion.service.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:app/modules/shared/managers/permissions/permissions-promotions.dart';
import 'package:flutter/cupertino.dart';

class CreatePromotionProvider with ChangeNotifier {
  PromotionService _promotionService = inject<PromotionService>();
  ProviderService _providerService = inject<ProviderService>();
  CarService _carService = inject<CarService>();

  GlobalKey<FormState> informationFormState;

  CreatePromotionRequest createPromotionRequest;

  ServiceProviderItemsResponse serviceProviderItemsResponse;

  List<Car> cars = [];

  initialise(int providerId,
      {Promotion promotion, Car car, ServiceProviderItem serviceProviderItem}) {
    informationFormState = null;
    serviceProviderItemsResponse = null;
    cars = [];

    createPromotionRequest = CreatePromotionRequest(providerId,
        promotion: promotion,
        car: car,
        presetServiceProviderItem: serviceProviderItem);
  }

  Future<ServiceProviderItemsResponse> loadServices(String type) async {
    try {
      var response = await _providerService.getServices(type);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }

  Future<ServiceProviderItemsResponse> getServiceProviderItems(
      int providerId) async {
    try {
      this.serviceProviderItemsResponse =
          await this._providerService.getProviderServiceItems(providerId);
      notifyListeners();

      List<ServiceProviderItem> list = [];

      this.serviceProviderItemsResponse.items.forEach((item) {
        if (PermissionsManager.getInstance().hasAccess(
            MainPermissions.Promotions,
            PermissionsPromotion.SELLER_PROMOTION)) {
          if (item.isSellerService()) {
            list.add(item);
          }
        } else {
          list.add(item);
        }
      });

      this.serviceProviderItemsResponse.items = list;

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

  Future<Car> createCarPromotion(
      CreatePromotionRequest createPromotionRequest) async {
    try {
      Car car = await this._carService.sellCar(createPromotionRequest);
      notifyListeners();
      return car;
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

  Future<List<Car>> getCars({String filterValue = ''}) async {
    try {
      var response = await this._carService.getCars();
      cars = response.items;

      cars = cars.where((car) {
        bool value = car.status == CarStatus.Pending;

        if (filterValue.isNotEmpty) {
          value = value && car.filtered(filterValue);
        }

        return value;
      }).toList();

      notifyListeners();
      return cars;
    } catch (error) {
      throw (error);
    }
  }
}
