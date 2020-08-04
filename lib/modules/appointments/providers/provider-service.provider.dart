import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/enum/create-appointment-state.enum.dart';
import 'package:app/modules/appointments/model/appointment-position.model.dart';
import 'package:app/modules/appointments/model/appointment/appointment-provider-type.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-timeserie.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-timetable.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/appointments/model/request/appointment-request.model.dart';
import 'package:app/modules/appointments/model/response/service-providers-response.model.dart';
import 'package:app/modules/appointments/model/personnel/time-entry.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/models/estimator/issue-item-query.model.dart';
import 'package:app/modules/cars/enums/car-status.enum.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/shared/widgets/horizontal-stepper.widget.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/auctions/models/estimator/provider-item.model.dart';
import 'package:app/modules/authentication/models/jwt-user.model.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/presentation/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProviderServiceProvider with ChangeNotifier {
  JwtUser authUser;

  CarService _carService = inject<CarService>();

  AppointmentPosition appointmentPosition;
  List<ServiceProviderItem> serviceItems = [];
  List<ServiceProvider> serviceProviders = [];
  List<ServiceProviderItem> serviceProviderItems = [];
  List<ServiceProviderSchedule> serviceProviderSchedules = [];
  List<ProviderItem> providerItems = [];

  ProviderService providerService = inject<ProviderService>();
  AppointmentsService appointmentsService = inject<AppointmentsService>();

  List<Car> cars;
  Car selectedCar;
  List<ServiceProviderItem> selectedServiceItems;
  List<Issue> issuesFormState;
  AppointmentProviderType appointmentProviderType;
  ServiceProvider selectedProvider;
  DateEntry dateEntry;
  CreateAppointmentState createAppointmentState;

  List<ServiceProviderTimetable> serviceProviderTimetable;

  Map<int, dynamic> stepStateData;

  int _currentPage = 0;
  final int _pageSize = 20;
  ServiceProviderResponse _serviceProviderResponse;

  AppointmentPosition pickupPosition = new AppointmentPosition();
  AppointmentPosition returnPosition = new AppointmentPosition();

  void initFormValues() {
    pickupPosition = new AppointmentPosition();
    returnPosition = new AppointmentPosition();
    serviceProviderTimetable = [];
    cars = [];
    appointmentPosition = AppointmentPosition();
    selectedCar = null;
    selectedServiceItems = [];
    issuesFormState = [Issue(id: null, name: '')];
    appointmentProviderType = AppointmentProviderType.Specific;
    selectedProvider = null;
    dateEntry = null;
    stepStateData = null;
    createAppointmentState = null;
  }

  resetServiceProviderParams() {
    serviceProviders = [];
    _currentPage = 0;
    _serviceProviderResponse = null;
  }

  Future<List<ServiceProviderItem>> loadServices(String type) async {
    try {
      var response = await providerService.getServices(type);
      serviceItems = response.items;
      notifyListeners();
      return serviceItems;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<ServiceProvider>> loadProviders() async {
    if (_serviceProviderResponse != null) {
      if (_currentPage >= _serviceProviderResponse.totalPages) {
        return null;
      }
    }

    List<String> serviceNames = [];

    selectedServiceItems.forEach((element) {
      serviceNames.add(element.name);
    });

    try {
      _serviceProviderResponse = await providerService.getProviders(
          pageSize: _pageSize, page: _currentPage, serviceNames: serviceNames);
      serviceProviders.addAll(_serviceProviderResponse.items);
      _currentPage += 1;
      notifyListeners();
      return serviceProviders;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<ServiceProviderTimetable>> loadServiceProviderTimetables(
      ServiceProvider serviceProvider, String startDate, String endDate) async {
    try {
      this.serviceProviderTimetable = await providerService
          .getServiceProviderTimetables(serviceProvider.id, startDate, endDate);
      notifyListeners();
      return this.serviceProviderTimetable;
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
      throw (error);
    }
  }

  Future<List<Car>> loadCars({String filterValue = ''}) async {
    try {
      var response = await this._carService.getCars();
      cars =
          response.items.where((car) => car.status != CarStatus.Sold).toList();
      notifyListeners();
      return cars;
    } catch (error) {
      throw (error);
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

    for (ServiceProviderItem item in selectedServiceItems) {
      appointmentRequest.serviceIds.add(item.id);
    }

    if (selectedProvider != null) {
      appointmentRequest.providerId = selectedProvider.id;
      appointmentRequest.address = selectedProvider.address;
    }

    if (pickupPosition != null &&
        pickupPosition.isValid() &&
        returnPosition != null &&
        returnPosition.isValid()) {
      appointmentRequest.pickupPosition = pickupPosition;
      appointmentRequest.returnPosition = returnPosition;
    }

    appointmentRequest.scheduledTime = dateEntry.dateForAppointment();
    return appointmentRequest;
  }

  bool pickUpServiceValidation() {
    ServiceProviderItem serviceItem = this.selectedServiceItems.firstWhere(
        (element) => element.isPickUpAndReturnService(),
        orElse: () => null);
    return !(serviceItem != null && this.selectedServiceItems.length == 1);
  }

  generateStateData(bool showCarSelection) {
    if (!showCarSelection) {
      stepStateData = {
        0: {"state": FAStepstate.indexed, "active": true, "title": Text("")},
        1: {"state": FAStepstate.disabled, "active": false, "title": Text("")},
        2: {"state": FAStepstate.disabled, "active": false, "title": Text("")},
        3: {"state": FAStepstate.disabled, "active": false, "title": Text("")},
        4: {"state": FAStepstate.disabled, "active": false, "title": Text("")},
        5: {"state": FAStepstate.disabled, "active": false, "title": Text("")},
        6: {"state": FAStepstate.disabled, "active": false, "title": Text("")},
      };
    } else {
      stepStateData = {
        0: {"state": FAStepstate.indexed, "active": true, "title": Text("")},
        1: {"state": FAStepstate.disabled, "active": false, "title": Text("")},
        2: {"state": FAStepstate.disabled, "active": false, "title": Text("")},
        3: {"state": FAStepstate.disabled, "active": false, "title": Text("")},
        4: {"state": FAStepstate.disabled, "active": false, "title": Text("")},
        5: {"state": FAStepstate.disabled, "active": false, "title": Text("")},
        6: {"state": FAStepstate.disabled, "active": false, "title": Text("")},
        7: {"state": FAStepstate.disabled, "active": false, "title": Text("")},
      };
    }
  }

  bool needSetupLocation() {
    if (selectedServiceItems.length == 0) {
      return false;
    }
    return this.selectedServiceItems.firstWhere(
            (element) => element.isPickUpAndReturnService(),
            orElse: () => null) !=
        null;
  }

  bool hasTowService() {
    ServiceProviderItem serviceItem = selectedServiceItems
        .firstWhere((element) => element.isTowService(), orElse: () => null);

    return serviceItem != null;
  }
}
