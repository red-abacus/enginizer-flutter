import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment-provider-type.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-timeserie.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-timetable.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/appointments/model/request/appointment-request.model.dart';
import 'package:app/modules/appointments/model/service-item.model.dart';
import 'package:app/modules/appointments/model/time-entry.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/models/estimator/issue-item-query.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/auctions/models/estimator/provider-item.model.dart';
import 'package:app/modules/authentication/models/jwt-user.model.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:flutter/widgets.dart';

class ProviderServiceProvider with ChangeNotifier {
  JwtUser authUser;

  List<ServiceItem> serviceItems = [];
  List<ServiceProvider> serviceProviders = [];
  List<ServiceProviderItem> serviceProviderItems = [];
  List<ServiceProviderSchedule> serviceProviderSchedules = [];
  List<ProviderItem> providerItems = [];

  ProviderService providerService = inject<ProviderService>();
  AppointmentsService appointmentsService = inject<AppointmentsService>();

  // Form entries
  Car selectedCar;
  List<ServiceItem> selectedServiceItems;
  List<Issue> issuesFormState;
  AppointmentProviderType appointmentProviderType;
  ServiceProvider selectedProvider;
  DateEntry dateEntry;

  String pickupAddress = "";

  void initFormValues() {
    selectedCar = null;
    selectedServiceItems = [];
    issuesFormState = [Issue(id: null, name: '')];
    appointmentProviderType = AppointmentProviderType.Specific;
    selectedProvider = null;
    dateEntry = null;
    pickupAddress = "";
  }

  Future<List<ServiceItem>> loadServices() async {
    try {
      var response = await providerService.getServices();
      serviceItems = response.items;
      notifyListeners();
      return serviceItems;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<ServiceProvider>> loadProviders() async {
    try {
      var response = await providerService.getProviders();
      serviceProviders = response.items;
      notifyListeners();
      return serviceProviders;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<ServiceProviderTimetable>> loadServiceProviderTimetables(
      ServiceProvider serviceProvider, String startDate, String endDate) async {
    try {
      var response = await providerService.getServiceProviderTimetables(
          serviceProvider.id, startDate, endDate);
      serviceProvider.timetables = response;
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<ProviderItem>> loadProviderItems(
      ServiceProvider serviceProvider, IssueItemQuery query) async {
    try {
      var response = await providerService.getProviderItems(
          serviceProvider.id, query.toJson());
      providerItems = response;
      notifyListeners();
      return response;
    } catch (error) {
      throw(error);
    }
  }

  AppointmentRequest appointmentRequest() {
    AppointmentRequest appointmentRequest = AppointmentRequest();

    appointmentRequest.userId = authUser.userId;
    appointmentRequest.carId = selectedCar.id;
    appointmentRequest.providerType = appointmentProviderType;

    appointmentRequest.issues = [];
    for (Issue item in issuesFormState) {
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

    appointmentRequest.scheduledTime = dateEntry.dateForAppointment();
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
