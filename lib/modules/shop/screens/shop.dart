import 'package:app/modules/auctions/models/auction.model.dart';
import 'package:app/modules/auctions/providers/auction-provider.dart';
import 'package:app/modules/auctions/providers/auctions-provider.dart';
import 'package:app/modules/auctions/screens/auction-details.dart';
import 'package:app/modules/shop/enums/shop-category-sort.enum.dart';
import 'package:app/modules/shop/enums/shop-category-type.enum.dart';
import 'package:app/modules/shop/models/shop-category.model.dart';
import 'package:app/modules/shop/providers/shop.provider.dart';
import 'package:app/modules/shop/widgets/shop-list.widget.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer<AuctionsProvider>(
      builder: (context, appointmentsProvider, _) => Scaffold(
        body: Center(
          child: _renderAuctions(_isLoading),
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

  _renderAuctions(bool _isLoading) {
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
}
