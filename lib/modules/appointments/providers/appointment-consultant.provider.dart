import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/models/work-estimate-details.model.dart';
import 'package:app/modules/cars/models/car-timetable.model.dart';
import 'package:app/modules/cars/models/request/car-timetable-request.model.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/shop/models/shop-item.model.dart';
import 'package:app/modules/shop/services/shop.service.dart';
import 'package:app/modules/work-estimate-form/services/work-estimates.service.dart';
import 'package:app/modules/appointments/model/personnel/employee.dart';
import 'package:app/utils/date_utils.dart';
import 'package:flutter/cupertino.dart';

class AppointmentConsultantProvider with ChangeNotifier {
  final AppointmentsService _appointmentsService =
      inject<AppointmentsService>();
  final ProviderService _providerService = inject<ProviderService>();
  final WorkEstimatesService _workEstimatesService =
      inject<WorkEstimatesService>();
  final CarService _carService = inject<CarService>();
  final ShopService _shopService = inject<ShopService>();

  Appointment selectedAppointment;
  AppointmentDetail selectedAppointmentDetail;
  WorkEstimateDetails workEstimateDetails;
  List<ServiceProviderItem> serviceProviderItems = [];

  List<Employee> employees = [];
  List<CarTimetable> carTimetable = [];
  ShopItem shopItem;

  bool initDone = false;

  initialise() {
    carTimetable = [];
    initDone = false;
    selectedAppointment = null;
    selectedAppointmentDetail = null;
    serviceProviderItems = [];
    shopItem = null;
  }

  Future<AppointmentDetail> getAppointmentDetails(
      Appointment appointment) async {
    try {
      selectedAppointmentDetail =
          await this._appointmentsService.getAppointmentDetails(appointment.id);
      notifyListeners();
      return selectedAppointmentDetail;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<ServiceProviderItem>> getProviderServices(int id) async {
    try {
      var response = await _providerService.getProviderServiceItems(id);
      serviceProviderItems = response.items;
      notifyListeners();
      return serviceProviderItems;
    } catch (error) {
      throw (error);
    }
  }

  Future<Appointment> cancelAppointment(Appointment appointment) async {
    try {
      selectedAppointment =
          await this._appointmentsService.cancelAppointment(appointment.id);
      notifyListeners();
      return selectedAppointment;
    } catch (error) {
      throw (error);
    }
  }

  Future<WorkEstimateDetails> getWorkEstimateDetails(int workEstimateId) async {
    try {
      workEstimateDetails = await this
          ._workEstimatesService
          .getWorkEstimateDetails(workEstimateId);
      notifyListeners();
      return workEstimateDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future<AppointmentDetail> finishAppointment(int appointmentId) async {
    try {
      selectedAppointmentDetail =
          await _appointmentsService.finishAppointment(appointmentId);
      notifyListeners();
      return selectedAppointmentDetail;
    } catch (error) {
      throw (error);
    }
  }

  Future<AppointmentDetail> completeAppointment(int appointmentId) async {
    try {
      selectedAppointmentDetail =
      await _appointmentsService.completeAppointment(appointmentId);
      notifyListeners();
      return selectedAppointmentDetail;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<CarTimetable>> getCarTimetable(
      CarTimetableRequest request) async {
    try {
      this.carTimetable = await this._carService.getCarTimetable(request);
      notifyListeners();
      return this.carTimetable;
    } catch (error) {
      throw (error);
    }
  }

  Future<ShopItem> getShopItemDetails(int promotionId) async {
    try {
      this.shopItem = await _shopService.getShopItemDetails(promotionId);
      notifyListeners();
      return shopItem;
    } catch (error) {
      throw (error);
    }
  }

  getCarTimetableRequest() {
    CarTimetableRequest request = new CarTimetableRequest();
    request.carId = this.selectedAppointment?.car?.id;
    request.startDate = this.shopItem?.startDate;
    request.endDate = this.shopItem?.endDate;
    return request;
  }
}
