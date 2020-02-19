import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-review.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:enginizer_flutter/modules/appointments/services/provider.service.dart';
import 'package:flutter/cupertino.dart';

class ServiceProviderDetailsProvider with ChangeNotifier {
  ProviderService providerService = inject<ProviderService>();

  int serviceProviderId = 0;

  ServiceProvider serviceProvider;
  ServiceProviderItemsResponse serviceProviderItemsResponse;
  ServiceProviderReview serviceProviderReview;

  Future<ServiceProvider> getServiceProviderDetails(int providerId) async {
    this.serviceProvider =
        await this.providerService.getProviderDetails(providerId);
    notifyListeners();
    return this.serviceProvider;
  }

  Future<ServiceProviderItemsResponse> getServiceProviderItems(
      int providerId) async {
    this.serviceProviderItemsResponse =
        await this.providerService.getProviderServiceItems(providerId);
    notifyListeners();
    return this.serviceProviderItemsResponse;
  }

  Future<ServiceProviderReview> getServiceProviderReviews(
      int providerId) async {
    this.serviceProviderReview =
        await this.providerService.getServiceProviderReviews(providerId);
    notifyListeners();
    return this.serviceProviderReview;
  }
}
