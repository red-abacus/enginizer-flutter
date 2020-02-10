import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-provider-type.dart';
import 'package:enginizer_flutter/modules/appointments/model/issue-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-item.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-timeserie.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/service-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/time-entry.dart';
import 'package:enginizer_flutter/modules/appointments/services/appointments.service.dart';
import 'package:enginizer_flutter/modules/appointments/services/provider.service.dart';
import 'package:enginizer_flutter/modules/authentication/models/user-credentials.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:flutter/widgets.dart';

class ProviderServiceProvider with ChangeNotifier {
  Car car;

  List<ServiceItem> serviceItems = [];
  List<ServiceProvider> serviceProviders = [];
  List<ServiceProviderItem> serviceProviderItems = [];
  List<ServiceProviderSchedule> serviceProviderSchedules = [];

  List<IssueItem> issuesFormState = [IssueItem(id: null, description: '')];

  ServiceProvider selectedProvider;

  ProviderService providerService = inject<ProviderService>();
  AppointmentsService appointmentsService = inject<AppointmentsService>();

  // form entry
  List<ServiceItem> selectedServiceItems = [];
  DateEntry dateEntry;
  AppointmentProviderType appointmentProviderType =
      AppointmentProviderType.Specific;
  UserCredentials userCredentials;

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

  Future<List<ServiceProviderItem>> loadProviderServices(
      ServiceProvider serviceProvider) async {
    var response =
        await appointmentsService.getServiceProviderItems(serviceProvider);
    serviceProviderItems = response.items;
    return serviceProviderItems;
  }

  Future<List<ServiceProviderSchedule>> loadProviderSchedules(
      ServiceProvider serviceProvider) async {
    var providerId;
    if (serviceProvider != null) {
      providerId = serviceProvider.id;
    }

    var response = await providerService.getProviderSchedules(providerId);
    serviceProviderSchedules = response;
    return serviceProviderSchedules;
  }
}
