import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/provider/service-provider-review.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/appointments/model/response/service-provider-items-response.model.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/authentication/models/provider-schedule.model.dart';
import 'package:flutter/cupertino.dart';

class ServiceProviderDetailsProvider with ChangeNotifier {
  ProviderService providerService = inject<ProviderService>();

  int serviceProviderId = 0;

  ServiceProvider serviceProvider;
  ServiceProviderItemsResponse serviceProviderItemsResponse;
  ServiceProviderReview serviceProviderReview;
  List<ProviderSchedule> providerSchedule = [];

  initialise() {
    serviceProvider = null;
    serviceProviderItemsResponse = null;
    serviceProviderReview = null;
    providerSchedule = [];
  }

  Future<ServiceProvider> getServiceProviderDetails(int providerId) async {
    try {
      this.serviceProvider =
      await this.providerService.getProviderDetails(providerId);
      notifyListeners();
      return this.serviceProvider;
    } catch (error) {
      throw(error);
    }
  }

  Future<ServiceProviderItemsResponse> getServiceProviderItems(
      int providerId) async {
    try {
      this.serviceProviderItemsResponse =
      await this.providerService.getProviderServiceItems(providerId);
      notifyListeners();
      return this.serviceProviderItemsResponse;
    } catch (error) {
      throw(error);
    }
  }

  Future<ServiceProviderReview> getServiceProviderReviews(
      int providerId) async {
    this.serviceProviderReview =
    await this.providerService.getServiceProviderReviews(providerId);
    notifyListeners();
    return this.serviceProviderReview;
  }

  Future<List<ProviderSchedule>> getProviderSchedule(int providerId) async {
    try {
      this.providerSchedule =
      await this.providerService.getProviderSchedule(providerId);
      notifyListeners();
      return this.providerSchedule;
    } catch (error) {
      throw(error);
    }
  }
}
