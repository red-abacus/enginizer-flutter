import 'package:app/generated/l10n.dart';
import 'package:app/modules/auctions/providers/auctions-provider.dart';
import 'package:app/modules/cars/providers/cars-make.provider.dart';
import 'package:app/modules/shop/enums/shop-category-sort.enum.dart';
import 'package:app/modules/shop/enums/shop-category-type.enum.dart';
import 'package:app/modules/shop/enums/shop-list-type.enum.dart';
import 'package:app/modules/shop/models/shop-category.model.dart';
import 'package:app/modules/shop/providers/shop.provider.dart';
import 'package:app/modules/shop/screens/shop-alert-create.modal.dart';
import 'package:app/modules/shop/screens/shop-product-details.dart';
import 'package:app/modules/shop/screens/shop-service-details.dart';
import 'package:app/modules/shop/widgets/shop-list.widget.dart';
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
            S.of(context).general_alert,
            style: TextHelper.customTextStyle(null, Colors.white, null, 12),
          ),
          icon: Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<ShopProvider>(context);
    }

    _initDone = true;
    super.didChangeDependencies();
  }

  _renderList(bool _isLoading) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ShopListWidget(
            searchString: _provider.searchString,
            searchShopCategories: _provider.searchCategories,
            categories: _provider.categories,
            filterShopItems: _filterShopItems,
            searchCategorySort: _provider.searchSort,
            shopCategoryType: shopCategoryType,
            selectCategoryType: _selectCategoryType,
            selectShopItem: _selectShopItem,
            shopListType: _shopListType,
            selectListType: _selectListType,
          );
  }

  _filterShopItems(String value, List<ShopCategory> categories,
      ShopCategorySort shopCategorySort) {
    setState(() {
      _provider.filterShopItems(value, categories, shopCategorySort);
    });
  }

  _selectCategoryType(ShopCategoryType categoryType) {
    setState(() {
      _provider.initialiseParameters();
      this.shopCategoryType = categoryType;
    });
  }

  _selectShopItem() {
    if (shopCategoryType == ShopCategoryType.SERVICES) {
      Navigator.of(context).pushNamed(ShopServiceDetails.route);
    } else {
      Navigator.of(context).pushNamed(ShopProductDetails.route);
    }
  }

  _selectListType(ShopListType shopListType) {
    setState(() {
      _shopListType = shopListType;
    });
  }

  _openShopAlertModal() {
    Provider.of<CarsMakeProvider>(context).initParams();

    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return ShopAlertCreateModal();
          });
        });
  }
}
