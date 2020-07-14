import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/cars/enums/car-status.enum.dart';
import 'package:app/modules/appointments/model/appointment-position.model.dart';
import 'package:app/modules/appointments/model/appointment/appointment-provider-type.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/model/personnel/time-entry.dart';
import 'package:app/modules/appointments/model/provider/service-provider-timetable.model.dart';
import 'package:app/modules/appointments/model/request/appointment-request.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/shop/models/shop-item.model.dart';
import 'package:flutter/cupertino.dart';

class ShopAppointmentProvider with ChangeNotifier {
  CarService _carService = inject<CarService>();
  ProviderService _providerService = inject<ProviderService>();
  AppointmentsService _appointmentsService = inject<AppointmentsService>();

  List<Car> cars;
  List<ServiceProviderTimetable> timetables = [];

  ShopItem shopItem;

  Car selectedCar;

  String searchString;

  DateEntry dateEntry;

  DateTime startDateTime;
  DateTime endDateTime;

  ServiceProvider serviceProvider;
  Car car;

  AppointmentPosition pickupPosition = new AppointmentPosition();
  AppointmentPosition returnPosition = new AppointmentPosition();

  initialise() {
    startDateTime = null;
    endDateTime = null;
    serviceProvider = null;
    shopItem = null;
    selectedCar = null;
    cars = [];
    searchString = '';
    dateEntry = null;
    timetables = [];
    car = null;
  }

  Future<List<Car>> loadCars() async {
    try {
      var response = await this._carService.getCars(searchString: searchString);
      cars = response.items.where((car) => car.status != CarStatus.Sold).toList();
      notifyListeners();
      return cars;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<ServiceProviderTimetable>> loadServiceProviderTimetables(
      int providerId, String startDate, String endDate) async {
    try {
      this.timetables = await _providerService.getServiceProviderTimetables(
          providerId, startDate, endDate);
      notifyListeners();
      return this.timetables;
    } catch (error) {
      throw (error);
    }
  }

  Future<Appointment> createAppointment(
      AppointmentRequest appointmentRequest) async {
    try {
      var appointment =
          await this._appointmentsService.createAppointment(appointmentRequest);
      notifyListeners();
      return appointment;
    } catch (error) {
      throw (error);
    }
  }

  Future<ServiceProvider> getServiceProvider(int providerId) async {
    try {
      serviceProvider = await this._providerService.getProviderDetails(providerId);
      notifyListeners();
      return serviceProvider;
    } catch (error) {
      throw (error);
    }
  }

  Future<Car> getCarDetails(int carId) async {
    try {
      car = await this._carService.getCarDetails(carId);
      notifyListeners();
      return car;
    } catch (error) {
      throw (error);
    }
  }

  AppointmentRequest getAppointmentRequest() {
    AppointmentRequest request = new AppointmentRequest();
    request.serviceIds = [shopItem.service.id];
    request.carId = selectedCar.id;
    request.providerType = AppointmentProviderType.Specific;

    request.issues = [];
    request.providerId = shopItem.providerId;
    request.promotionId = shopItem.id;
    request.scheduledTime = dateEntry.dateForAppointment();
    request.issues = [shopItem.title];

    return request;
  }
}
