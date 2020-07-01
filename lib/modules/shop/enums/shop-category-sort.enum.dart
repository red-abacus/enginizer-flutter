import 'package:app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

class ShopCategorySortUtils {
  static String title(BuildContext context, ShopCategorySort shopCategorySort) {
    switch (shopCategorySort) {
      case ShopCategorySort.DATE:
        return S.of(context).general_date;
      case ShopCategorySort.PRICE:
        return S.of(context).general_price;
    }

    return '';
  }

  static String value(ShopCategorySort shopCategorySort) {
    switch (shopCategorySort) {
      case ShopCategorySort.PRICE:
        return 'price';
        break;
      case ShopCategorySort.DATE:
        return 'endDate';
        break;
    }
  }

  static List<ShopCategorySort> getList() {
    return [ShopCategorySort.PRICE, ShopCategorySort.DATE];
  }
}

enum ShopCategorySort { PRICE, DATE }
