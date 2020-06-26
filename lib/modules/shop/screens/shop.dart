import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/providers/auctions-provider.dart';
import 'package:app/modules/shop/enums/shop-category-sort.enum.dart';
import 'package:app/modules/shop/enums/shop-category-type.enum.dart';
import 'package:app/modules/shop/enums/shop-item-type.enum.dart';
import 'package:app/modules/shop/enums/shop-list-type.enum.dart';
import 'package:app/modules/shop/models/shop-item.model.dart';
import 'package:app/modules/shop/providers/shop.provider.dart';
import 'package:app/modules/shop/screens/shop-alerts.dart';
import 'package:app/modules/shop/screens/shop-product-details.dart';
import 'package:app/modules/shop/screens/shop-service-details.dart';
import 'package:app/modules/shop/services/shop.service.dart';
import 'package:app/modules/shop/widgets/shop-list.widget.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Shop extends StatefulWidget {
  static const String route = '/shop';
  static final IconData icon = Icons.shopping_cart;

  @override
  State<StatefulWidget> createState() {
    return ShopState(route: route);
  }
}

class ShopState extends State<Shop> {
  String route;
  var _initDone = false;
  var _isLoading = false;

  ShopProvider _provider;

  ShopState({this.route});

  ShopCategoryType shopCategoryType = ShopCategoryType.SERVICES;
  ShopListType _shopListType = ShopListType.List;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuctionsProvider>(
      builder: (context, appointmentsProvider, _) => Scaffold(
        body: Center(
          child: _renderList(_isLoading),
        ),
        floatingActionButton: FloatingActionButton.extended(
            heroTag: null,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 1,
            onPressed: () => _openShopAlertModal(),
            label: Text(
              S.of(context).general_alerts,
              style: TextHelper.customTextStyle(color: Colors.white, size: 12),
            )),
      ),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    _provider = Provider.of<ShopProvider>(context);
    _initDone = _initDone == false ? false : _provider.initDone;

    if (!_initDone) {
      _provider.initialise();

      setState(() {
        _isLoading = true;
      });

      try {
        await _provider.loadServices().then((_) async {
          _loadData();
        });
      } catch (error) {
        if (error.toString().contains(ProviderService.GET_SERVICES_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_get_services, context);
        }

        setState(() {
          _isLoading = false;
        });
        _loadData();
      }
    }

    _initDone = true;
    _provider.initDone = true;

    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      if (shopCategoryType == ShopCategoryType.SERVICES) {
        await _provider.getShopServiceItems().then((_) async {
          setState(() {
            _isLoading = false;
          });
        });
      } else if (shopCategoryType == ShopCategoryType.PRODUCTS) {
        await _provider.getShopProductItems().then((_) async {
          setState(() {
            _isLoading = false;
          });
        });
      }
    } catch (error) {
      if (error.toString().contains(ShopService.GET_SHOP_ITEMS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_shop_items, context);
      }
    }
  }

  _renderList(bool _isLoading) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : shopCategoryType == ShopCategoryType.SERVICES
            ? ShopListWidget(
                shouldDownload: _provider.shouldDownloadService(),
                downloadNextPage: _loadData,
                searchString: _provider.shopServiceItemRequest.searchString,
                serviceProviderItems:
                    _provider.serviceProviderItemsResponse.items,
                selectedServiceProviderItem:
                    _provider.shopServiceItemRequest.serviceProviderItem,
                filterShopItems: _filterShopItems,
                searchCategorySort: _provider.shopServiceItemRequest.searchSort,
                shopCategoryType: shopCategoryType,
                selectCategoryType: _selectCategoryType,
                selectShopItem: _selectShopItem,
                shopListType: _shopListType,
                selectListType: _selectListType,
                items: _provider.serviceItems,
              )
            : ShopListWidget(
                shouldDownload: _provider.shouldDownloadProduct(),
                downloadNextPage: _loadData,
                searchString: _provider.shopProductItemRequest.searchString,
                serviceProviderItems: [],
                selectedServiceProviderItem: null,
                filterShopItems: _filterShopItems,
                searchCategorySort: _provider.shopProductItemRequest.searchSort,
                shopCategoryType: shopCategoryType,
                selectCategoryType: _selectCategoryType,
                selectShopItem: _selectShopItem,
                shopListType: _shopListType,
                selectListType: _selectListType,
                items: _provider.productItems,
              );
  }

  _filterShopItems(String value, ServiceProviderItem serviceProviderItem,
      ShopCategorySort shopCategorySort) {
    _provider.filterShopItems(
        this.shopCategoryType, value, serviceProviderItem, shopCategorySort);
    _loadData();
  }

  _selectCategoryType(ShopCategoryType categoryType) {
    setState(() {
      this.shopCategoryType = categoryType;
    });

    switch (categoryType) {
      case ShopCategoryType.SERVICES:
        if (_provider.shopServiceItemRequest.searchString != null &&
            _provider.shopServiceItemRequest.searchString.isNotEmpty) {
          _provider.filterShopItems(categoryType, '', null, null);
          _loadData();
        }
        break;
      case ShopCategoryType.PRODUCTS:
        if (_provider.shopProductItemRequest.searchString != null &&
            _provider.shopProductItemRequest.searchString.isNotEmpty) {
          _provider.filterShopItems(categoryType, '', null, null);
          _loadData();
        } else if (_provider.productItems.length == 0) {
          _loadData();
        }
        break;
    }
  }

  _selectShopItem(ShopItem shopItem) {
    _provider.selectedShopItem = shopItem;

    switch (ShopItemTypeUtils.type(shopItem.type)) {
      case ShopItemType.Promotion:
        Navigator.of(context).pushNamed(ShopServiceDetails.route);
        break;
      case ShopItemType.Car:
        Navigator.of(context).pushNamed(ShopProductDetails.route);
        break;
    }
  }

  _selectListType(ShopListType shopListType) {
    setState(() {
      _shopListType = shopListType;
    });
  }

  _openShopAlertModal() {
    Navigator.of(context).pushNamed(ShopAlerts.route);
  }
}
