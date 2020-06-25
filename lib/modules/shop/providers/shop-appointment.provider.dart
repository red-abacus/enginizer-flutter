import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment-position.model.dart';
import 'package:app/modules/appointments/model/personnel/time-entry.dart';
import 'package:app/modules/appointments/model/provider/service-provider-timetable.model.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/shop/models/shop-appointment-issue.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShopAppointmentProvider with ChangeNotifier {
  CarService carService = inject<CarService>();
  ProviderService _providerService = inject<ProviderService>();

  List<Car> cars;
  List<ShopAppointmentIssue> issues;
  List<ServiceProviderTimetable> timetables = [];

  Car selectedCar;

  String searchString;

  DateEntry dateEntry;

  AppointmentPosition pickupPosition = new AppointmentPosition();
  AppointmentPosition returnPosition = new AppointmentPosition();

  initialiseParameters() {
    selectedCar = null;
    cars = [];
    searchString = '';
    issues = [];
    dateEntry = null;
    timetables = [];
  }

  Future<List<Car>> loadCars() async {
    try {
      var response = await this.carService.getCars(searchString: searchString);
      cars = response.items;
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
}
