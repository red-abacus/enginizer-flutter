import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/issue-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/service-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/service-provider.model.dart';
import 'package:enginizer_flutter/modules/appointments/services/provider.service.dart';
import 'package:flutter/widgets.dart';

class ProviderServiceProvider with ChangeNotifier {
  List<ServiceItem> serviceItems = [];
  List<ServiceProvider> serviceProviders = [];

  // Form states
  Map<String, dynamic> providerServiceFormState = {};
  List<IssueItem> issuesFormState = [IssueItem(id: null, description: '')];
  ServiceProvider selectedProvider;

  ProviderService providerService = inject<ProviderService>();

  Future<List<ServiceItem>> loadServices() async {
    var response = await providerService.getServices();
    serviceItems = response.items;
    return serviceItems;
  }

  Future<List<ServiceProvider>> loadProviders() async {
    var response = await providerService.getProviders();
    serviceProviders = response.items;
    return serviceProviders;
  }
}
