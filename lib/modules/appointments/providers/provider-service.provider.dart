import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-issue.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-provider-type.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-timeserie.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-timetable.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/request/appointment-request.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/service-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/time-entry.dart';
import 'package:enginizer_flutter/modules/appointments/services/appointments.service.dart';
import 'package:enginizer_flutter/modules/appointments/services/provider.service.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-item-query.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/item-type.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/provider-item.model.dart';
import 'package:enginizer_flutter/modules/authentication/models/jwt-user.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:flutter/widgets.dart';

class ProviderServiceProvider with ChangeNotifier {
  JwtUser authUser;

  List<ServiceItem> serviceItems = [];
  List<ServiceProvider> serviceProviders = [];
  List<ServiceProviderItem> serviceProviderItems = [];
  List<ServiceProviderSchedule> serviceProviderSchedules = [];
  List<ItemType> itemTypes = [];
  List<ProviderItem> providerItems = [];

  ProviderService providerService = inject<ProviderService>();
  AppointmentsService appointmentsService = inject<AppointmentsService>();

  // Form entries
  Car selectedCar;
  List<ServiceItem> selectedServiceItems;
  List<AppointmentIssue> issuesFormState;
  AppointmentProviderType appointmentProviderType;
  ServiceProvider selectedProvider;
  DateEntry dateEntry;

  String pickupAddress = "";

  void initFormValues() {
    selectedCar = null;
    selectedServiceItems = [];
    issuesFormState = [AppointmentIssue(id: null, name: '')];
    appointmentProviderType = AppointmentProviderType.Specific;
    selectedProvider = null;
    dateEntry = null;
    pickupAddress = "";
  }

  Future<List<ServiceItem>> loadServices() async {
    var response = await providerService.getServices();
    serviceItems = response.items;
    notifyListeners();
    return serviceItems;
  }

  Future<List<ServiceProvider>> loadProviders() async {
    var response = await providerService.getProviders();
    serviceProviders = response.items;
    notifyListeners();
    return serviceProviders;
  }

  Future<List<ServiceProvider>> loadProvidersByServiceItems(
      List<int> servicesIds) async {
    var response = await providerService.getProvidersByServices(servicesIds);
    serviceProviders = response.items;
    notifyListeners();
    return serviceProviders;
  }

  Future<List<ServiceProviderItem>> loadProviderServices(
      ServiceProvider serviceProvider) async {
    var response =
        await appointmentsService.getServiceProviderItems(serviceProvider.id);
    serviceProviderItems = response.items;
    notifyListeners();
    return serviceProviderItems;
  }

  Future<List<ServiceProviderSchedule>> loadProviderSchedules(
      ServiceProvider serviceProvider) async {
    var response =
        await providerService.getProviderSchedules(serviceProvider.id);
    serviceProviderSchedules = response;
    notifyListeners();
    return serviceProviderSchedules;
  }

  Future<List<ServiceProviderTimetable>> loadServiceProviderTimetables(
      ServiceProvider serviceProvider, String startDate, String endDate) async {
    var response = await providerService.getServiceProviderTimetables(
        serviceProvider.id, startDate, endDate);
    serviceProvider.timetables = response;
    notifyListeners();
    return response;
  }

  Future<List<ItemType>> loadItemTypes() async {
    var response = await providerService.getItemTypes();
    itemTypes = response;
    notifyListeners();
    return response;
  }

  Future<List<ProviderItem>> loadProviderItems(
      ServiceProvider serviceProvider, IssueItemQuery query) async {
    var response = await providerService.getProviderItems(
        serviceProvider.id, query.toJson());
    providerItems = response;
    notifyListeners();
    return response;
  }

  AppointmentRequest appointmentRequest() {
    AppointmentRequest appointmentRequest = AppointmentRequest();

    appointmentRequest.userId = authUser.userId;
    appointmentRequest.carId = selectedCar.id;

    appointmentRequest.issues = [];
    for (AppointmentIssue item in issuesFormState) {
      appointmentRequest.issues.add(item.name);
    }

    appointmentRequest.serviceIds = [];

    for (ServiceItem item in selectedServiceItems) {
      appointmentRequest.serviceIds.add(item.id);
    }

    appointmentRequest.address = "";
    bool pickupSet = false;

    if (pickUpServiceValidation()) {
      appointmentRequest.address = pickupAddress;
      pickupSet = true;
    }

    if (selectedProvider != null) {
      appointmentRequest.providerId = selectedProvider.id;

      if (!pickupSet) {
        appointmentRequest.address = selectedProvider.address;
      }
    }

    appointmentRequest.scheduledTimes = [dateEntry.dateForAppointment()];
    return appointmentRequest;
  }

  bool containsPickUpService() {
    for (ServiceItem serviceItem in this.selectedServiceItems) {
      if (serviceItem.name == "PICKUP_RETURN") {
        return true;
      }
    }

    return false;
  }

  bool pickUpServiceValidation() {
    for (ServiceItem serviceItem in this.selectedServiceItems) {
      if (serviceItem.name == "PICKUP_RETURN") {
        if (this.pickupAddress.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      }
    }

    return true;
  }
}
