import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/shop/enums/shop-category-sort.enum.dart';
import 'package:app/modules/shop/enums/shop-item-type.enum.dart';

class ShopItemRequest {
  String searchString;
  ServiceProviderItem serviceProviderItem;
  int pageSize = 20;
  int currentPage = 0;
  ShopItemType shopItemType;
  ShopCategorySort searchSort;

  ShopItemRequest(this.shopItemType);

  // TODO - need to discuss with API guys
  // TODO - If type is set there, search is not available
  // TODO - Price filtering
  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'pageSize': pageSize.toString(),
      'page': currentPage.toString()
    };

    if (searchString != null && searchString.isNotEmpty) {
      propMap['search'] = searchString;
    }

    if (serviceProviderItem != null) {
      propMap['serviceId'] = serviceProviderItem.id;
    }

    if (this.shopItemType != null) {
      propMap['type'] = ShopItemTypeUtils.value(this.shopItemType);
    }

    if (searchSort != null) {
      propMap['sortBy'] = ShopCategorySortUtils.value(searchSort);
    }

    return propMap;
  }
}
