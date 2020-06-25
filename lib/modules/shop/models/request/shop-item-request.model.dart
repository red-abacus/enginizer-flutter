import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';

class ShopItemRequest {
  String searchString;
  ServiceProviderItem serviceProviderItem;
  int pageSize = 20;
  int currentPage = 0;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'pageSize': pageSize.toString(),
      'page': currentPage.toString()
    };

    if (searchString != null && searchString.isNotEmpty) {
      propMap['search'] = searchString;
    }

    if (serviceProviderItem != null) {
      propMap['serviceId'] = serviceProviderItem;
    }

    return propMap;
  }
}
