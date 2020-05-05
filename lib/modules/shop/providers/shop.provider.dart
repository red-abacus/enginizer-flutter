import 'package:app/config/injection.dart';
import 'package:app/modules/shop/enums/shop-category-sort.enum.dart';
import 'package:app/modules/shop/models/shop-category.model.dart';
import 'package:app/modules/shop/services/shop.service.dart';
import 'package:flutter/cupertino.dart';

class ShopProvider with ChangeNotifier {
  ShopService _shopService = inject<ShopService>();

  String searchString;
  List<ShopCategory> searchCategories = [];
  List<ShopCategory> categories = ShopCategory.defaultCategories();
  ShopCategorySort searchSort;

  void initialiseParameters() {
    searchSort = null;
    searchCategories.clear();
    searchSort = null;
  }

  void filterShopItems(String searchString, List<ShopCategory> categories, ShopCategorySort shopCategorySort) {
    this.searchString = searchString;
    this.searchCategories = categories;
    this.searchSort = shopCategorySort;
  }
}
