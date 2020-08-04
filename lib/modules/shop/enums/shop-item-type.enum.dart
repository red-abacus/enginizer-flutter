class ShopItemTypeUtils {
  static ShopItemType type(String text) {
    switch (text) {
      case 'PROMOTION':
        return ShopItemType.Promotion;
      case 'CAR':
        return ShopItemType.Car;
    }

    return null;
  }

  static String value(ShopItemType type) {
    switch (type) {
      case ShopItemType.Promotion:
        return 'PROMOTION';
        break;
      case ShopItemType.Car:
        return 'CAR';
        break;
    }
  }
}

enum ShopItemType { Promotion, Car }
