import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-provider-type.dart';
import 'package:enginizer_flutter/modules/appointments/model/issue-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-item.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-timeserie.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-timetable.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/request/appointment-request.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/service-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/time-entry.dart';
import 'package:enginizer_flutter/modules/appointments/services/appointments.service.dart';
import 'package:enginizer_flutter/modules/appointments/services/provider.service.dart';
import 'package:enginizer_flutter/modules/authentication/models/jwt-user.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:flutter/widgets.dart';

class ProviderServiceProvider with ChangeNotifier {
  JwtUser authUser;
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

  Future<List<ServiceProvider>> loadProvidersByServiceItems(List<int> servicesIds) async {
    var response = await providerService.getProvidersByServices(servicesIds);
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
    var response =
        await providerService.getProviderSchedules(serviceProvider.id);
    serviceProviderSchedules = response;
    return serviceProviderSchedules;
  }

  Future<List<ServiceProviderTimetable>> loadServiceProviderTimetables(
      ServiceProvider serviceProvider, String startDate, String endDate) async {
    var response = await providerService.getServiceProviderTimetables(
        serviceProvider.id, startDate, endDate);
    serviceProvider.timetables = response;
    return response;
  }

  AppointmentRequest appointmentRequest() {
    AppointmentRequest appointmentRequest = AppointmentRequest();

    appointmentRequest.userId = authUser.userId;
    appointmentRequest.carId = car.id;

    appointmentRequest.issues = [];
    for (IssueItem item in issuesFormState) {
      appointmentRequest.issues.add(item.description);
    }

    appointmentRequest.serviceIds = [];

    for (ServiceItem item in selectedServiceItems) {
      appointmentRequest.serviceIds.add(item.id);
    }

    if (selectedProvider != null) {
      appointmentRequest.providerId = selectedProvider.id;
      appointmentRequest.address = selectedProvider.address;
    } else {
      appointmentRequest.address = "";
    }

    appointmentRequest.scheduledTimes = [dateEntry.dateForAppointment()];
    return appointmentRequest;
  }
}
