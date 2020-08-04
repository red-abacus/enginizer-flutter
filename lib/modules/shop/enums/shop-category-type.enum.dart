import 'package:app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

class ShopCategoryTypeUtils {
  static String title(BuildContext context, ShopCategoryType shopCategoryType) {
    switch (shopCategoryType) {
      case ShopCategoryType.PRODUCTS:
        return S.of(context).online_shop_products_category_type;
      case ShopCategoryType.SERVICES:
        return S.of(context).online_shop_services_category_type;
    }

    return '';
  }
}

enum ShopCategoryType { SERVICES, PRODUCTS }