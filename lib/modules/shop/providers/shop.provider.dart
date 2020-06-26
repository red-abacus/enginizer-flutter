import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/screens/car.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/shop/enums/shop-category-sort.enum.dart';
import 'package:app/modules/shop/enums/shop-category-type.enum.dart';
import 'package:app/modules/shop/enums/shop-item-type.enum.dart';
import 'package:app/modules/shop/models/request/shop-item-request.model.dart';
import 'package:app/modules/shop/models/response/shop-item-response.model.dart';
import 'package:app/modules/shop/models/shop-alert.model.dart';
import 'package:app/modules/shop/models/shop-item.model.dart';
import 'package:app/modules/shop/services/shop.service.dart';
import 'package:flutter/cupertino.dart';

class ShopProvider with ChangeNotifier {
  ShopService _shopService = inject<ShopService>();
  ProviderService _providerService = inject<ProviderService>();
  CarService _carService = inject<CarService>();

  List<ShopAlert> alerts = [];
  List<ShopItem> serviceItems = [];
  List<ShopItem> productItems = [];

  ShopItemRequest shopServiceItemRequest;
  ShopItemRequest shopProductItemRequest;

  ShopItemResponse _shopServiceItemResponse;
  ShopItemResponse _shopProductItemResponse;

  ServiceProviderItemsResponse serviceProviderItemsResponse;

  ShopItem selectedShopItem;

  Car carDetails;

  bool initDone = false;

  void initialise() {
    shopServiceItemRequest = ShopItemRequest(ShopItemType.Promotion);
    shopProductItemRequest = ShopItemRequest(ShopItemType.Car);

    selectedShopItem = null;

    _shopServiceItemResponse = null;
    alerts = [];
    serviceItems = [];
    productItems = [];
    serviceProviderItemsResponse = null;
  }

  Future<List<ShopItem>> getShopServiceItems() async {
    if (!shouldDownloadService()) {
      return null;
    }

    try {
      _shopServiceItemResponse =
          await _shopService.getShopItems(shopServiceItemRequest);
      shopServiceItemRequest.currentPage += 1;
      this.serviceItems.addAll(_shopServiceItemResponse.items);
      notifyListeners();
      return this.serviceItems;
    } catch (error) {
      throw (error);
    }
  }

  bool shouldDownloadService() {
    if (_shopServiceItemResponse != null) {
      if (shopServiceItemRequest.currentPage >=
          _shopServiceItemResponse.totalPages) {
        return false;
      }
    }

    return true;
  }

  Future<List<ShopItem>> getShopProductItems() async {
    if (!shouldDownloadProduct()) {
      return null;
    }

    try {
      _shopProductItemResponse =
          await _shopService.getShopItems(shopProductItemRequest);
      shopProductItemRequest.currentPage += 1;
      this.productItems.addAll(_shopProductItemResponse.items);
      notifyListeners();
      return this.productItems;
    } catch (error) {
      throw (error);
    }
  }

  bool shouldDownloadProduct() {
    if (_shopProductItemResponse != null) {
      if (shopProductItemRequest.currentPage >=
          _shopProductItemResponse.totalPages) {
        return false;
      }
    }

    return true;
  }

  void filterShopItems(
      ShopCategoryType type,
      String searchString,
      ServiceProviderItem serviceProviderItem,
      ShopCategorySort shopCategorySort) {
    switch (type) {
      case ShopCategoryType.SERVICES:
        _shopServiceItemResponse = null;
        serviceItems = [];
        shopServiceItemRequest = ShopItemRequest(ShopItemType.Promotion);
        shopServiceItemRequest.searchString = searchString;
        shopServiceItemRequest.serviceProviderItem = serviceProviderItem;
        shopServiceItemRequest.searchSort = shopCategorySort;
        break;
      case ShopCategoryType.PRODUCTS:
        _shopProductItemResponse = null;
        productItems = [];
        shopProductItemRequest = ShopItemRequest(ShopItemType.Car);
        shopProductItemRequest.searchString = searchString;
        shopProductItemRequest.serviceProviderItem = serviceProviderItem;
        shopProductItemRequest.searchSort = shopCategorySort;
        break;
    }
  }

  Future<List<ShopAlert>> getShopAlerts() async {
    try {
      this.alerts = await _shopService.getShopAlerts();
      notifyListeners();
      return this.alerts;
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> removeShopAlert(ShopAlert shopAlert) async {
    try {
      bool response = await _shopService.removeShopAlert(shopAlert);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }

  Future<ServiceProviderItemsResponse> loadServices() async {
    try {
      this.serviceProviderItemsResponse =
          await _providerService.getServices(null);
      notifyListeners();
      return serviceProviderItemsResponse;
    } catch (error) {
      throw (error);
    }
  }

  Future<Car> getCarDetails(int carId) async {
    try {
      carDetails = await _carService.getCarDetails(carId);
      notifyListeners();
      return carDetails;
    } catch (error) {
      throw (error);
    }
  }
}
