import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/services/bid.service.dart';
import 'package:flutter/cupertino.dart';

class AppointmentProvider with ChangeNotifier {
  AppointmentsService _appointmentsService = inject<AppointmentsService>();
  BidsService _bidsService = inject<BidsService>();

  bool initDone = false;

  Appointment selectedAppointment;
  AppointmentDetail selectedAppointmentDetail;

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

  Future<bool> cancelBid(int bidId) async {
    try {
      bool response = await this._bidsService.rejectBid(bidId);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> acceptBid(int bidId) async {
    try {
      bool response = await this._bidsService.acceptBid(bidId);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }
}
